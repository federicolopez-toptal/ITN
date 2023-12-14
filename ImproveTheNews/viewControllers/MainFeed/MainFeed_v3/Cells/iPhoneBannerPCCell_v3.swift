//
//  iPhoneBannerPCCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/12/2023.
//

import UIKit

class iPhoneBannerPCCell_v3: UITableViewCell {

    static let identifier = "iPhoneBannerPCCell_v3"
    private var banner: Banner!
    private var dontShowAgain = false
    
    let containerView = UIView()
    let closeIcon = UIImageView(image: UIImage(named: "closeIcon_noBg")?.withRenderingMode(.alwaysTemplate))
    let titleLabel = UILabel()
    let subTextLabel = UILabel()
    let checkLabel = UILabel()
    let checkImage = UIImageView()
    
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.contentView.addSubview(self.containerView)
        self.containerView.activateConstraints([
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        self.containerView.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 24),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 24),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -11),
            self.closeIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 11)
        ])
        
        let closeButton = UIButton(type: .system)
        //closeButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.containerView.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        let podcastIcon = UIImageView(image: UIImage(named: "podcast"))
        self.containerView.addSubview(podcastIcon)
        podcastIcon.activateConstraints([
            podcastIcon.widthAnchor.constraint(equalToConstant: 56),
            podcastIcon.heightAnchor.constraint(equalToConstant: 56),
            podcastIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24),
            podcastIcon.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(28)
        self.titleLabel.text = "Listen to our podcast"
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: podcastIcon.bottomAnchor, constant: 6)
        ])
        
        self.subTextLabel.font = AILERON(16)
        self.subTextLabel.text = "We’re on Youtube, Spotify & Apple"
        self.containerView.addSubview(self.subTextLabel)
        self.subTextLabel.activateConstraints([
            self.subTextLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            self.subTextLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10)
        ])
        
        var posX: CGFloat = 15
        let icons = [1, 4, 2]
        
        for i in 1...3 {
            let pcIcon = UIImageView(image: UIImage(named: "podcast_" + String(icons[i-1]) + ".dark"))
            self.containerView.addSubview(pcIcon)
            pcIcon.activateConstraints([
                pcIcon.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: posX),
                pcIcon.topAnchor.constraint(equalTo: self.subTextLabel.bottomAnchor, constant: 20),
                pcIcon.widthAnchor.constraint(equalToConstant: 48),
                pcIcon.heightAnchor.constraint(equalToConstant: 48)
            ])
            
            let button = UIButton(type: .system)
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            self.containerView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: pcIcon.leadingAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: pcIcon.trailingAnchor, constant: 5),
                button.topAnchor.constraint(equalTo: pcIcon.topAnchor, constant: -5),
                button.bottomAnchor.constraint(equalTo: pcIcon.bottomAnchor, constant: 5)
            ])
            button.tag = 300 + i
            button.addTarget(self, action: #selector(onPodcastIconButtonTap), for: .touchUpInside)
            
            posX += 48 + 9
        }
        
        //////////////////////////////////
        let checkSquare = UIImageView(image: UIImage(named: "banner.check.square"))
        self.containerView.addSubview(checkSquare)
        checkSquare.activateConstraints([
            checkSquare.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            checkSquare.topAnchor.constraint(equalTo: self.subTextLabel.bottomAnchor, constant: 20 + 48 + 20),
            checkSquare.widthAnchor.constraint(equalToConstant: 18),
            checkSquare.heightAnchor.constraint(equalToConstant: 18)
        ])
           
        let checkButton = UIButton(type: .system)
        self.containerView.addSubview(checkButton)
        checkButton.activateConstraints([
            checkButton.leadingAnchor.constraint(equalTo: checkSquare.leadingAnchor, constant: -5),
            checkButton.topAnchor.constraint(equalTo: checkSquare.topAnchor, constant: -5),
            checkButton.bottomAnchor.constraint(equalTo: checkSquare.bottomAnchor, constant: 5),
            checkButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        checkButton.addTarget(self, action: #selector(onCheckButtonTap(_:)), for: .touchUpInside)
           
        self.checkLabel.font = AILERON(14)
        self.checkLabel.text = "Don't show this again".uppercased()
        self.containerView.addSubview(self.checkLabel)
        self.checkLabel.activateConstraints([
            self.checkLabel.leadingAnchor.constraint(equalTo: checkSquare.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.checkLabel.centerYAnchor.constraint(equalTo: checkSquare.centerYAnchor)
        ])
        
        self.checkImage.image = UIImage(named: "slidersPanel.split.check")
        self.containerView.addSubview(self.checkImage)
        self.checkImage.activateConstraints([
            self.checkImage.widthAnchor.constraint(equalToConstant: 18),
            self.checkImage.heightAnchor.constraint(equalToConstant: 14),
            self.checkImage.leadingAnchor.constraint(equalTo: checkSquare.leadingAnchor, constant: 5),
            self.checkImage.topAnchor.constraint(equalTo: checkSquare.topAnchor, constant: 0)
        ])
        self.checkImage.hide()
    }
    
    func populate(with banner: Banner) {
        self.banner = banner
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.containerView.backgroundColor = CSS.shared.displayMode().banner_bgColor
        self.closeIcon.tintColor = CSS.shared.displayMode().sec_textColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.subTextLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.checkLabel.textColor = CSS.shared.displayMode().sec_textColor
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = SCREEN_SIZE().width - 16
        let H: CGFloat = 24 + 56 + 6 + self.titleLabel.calculateHeightFor(width: W) +
                            10 + self.subTextLabel.calculateHeightFor(width: W) +
                            20 + 48 + 65
                            
        return H
    }
    
    @objc func onPodcastIconButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        
        var url: String?
        switch(tag) {
            case 1:
                url = "https://podcasts.apple.com/us/podcast/improve-the-news/id1618971104?ign-itscg=30200&ign-itsct=podcast_box_player"
            case 2:
                url = "https://www.youtube.com/playlist?list=PLDJZZqlKlvx4wm6206Vgq3s1dFPIP78p8"
            
            case 3:
                url = "https://open.spotify.com/show/6f0N5HoyXABPBM8vS0iI8H"
            
            default:
                NOTHING()
        }
        
        if let _url = url {
            OPEN_URL(_url)
        }
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        if(self.dontShowAgain) {
            self.writeStatus(3) // Clicked on "Close" - Don't show again ON
            WRITE(LocalKeys.misc.bannerDontShowAgain, value: "1")

            NOTIFY(Notification_reloadMainFeed)
        } else {
            self.writeStatus(2) // Clicked on "Close" - Don't show again OFF
            NOTIFY(Notification_removeBanner)
        }
    }
    
    @objc func onCheckButtonTap(_ sender: UIButton) {
        self.checkImage.isHidden = !self.checkImage.isHidden
        self.dontShowAgain = !self.checkImage.isHidden
    }
    
    private func writeStatus(_ num: Int) {
        let key = LocalKeys.misc.bannerPrefix + self.banner!.code
        WRITE(key, value: "0" + String(num))
        self.addThisBannerToCodes()
    }
    
    private func addThisBannerToCodes() {
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            var allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            var found = false
            for bCode in allBannerCodes {
                if(bCode == self.banner!.code) {
                    found = true
                    break
                }
            }
            
            if(!found) {
                allBannerCodes.append(self.banner!.code)
                let newStringArray = allBannerCodes.joined(separator: ",")
                WRITE(LocalKeys.misc.allBannerCodes, value: newStringArray)
            }
            
        } else {
            WRITE(LocalKeys.misc.allBannerCodes, value: self.banner!.code)
        }
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
    }

}



