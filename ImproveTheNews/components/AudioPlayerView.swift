//
//  AudioPlayerView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/06/2023.
//

import Foundation
import UIKit


class AudioPlayerView: UIView {
    
    private var mainHStack_heightConstraint: NSLayoutConstraint!
    private let heightClosed: CGFloat = 50
    private let heightOpened: CGFloat = 250
    
    private var isOpen = false
    private var wasBuilt = false
    private var duration: CGFloat = 0
    
    private var upDownArrowImageView = UIImageView()
    private var innerContainer: UIStackView!
    private var timeLabel = UILabel()
    
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
        //mainHStack.backgroundColor = .yellow
        
//        self.isOpen = false
//        self.mainHStack_heightConstraint = mainHStack.heightAnchor.constraint(equalToConstant: self.heightClosed)
        self.isOpen = true
        self.mainHStack_heightConstraint = mainHStack.heightAnchor.constraint(equalToConstant: self.heightOpened)

        self.mainHStack_heightConstraint.isActive = true

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
        
        let buttonArea = UIButton(type: .custom)
        //buttonArea.backgroundColor = .red.withAlphaComponent(0.25)
        colorRect.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: colorRect.topAnchor),
            buttonArea.heightAnchor.constraint(equalToConstant: 50)
        ])
        buttonArea.addTarget(self, action: #selector(buttonAreaOnTap(_:)), for: .touchUpInside)
        
        // ------------
        self.innerContainer = VSTACK(into: colorRect)
        //self.innerContainer.backgroundColor = .yellow.withAlphaComponent(0.2)
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
        //titleLabel.backgroundColor = .blue.withAlphaComponent(0.4)      
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
        //sliderHStack.backgroundColor = .green
        sliderHStack.spacing = 8
        sliderHStack.activateConstraints([
            sliderHStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sliderHStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            sliderHStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            sliderHStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let slider = UISlider()
        //slider.backgroundColor = .blue.withAlphaComponent(0.3)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 0
        slider.isContinuous = true
        slider.minimumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x1D2530) : UIColor(hex: 0xEAEBEC)
        slider.maximumTrackTintColor = slider.minimumTrackTintColor
        slider.setThumbImage(UIImage(named: "audioPlayerThumb"), for: .normal)
        sliderHStack.addArrangedSubview(slider)
        slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
        
        self.timeLabel.font = ROBOTO(13)
        self.timeLabel.textAlignment = .center
        self.timeLabel.text = "01:00"
        //self.timeLabel.backgroundColor = .red
        self.timeLabel.textColor = UIColor(hex: 0x93A0B4)
        sliderHStack.addArrangedSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
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
        self.wasBuilt = true
    }
    
    // MARK: - Event(s)
    @objc func buttonAreaOnTap(_ sender: UIButton?) {
        self.isOpen = !self.isOpen
        
        if(self.isOpen) {
            self.mainHStack_heightConstraint.constant = self.heightOpened
            self.upDownArrowImageView.image = UIImage(named: "arrow.up")
            self.innerContainer.show()
        } else {
            self.mainHStack_heightConstraint.constant = self.heightClosed
            self.upDownArrowImageView.image = UIImage(named: "arrow.down")
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
    
    @objc func sliderOnValueChange(_ sender: UISlider) {
        self.updateTimeFromSlider(CGFloat(sender.value))
    }
    
    private func updateTimeFromSlider(_ value: CGFloat) {
        let currentSeconds = (value * self.duration)/100        
        let minutes = Int(currentSeconds/60)
        let seconds = Int(currentSeconds)-(minutes*60)

        self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
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
