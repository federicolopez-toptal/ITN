//
//  AudioPlayerView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/06/2023.
//

import Foundation
import UIKit
import AVKit


class AudioPlayerView: UIView {
    
    private var wasBuilt = false
    private var duration: CGFloat = 0
    private var sliderIsPressed = false
    private var wasCompleted = false
    
    // Open/Close
    private var isOpen = false
    private var heightConstraint: NSLayoutConstraint!
    private let heightClosed: CGFloat = 50
    private let heightOpened: CGFloat = 250
    
    // Play/Pause
    private var isPlaying = false
    private var playTimes: Int = 0
    
    // Components
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
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ containerVStack: UIStackView, file: AudioFile) {
        if(self.wasBuilt) { return }
        
        self.duration = CGFloat(file.duration)
    
        let mainHStack = HSTACK(into: containerVStack)
        self.heightConstraint = mainHStack.heightAnchor.constraint(equalToConstant: self.heightClosed)
        self.heightConstraint.isActive = true
        
        ADD_SPACER(to: mainHStack, width: 13)
            let colorRect = UIView()
            colorRect.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D2530) : UIColor(hex: 0xEAEBEC)
            mainHStack.addArrangedSubview(colorRect)
        ADD_SPACER(to: mainHStack, width: 13)
        
        // -------
        let colorLine = UIView()
        colorLine.backgroundColor = UIColor(hex: 0xF3643C)
        colorRect.addSubview(colorLine)
        colorLine.activateConstraints([
            colorLine.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            colorLine.topAnchor.constraint(equalTo: colorRect.topAnchor),
            colorLine.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor),
            colorLine.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        let podcastIcon = UIImageView(image: UIImage(named: "podcast"))
        colorRect.addSubview(podcastIcon)
        podcastIcon.activateConstraints([
            podcastIcon.widthAnchor.constraint(equalToConstant: 24),
            podcastIcon.heightAnchor.constraint(equalToConstant: 24),
            podcastIcon.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor, constant: 16),
            podcastIcon.topAnchor.constraint(equalTo: colorRect.topAnchor, constant: 13)
        ])
        
        let listenLabel = UILabel()
        listenLabel.font = MERRIWEATHER_BOLD(14)
        listenLabel.text = "Listen to this story"
        listenLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        colorRect.addSubview(listenLabel)
        listenLabel.activateConstraints([
            listenLabel.leadingAnchor.constraint(equalTo: podcastIcon.trailingAnchor, constant: 10),
            listenLabel.centerYAnchor.constraint(equalTo: podcastIcon.centerYAnchor)
        ])
        
        self.upDownArrowImageView.image = UIImage(named: "arrow.down")
        colorRect.addSubview(self.upDownArrowImageView)
        self.upDownArrowImageView.activateConstraints([
            self.upDownArrowImageView.widthAnchor.constraint(equalToConstant: 24),
            self.upDownArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            self.upDownArrowImageView.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor, constant: -16),
            self.upDownArrowImageView.topAnchor.constraint(equalTo: colorRect.topAnchor, constant: 13)
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
            self.playImageView1.widthAnchor.constraint(equalToConstant: 25),
            self.playImageView1.heightAnchor.constraint(equalToConstant: 25),
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
        self.innerContainer.activateConstraints([
            self.innerContainer.topAnchor.constraint(equalTo: podcastIcon.bottomAnchor, constant: 10),
            self.innerContainer.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor, constant: 16),
            self.innerContainer.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor, constant: -16), //-24-5
            
            self.innerContainer.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let colorSubRect = UIView()
        colorSubRect.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0C121E) : .white
        self.innerContainer.addArrangedSubview(colorSubRect)
        colorSubRect.activateConstraints([
            colorSubRect.heightAnchor.constraint(equalToConstant: 105)
        ])
        
        let ITNImageView = UIImageView(image: UIImage(named: "ITN_podcast"))
        colorSubRect.addSubview(ITNImageView)
        ITNImageView.activateConstraints([
            ITNImageView.widthAnchor.constraint(equalToConstant: 89),
            ITNImageView.heightAnchor.constraint(equalToConstant: 89),
            ITNImageView.leadingAnchor.constraint(equalTo: colorSubRect.leadingAnchor, constant: 8),
            ITNImageView.topAnchor.constraint(equalTo: colorSubRect.topAnchor, constant: 8)
        ])
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        let textStart = file.created + ": "
        let text = textStart + file.title
        //titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        titleLabel.attributedText = prettifyText(fullString: text as NSString, boldPartsOfString: [textStart as NSString],
            font: ROBOTO(13), boldFont: ROBOTO_BOLD(13), paths: [], linkedSubstrings: [], accented: [])
        
        colorSubRect.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: ITNImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: ITNImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: colorSubRect.trailingAnchor, constant: -8)
        ])
        
        let sliderHStack = HSTACK(into: colorSubRect)
        sliderHStack.spacing = 8
        sliderHStack.activateConstraints([
            sliderHStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sliderHStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            sliderHStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            sliderHStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.value = 0
        self.slider.isContinuous = true
        self.slider.minimumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x1D2530) : UIColor(hex: 0xEAEBEC)
        self.slider.maximumTrackTintColor = self.slider.minimumTrackTintColor
        self.slider.setThumbImage(UIImage(named: "audioPlayerThumb"), for: .normal)
        sliderHStack.addArrangedSubview(self.slider)
        self.slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderOnTouchDown(_:)), for: .touchDown)
        self.slider.addTarget(self, action: #selector(sliderOnTouchUp(_:)), for: .touchUpInside)
        
        self.timeLabel.font = ROBOTO(13)
        self.timeLabel.textAlignment = .center
        self.timeLabel.text = "00:00"
        self.timeLabel.textColor = UIColor(hex: 0x93A0B4)
        sliderHStack.addArrangedSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        let playIconVStack = VSTACK(into: sliderHStack)
        sliderHStack.addArrangedSubview(playIconVStack)
        ADD_SPACER(to: playIconVStack, height: 2.5)
            playIconVStack.addArrangedSubview(self.playImageView2)
            self.playImageView2.activateConstraints([
                self.playImageView2.widthAnchor.constraint(equalToConstant: 25),
                self.playImageView2.heightAnchor.constraint(equalToConstant: 25)
            ])
            self.playImageView2.image = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
            self.playImageView2.tintColor = UIColor(hex: 0xF3643C)
        ADD_SPACER(to: playIconVStack, height: 2.5)
        
        let playButton2 = UIButton(type: .custom)
        sliderHStack.addSubview(playButton2)
        playButton2.activateConstraints([
            playButton2.leadingAnchor.constraint(equalTo: self.playImageView2.leadingAnchor, constant: -5),
            playButton2.trailingAnchor.constraint(equalTo: self.playImageView2.trailingAnchor, constant: 5),
            playButton2.topAnchor.constraint(equalTo: self.playImageView2.topAnchor, constant: -5),
            playButton2.bottomAnchor.constraint(equalTo: self.playImageView2.bottomAnchor, constant: 5)
        ])
        playButton2.addTarget(self, action: #selector(playButtonOnTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: self.innerContainer, height: 10)
        let platformsLabel = UILabel()
        platformsLabel.text = "Or listen to this story on the following platforms"
        platformsLabel.font = ROBOTO(13)
        platformsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        self.innerContainer.addArrangedSubview(platformsLabel)
        
        ADD_SPACER(to: self.innerContainer, height: 10)
        let podcastStack = HSTACK(into: self.innerContainer, spacing: 9)
        for i in 1...4 {
            let img = UIImage(named: DisplayMode.imageName("podcast_\(i)"))?.withRenderingMode(.alwaysOriginal)
        
            let podcastButton = UIButton(type: .system)
            podcastButton.backgroundColor = .clear //.black
            podcastButton.setImage(img, for: .normal)
            podcastStack.addArrangedSubview(podcastButton)
            podcastButton.activateConstraints([
                podcastButton.widthAnchor.constraint(equalToConstant: 48),
                podcastButton.heightAnchor.constraint(equalToConstant: 48)
            ])
            podcastButton.tag = 20 + i
            podcastButton.addTarget(self, action: #selector(onPodcastButtonTap(_:)), for: .touchUpInside)
        }
        ADD_SPACER(to: podcastStack)
        
        
        // ----------
        ADD_SPACER(to: self.innerContainer)
        ADD_SPACER(to: containerVStack, height: 5)
        
        self.innerContainer.hide()
        self.startPlayerWith(url: file.file)
        self.wasBuilt = true
    }
    
    // MARK: - Event(s)
    @objc func upDownButtonAreaOnTap(_ sender: UIButton?) {
        self.isOpen = !self.isOpen
        self.playImageView1.hide()
        self.playButton1.hide()
        
        if(self.isOpen) {
            self.heightConstraint.constant = self.heightOpened
            self.upDownArrowImageView.image = UIImage(named: "arrow.up")
            self.playImageView1.hide()
            
            self.innerContainer.alpha = 0
            self.innerContainer.show()
            UIView.animate(withDuration: 0.5) {
                self.innerContainer.alpha = 1.0
            }
        } else {
            self.heightConstraint.constant = self.heightClosed
            self.upDownArrowImageView.image = UIImage(named: "arrow.down")
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
        self.player?.seek(to: CMTime(value: CMTimeValue(seconds), timescale: 1))
    }
    
    private func updateTime(_ secs: CGFloat) {
        let minutes = Int(secs/60)
        let seconds = Int(secs)-(minutes*60)
        self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func playButtonOnTap(_ sender: UIButton?) {
        self.playTimes += 1
        self.isPlaying = !self.isPlaying
        
        if(self.isPlaying) {
            self.playImageView2.image = UIImage(systemName: "pause.circle")?.withRenderingMode(.alwaysTemplate)
            self.player?.play()
        } else {
            self.playImageView2.image = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
            self.player?.pause()
        }
        self.playImageView1.image = self.playImageView2.image
    }
}

// MARK: - Attributed text
extension AudioPlayerView {
    
    private func prettifyText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, paths: [String], linkedSubstrings: [String], accented: [String]) -> NSAttributedString {

        let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font!, NSAttributedString.Key.foregroundColor: DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)]
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
                    self.updateTime(0)
                    self.slider.value = 0
                    self.wasCompleted = false
                }
            }
        })
    }
    
    func close() {
        print("CLOSE")
        self.player?.removeTimeObserver(self.playerObserver!)
        self.playerObserver = nil
        self.player = nil
    }
    
}