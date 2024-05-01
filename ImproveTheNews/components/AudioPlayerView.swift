//
//  AudioPlayerView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/06/2023.
//

import Foundation
import UIKit
import AVKit

let AudioPlayerViewNotification_timeUpdated = Notification.Name("AudioPlayerView_timeUpdated")
let AudioPlayerViewNotification_timeCompleted = Notification.Name("AudioPlayerView_timeCompleted")
let AudioPlayerViewNotification_statusUpdated = Notification.Name("AudioPlayerView_statusUpdated")

class AudioPlayerView: UIView {
    
    private var primary: Bool = true
    private var secondary: Bool = false
    
    private var wasBuilt = false
    private var duration: CGFloat = 0
    private var sliderIsPressed = false
    private var wasCompleted = false
    
    // Open/Close
    private var isOpen = false
    private var heightConstraint: NSLayoutConstraint!
    private var heightClosed: CGFloat = 75
    private var heightOpened: CGFloat = 200
    
    // Play/Pause
    private var isPlaying = false
    private var playTimes: Int = 0
    
    // Components
    private var mainHStack = UIStackView()
    private let playImageView1 = UIImageView()
    private var playButton1 = UIButton(type: .custom)
    private var upDownArrowImageView = UIImageView()
    private var innerContainer: UIStackView!
    private var slider = UISlider()
    private var timeLabel = UILabel()
    private let playImageView2 = UIImageView()
    
    // AVPlayer
    private var player: AVPlayer?
    private var playerObserver: Any?
    
    // MARK: - Init(s)
    init(secondary: Bool = false) {
        self.primary = !secondary
        self.secondary = secondary
        
        super.init(frame: CGRect.zero)
        self.addNotificationObservers()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ containerView: UIView, file: AudioFile) {
        if(self.wasBuilt) { return }
        self.duration = CGFloat(file.duration)
        
        //let containerVStack = containerView as? UIStackView
        if(self.secondary) {
            self.mainHStack = HSTACK(into: containerView)
            
            if(IPHONE()) {
                self.mainHStack.activateConstraints([
                    self.mainHStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    self.mainHStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    self.mainHStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
            } else {
                self.mainHStack.activateConstraints([
                    self.mainHStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    self.mainHStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    self.mainHStack.widthAnchor.constraint(equalToConstant: 435)
                ])
            }
        } else {
            //self.mainHStack = HSTACK(into: containerView as! UIStackView)
        }
        
        var bottomMargin: CGFloat = 0
        if(self.secondary) {
            if let _margin = SAFE_AREA()?.bottom, _margin>0 {
                bottomMargin = 22
            }
        }
        self.heightClosed += bottomMargin
        self.heightOpened += bottomMargin
        
        self.heightConstraint = self.mainHStack.heightAnchor.constraint(equalToConstant: self.heightClosed)
        self.heightConstraint.isActive = true
        
        var hMargin: CGFloat = 13
        if(self.secondary){ hMargin = 0 }
        
        ADD_SPACER(to: self.mainHStack, width: hMargin)
            let colorRect = UIView()
            colorRect.backgroundColor = CSS.shared.displayMode().audioPlayer_bgColor
            
            //DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xEAEBEC)
            self.mainHStack.addArrangedSubview(colorRect)
        ADD_SPACER(to: self.mainHStack, width: hMargin)
        
        // -------
//        let colorLine = UIView()
//        colorLine.backgroundColor = UIColor(hex: 0xDA4933)
//        colorRect.addSubview(colorLine)
//        colorLine.activateConstraints([
//            colorLine.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
//            colorLine.topAnchor.constraint(equalTo: colorRect.topAnchor),
//            colorLine.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor),
//            colorLine.widthAnchor.constraint(equalToConstant: 4)
//        ])
        
        let podcastIcon = UIImageView(image: UIImage(named: "podcast"))
        //let podcastIcon = UIImageView(image: UIImage(named: "podcast")?.withRenderingMode(.alwaysTemplate))
        //podcastIcon.tintColor = UIColor(hex: 0xDA4933)
        colorRect.addSubview(podcastIcon)
        podcastIcon.activateConstraints([
            podcastIcon.widthAnchor.constraint(equalToConstant: 40),
            podcastIcon.heightAnchor.constraint(equalToConstant: 40),
            podcastIcon.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor, constant: 20),
            podcastIcon.topAnchor.constraint(equalTo: colorRect.topAnchor, constant: 18)
        ])
        
        let listenLabel = UILabel()
        listenLabel.font = DM_SERIF_DISPLAY(24) //MERRIWEATHER_BOLD(14)
        listenLabel.text = "Listen to this story"
        listenLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        colorRect.addSubview(listenLabel)
        listenLabel.activateConstraints([
            listenLabel.leadingAnchor.constraint(equalTo: podcastIcon.trailingAnchor, constant: 10),
            listenLabel.centerYAnchor.constraint(equalTo: podcastIcon.centerYAnchor)
        ])
        
        self.upDownArrowImageView.image = UIImage(named: self.primary ? DisplayMode.imageName("arrow.down") : DisplayMode.imageName("arrow.up"))
        colorRect.addSubview(self.upDownArrowImageView)
        self.upDownArrowImageView.activateConstraints([
            self.upDownArrowImageView.widthAnchor.constraint(equalToConstant: 32),
            self.upDownArrowImageView.heightAnchor.constraint(equalToConstant: 32),
            self.upDownArrowImageView.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor, constant: -15),
            self.upDownArrowImageView.centerYAnchor.constraint(equalTo: podcastIcon.centerYAnchor)
        ])
        
        let upDownbuttonArea = UIButton(type: .custom)
        colorRect.addSubview(upDownbuttonArea)
        upDownbuttonArea.activateConstraints([
            upDownbuttonArea.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            upDownbuttonArea.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            upDownbuttonArea.topAnchor.constraint(equalTo: colorRect.topAnchor),
            upDownbuttonArea.heightAnchor.constraint(equalToConstant: 50)
        ])
        upDownbuttonArea.addTarget(self, action: #selector(upDownButtonAreaOnTap(_:)), for: .touchUpInside)
        
        colorRect.addSubview(self.playImageView1)
        self.playImageView1.activateConstraints([
            self.playImageView1.widthAnchor.constraint(equalToConstant: 32),
            self.playImageView1.heightAnchor.constraint(equalToConstant: 32),
            self.playImageView1.trailingAnchor.constraint(equalTo: self.upDownArrowImageView.leadingAnchor, constant: -15),
            self.playImageView1.centerYAnchor.constraint(equalTo: self.upDownArrowImageView.centerYAnchor)
        ])
        self.playImageView1.image = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
        self.playImageView1.tintColor = UIColor(hex: 0xF3643C)
        self.playImageView1.hide()
        
        colorRect.addSubview(self.playButton1)
        self.playButton1.activateConstraints([
            self.playButton1.leadingAnchor.constraint(equalTo: self.playImageView1.leadingAnchor, constant: -5),
            self.playButton1.trailingAnchor.constraint(equalTo: self.playImageView1.trailingAnchor, constant: 5),
            self.playButton1.topAnchor.constraint(equalTo: self.playImageView1.topAnchor, constant: -5),
            self.playButton1.bottomAnchor.constraint(equalTo: self.playImageView1.bottomAnchor, constant: 5)
        ])
        self.playButton1.hide()
        self.playButton1.addTarget(self, action: #selector(playButtonOnTap(_:)), for: .touchUpInside)
        
        // ------------
        self.innerContainer = VSTACK(into: colorRect)
        self.innerContainer.backgroundColor = self.backgroundColor //.systemPink
        self.innerContainer.activateConstraints([
            self.innerContainer.topAnchor.constraint(equalTo: podcastIcon.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.innerContainer.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            self.innerContainer.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor), //-24-5
            
            self.innerContainer.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let colorSubRect = UIView()
        colorSubRect.backgroundColor = self.backgroundColor //.green
        self.innerContainer.addArrangedSubview(colorSubRect)
        colorSubRect.activateConstraints([
            colorSubRect.heightAnchor.constraint(equalToConstant: 105)
        ])
        
        let ITNImageView = UIImageView(image: UIImage(named: "ITN_podcast"))
        colorSubRect.addSubview(ITNImageView)
        ITNImageView.activateConstraints([
            ITNImageView.widthAnchor.constraint(equalToConstant: 89),
            ITNImageView.heightAnchor.constraint(equalToConstant: 89),
            ITNImageView.leadingAnchor.constraint(equalTo: colorSubRect.leadingAnchor, constant: 20),
            ITNImageView.topAnchor.constraint(equalTo: colorSubRect.topAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        
        let components = file.created.components(separatedBy: " ")
        var firstPart = ""
        for (i, C) in components.enumerated() {
            firstPart += C
            if(i == components.count-2) {
                firstPart += ", "
            } else {
                firstPart += " "
            }
        }
        
        firstPart = firstPart.replacingOccurrences(of: ",,", with: ",")
        
        let textStart = firstPart + ": "
        let text = textStart + file.title
        //titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        titleLabel.font = AILERON(16)
        titleLabel.textColor = CSS.shared.displayMode().sec_textColor
        titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.7)
        
        colorSubRect.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: ITNImageView.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            titleLabel.topAnchor.constraint(equalTo: ITNImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: colorSubRect.trailingAnchor, constant: -32-15-15)
        ])
                
//        titleLabel.text = text + " " + text
        titleLabel.attributedText = prettifyText(fullString: text as NSString, boldPartsOfString: [textStart as NSString],
            font: AILERON(16), boldFont: AILERON_BOLD(16), paths: [], linkedSubstrings: [], accented: [])

        colorSubRect.addSubview(self.playImageView2)
        self.playImageView2.activateConstraints([
            self.playImageView2.widthAnchor.constraint(equalToConstant: 32),
            self.playImageView2.heightAnchor.constraint(equalToConstant: 32),
            self.playImageView2.trailingAnchor.constraint(equalTo: colorSubRect.trailingAnchor, constant: -15),
            self.playImageView2.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
        self.playImageView2.image = UIImage(named: DisplayMode.imageName("play.circle.new"))
        
        let playButton2 = UIButton(type: .custom)
        colorSubRect.addSubview(playButton2)
        playButton2.activateConstraints([
            playButton2.leadingAnchor.constraint(equalTo: self.playImageView2.leadingAnchor, constant: -5),
            playButton2.trailingAnchor.constraint(equalTo: self.playImageView2.trailingAnchor, constant: 5),
            playButton2.topAnchor.constraint(equalTo: self.playImageView2.topAnchor, constant: -5),
            playButton2.bottomAnchor.constraint(equalTo: self.playImageView2.bottomAnchor, constant: 5)
        ])
        playButton2.addTarget(self, action: #selector(playButtonOnTap(_:)), for: .touchUpInside)
        
        
        
        
        let sliderHStack = HSTACK(into: colorSubRect)
        sliderHStack.spacing = 8
        sliderHStack.activateConstraints([
            sliderHStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sliderHStack.bottomAnchor.constraint(equalTo: ITNImageView.bottomAnchor),
            sliderHStack.trailingAnchor.constraint(equalTo: self.playImageView2.trailingAnchor),
            sliderHStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.value = 0
        self.slider.isContinuous = true
        self.slider.minimumTrackTintColor = CSS.shared.displayMode().audioPlayer_sliderTrack_color
        //DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xEAEBEC)
        self.slider.maximumTrackTintColor = self.slider.minimumTrackTintColor
        //self.slider.setThumbImage(UIImage(named: DisplayMode.imageName("slidersGrayThumb")), for: .normal)
        self.slider.setThumbImage(UIImage(named: "slidersOrangeThumb"), for: .normal)

        sliderHStack.addArrangedSubview(self.slider)
        self.slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderOnTouchDown(_:)), for: .touchDown)
        self.slider.addTarget(self, action: #selector(sliderOnTouchUp(_:)), for: .touchUpInside)
        
        self.timeLabel.font = CSS.shared.iPhoneStoryContent_textFont
        self.timeLabel.textAlignment = .center
        //self.timeLabel.text = "00:00"
        self.updateTime(-1)
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        
        //sliderHStack.addArrangedSubview(self.timeLabel)
        colorSubRect.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.widthAnchor.constraint(equalToConstant: 45),
            self.timeLabel.trailingAnchor.constraint(equalTo: sliderHStack.trailingAnchor),
            self.timeLabel.topAnchor.constraint(equalTo: sliderHStack.bottomAnchor, constant: -5)
        ])
        
        
        
//        ADD_SPACER(to: self.innerContainer, height: 10)
//        let platformsLabel = UILabel()
//        platformsLabel.text = "Or listen to this story on the following platforms"
//        platformsLabel.font = ROBOTO(13)
//        platformsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
//        self.innerContainer.addArrangedSubview(platformsLabel)
//        
//        ADD_SPACER(to: self.innerContainer, height: 10)
//        let podcastStack = HSTACK(into: self.innerContainer, spacing: 9)
//        for i in 1...4 {
//            let img = UIImage(named: DisplayMode.imageName("podcast_\(i)"))?.withRenderingMode(.alwaysOriginal)
//        
//            let podcastButton = UIButton(type: .system)
//            podcastButton.backgroundColor = .clear //.black
//            podcastButton.setImage(img, for: .normal)
//            podcastStack.addArrangedSubview(podcastButton)
//            podcastButton.activateConstraints([
//                podcastButton.widthAnchor.constraint(equalToConstant: 48),
//                podcastButton.heightAnchor.constraint(equalToConstant: 48)
//            ])
//            podcastButton.tag = 20 + i
//            podcastButton.addTarget(self, action: #selector(onPodcastButtonTap(_:)), for: .touchUpInside)
//        }
//        ADD_SPACER(to: podcastStack)
        
        
        // ----------
        ADD_SPACER(to: self.innerContainer)
        if(self.primary) {
            ADD_SPACER(to: containerView as! UIStackView, height: 5)
        }
        
        self.innerContainer.hide()
        if(self.primary){ self.startPlayerWith(url: file.file) }
        self.wasBuilt = true
        
//        if(self.secondary) {
//            self.mainHStack.hide()
//        }
    }
    
    func customHide() {
        if(!self.mainHStack.isHidden && self.mainHStack.alpha==1.0) {
            UIView.animate(withDuration: 0.3) {
                self.mainHStack.alpha = 0.0
            } completion: { _ in
                self.mainHStack.hide()
                self.mainHStack.alpha = 1.0
            }
        }
    }
    
    func customShow() {
        if(self.mainHStack.isHidden) {
            self.mainHStack.alpha = 0.0
            self.mainHStack.show()
            UIView.animate(withDuration: 0.3) {
                self.mainHStack.alpha = 1.0
            }
        }
    }
    
    func getHeight() -> CGFloat {
        if let _constraint = self.heightConstraint {
            return _constraint.constant
        } else {
            return 0
        }
    }
    
    // MARK: - Event(s)
    @objc func upDownButtonAreaOnTap(_ sender: UIButton?) {
        self.isOpen = !self.isOpen
        self.playImageView1.hide()
        self.playButton1.hide()
        
        if(self.isOpen) {
            self.heightConstraint.constant = self.heightOpened
            self.upDownArrowImageView.image = UIImage(named: self.primary ? DisplayMode.imageName("arrow.up") : DisplayMode.imageName("arrow.down"))
            self.playImageView1.hide()
            
            self.innerContainer.alpha = 0
            self.innerContainer.show()
            UIView.animate(withDuration: 0.5) {
                self.innerContainer.alpha = 1.0
            }
        } else {
            self.heightConstraint.constant = self.heightClosed
            self.upDownArrowImageView.image = UIImage(named: self.primary ? DisplayMode.imageName("arrow.down") : DisplayMode.imageName("arrow.up"))
            if(self.playTimes>0){
                self.playButton1.show()
                self.playImageView1.show()
            }
            self.innerContainer.hide()
        }
    }
    
    @objc func onPodcastButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 20
        
        var url: String?
        switch(tag) {
            case 1:
                url = "https://podcasts.apple.com/us/podcast/improve-the-news/id1618971104?ign-itscg=30200&ign-itsct=podcast_box_player"
            case 2:
                url = "https://open.spotify.com/show/6f0N5HoyXABPBM8vS0iI8H"
            case 3:
                url = "https://music.amazon.com/podcasts/f5de9928-7979-4710-ab1a-13dc22007e70/improve-the-news"
            case 4:
                url = "https://www.youtube.com/playlist?list=PLDJZZqlKlvx4wm6206Vgq3s1dFPIP78p8"
  
            default:
                url = nil
        }
        
        
        if let _url = url {
            OPEN_URL(_url)
        }
    }
    
    @objc func sliderOnTouchDown(_ sender: UISlider?) {
        self.sliderIsPressed = true
    }
    @objc func sliderOnTouchUp(_ sender: UISlider?) {
        self.sliderIsPressed = false
    }
    
    @objc func sliderOnValueChange(_ sender: UISlider) {
        let seconds = (CGFloat(sender.value) * self.duration)/100
        self.updateTime(seconds)
        
        if(self.primary) {
            self.player?.seek(to: CMTime(value: CMTimeValue(seconds), timescale: 1))
        }
        
        let info: [String : Any] = [
            "isPrimary": self.primary,
            "value": sender.value,
            "time": seconds
        ]
        NOTIFY(AudioPlayerViewNotification_timeUpdated, userInfo: info)
    }
    
    private func updateTime(_ secs: CGFloat) {
        var _secs = secs
        if(_secs == -1){ _secs = self.duration }
        
        let minutes = Int(_secs/60)
        let seconds = Int(_secs)-(minutes*60)
        self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func playButtonOnTap(_ sender: UIButton?) {
        self.playTimes += 1
        self.isPlaying = !self.isPlaying
        
        if(self.isPlaying) {
            self.playImageView2.image = UIImage(named: DisplayMode.imageName("pause.circle.new"))
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            
            self.player?.play()
        } else {
            self.playImageView2.image = UIImage(named: DisplayMode.imageName("play.circle.new"))
            self.player?.pause()
        }
        self.playImageView1.image = self.playImageView2.image
        
        let info: [String : Any] = [
            "isPrimary": self.primary,
            "status": self.isPlaying
        ]
        NOTIFY(AudioPlayerViewNotification_statusUpdated, userInfo: info)
    }
}

// MARK: - Attributed text
extension AudioPlayerView {
    
    private func prettifyText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, paths: [String], linkedSubstrings: [String], accented: [String]) -> NSAttributedString {

        let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font!, NSAttributedString.Key.foregroundColor: CSS.shared.displayMode().sec_textColor]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let accentedAttribute:  [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xD3592D), NSAttributedString.Key.strokeWidth: -5]
        
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        for l in 0..<paths.count {
            let sbstrRange = fullString.range(of: linkedSubstrings[l])
            boldString.addAttribute(.link, value: paths[l], range: sbstrRange)
        }
        for a in 0..<accented.count {
            let sbstrRange = fullString.range(of: accented[a])
            
            boldString.addAttributes(accentedAttribute, range: sbstrRange)
        }
        return boldString
    }
}


// MARK: - Custom type
struct AudioFile {
    var file: String = ""
    var duration: Int = 0
    var created: String = ""
    var title: String = ""
    
    init(file: String, duration: Int, created: String, title: String) {
        self.file = file
        self.duration = duration
        self.created = created
        self.title = title
    }
}

extension AudioPlayerView {
    
    func startPlayerWith(url: String) {
        let item = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem: item)
        
        let interval = CMTime(value: CMTimeValue(1), timescale: 1)
        self.playerObserver = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (time) in
            self.updateTime(time.seconds)
            let info: [String : Any] = [
                "isPrimary": self.primary,
                "value": self.slider.value,
                "time": CGFloat(time.seconds)
            ]
            NOTIFY(AudioPlayerViewNotification_timeUpdated, userInfo: info)
            
            if(!self.sliderIsPressed) {
                let perc = (time.seconds * 100)/self.duration
                self.slider.value = Float(perc)
            }
            
            if((Int(time.seconds) >= Int(self.duration) && self.isPlaying) && !self.wasCompleted) {
                self.wasCompleted = true
                DELAY(1.0) {
                    self.player?.seek(to: CMTime(value: CMTimeValue(0), timescale: 1))
                    self.player?.pause()
                    
                    self.playButtonOnTap(nil)
                    self.slider.value = 0
                    self.wasCompleted = false
                    
                    DELAY(0.1) {
                        self.updateTime(-1)
                        if(self.primary){ NOTIFY(AudioPlayerViewNotification_timeCompleted) }
                    }
                }
            }
        })
    }
    
    func close() {
        //print("CLOSE")
        self.player?.removeTimeObserver(self.playerObserver!)
        self.playerObserver = nil
        self.player = nil
    }
    
}

// MARK: - Notification(s)
extension AudioPlayerView {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onTimeUpdated),
            name: AudioPlayerViewNotification_timeUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onTimeCompleted),
            name: AudioPlayerViewNotification_timeCompleted, object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onStatusUpdated),
            name: AudioPlayerViewNotification_statusUpdated, object: nil)
    }
    
    @objc func onTimeUpdated(_ notification: Notification) {
        if let _info = notification.userInfo as? [String: Any] {
            let senderIsPrimary = _info["isPrimary"] as! Bool
            let sliderValue = _info["value"] as! Float
            let seconds = _info["time"] as! CGFloat
            
            self.updateTime(seconds)
            self.slider.value = sliderValue
            
            if(!senderIsPrimary) {
                self.player?.seek(to: CMTime(value: CMTimeValue(seconds), timescale: 1))
            }
        }
    }
    
    @objc func onTimeCompleted(_ notification: Notification) {
        if(self.secondary) {
            self.updateTime(-1)
        }
    }
    
    @objc func onStatusUpdated(_ notification: Notification) {
        if let _info = notification.userInfo as? [String: Any] {
            let senderIsPrimary = _info["isPrimary"] as! Bool
            let status = _info["status"] as! Bool
            
            if(self.secondary) { // Sender primary
                self.playTimes += 1
                self.isPlaying = status
                
                if(self.isPlaying) {
                    self.playImageView2.image = UIImage(named: DisplayMode.imageName("pause.circle.new"))
                } else {
                    self.playImageView2.image = UIImage(named: DisplayMode.imageName("play.circle.new"))
                }
                self.playImageView1.image = self.playImageView2.image
            } else { // Sender secondary
                self.playTimes += 1
                self.isPlaying = status
                
                if(self.isPlaying) {
                    self.playImageView2.image = UIImage(named: DisplayMode.imageName("pause.circle.new"))
                    self.player?.play()
                } else {
                    self.playImageView2.image = UIImage(named: DisplayMode.imageName("play.circle.new"))
                    self.player?.pause()
                }
                self.playImageView1.image = self.playImageView2.image
            }
            
            if(self.playTimes>0 && !self.isOpen){
                self.playButton1.show()
                self.playImageView1.show()
            }
        }
    }
    
}


