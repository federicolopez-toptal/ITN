//
//  iPhoneBannerPodCast_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/01/2024.
//

import Foundation
import UIKit

class iPhoneBannerPodCast_v3: CustomCellView_v3 {

    private var WIDTH: CGFloat = 1
    
    let closeIcon = UIImageView(image: UIImage(named: "closeIcon_noBg")?.withRenderingMode(.alwaysTemplate))
    let titleLabel = UILabel()
    
    let gotItView = UIView()
    let gotItLabel = UILabel()
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        
        self.buildContent()
    }

    private func buildContent() {
        self.layer.cornerRadius = 6
        
        self.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 24),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 24),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            self.closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11)
        ])
        
        let closeButton = UIButton(type: .system)
        //closeButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        let podcastIcon = UIImageView(image: UIImage(named: "podcast"))
        self.addSubview(podcastIcon)
        podcastIcon.activateConstraints([
            podcastIcon.widthAnchor.constraint(equalToConstant: 48),
            podcastIcon.heightAnchor.constraint(equalToConstant: 48),
            podcastIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            podcastIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(23)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = "Listen to\nour podcast"
        self.titleLabel.setLineSpacing(lineSpacing: 6)
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: podcastIcon.bottomAnchor, constant: 15)
        ])
    
        var iconsDim: CGFloat = 48
        var iconsSep: CGFloat = 9
        let iconsCount: CGFloat = 3
        var sumW: CGFloat = (iconsDim * iconsCount) + (iconsSep * (iconsCount-1))
    
        if(sumW > self.WIDTH-32) {
            let availableSpace = self.WIDTH-32-(iconsSep * (iconsCount-1))
            iconsDim = availableSpace/iconsCount
            
            sumW = (iconsDim * iconsCount) + (iconsSep * (iconsCount-1))
        }
    
        let iconsContainer = UIView()
        iconsContainer.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(iconsContainer)
        iconsContainer.activateConstraints([
            iconsContainer.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            iconsContainer.heightAnchor.constraint(equalToConstant: iconsDim),
            iconsContainer.widthAnchor.constraint(equalToConstant: sumW)
        ])
        
        if(IPHONE()) {
            iconsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        } else {
            iconsContainer.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        }
    
        var posX: CGFloat = 0
        let icons = [1, 2, 3]
        
        for i in 1...Int(iconsCount) {
            let pcIcon = UIImageView(image: UIImage(named: "podcast_" + String(icons[i-1]) + ".dark"))
            iconsContainer.addSubview(pcIcon)
            pcIcon.activateConstraints([
                pcIcon.leadingAnchor.constraint(equalTo: iconsContainer.leadingAnchor, constant: posX),
                pcIcon.topAnchor.constraint(equalTo: iconsContainer.topAnchor, constant: 0),
                pcIcon.widthAnchor.constraint(equalToConstant: iconsDim),
                pcIcon.heightAnchor.constraint(equalToConstant: iconsDim)
            ])
            
            let button = UIButton(type: .system)
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            iconsContainer.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: pcIcon.leadingAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: pcIcon.trailingAnchor, constant: 5),
                button.topAnchor.constraint(equalTo: pcIcon.topAnchor, constant: -5),
                button.bottomAnchor.constraint(equalTo: pcIcon.bottomAnchor, constant: 5)
            ])
            button.tag = 300 + i
            button.addTarget(self, action: #selector(onPodcastIconButtonTap), for: .touchUpInside)
            
            posX += iconsDim + iconsSep
        }
        
        self.addSubview(self.gotItView)
        self.gotItView.activateConstraints([
            self.gotItView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gotItView.topAnchor.constraint(equalTo: self.topAnchor),
            self.gotItView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gotItView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.gotItLabel.numberOfLines = 0
        self.gotItLabel.font = DM_SERIF_DISPLAY(20)
        self.gotItLabel.text = "Got it!\nWe won't show you this ad again :)"
        self.gotItLabel.setLineSpacing(lineSpacing: 6)
        self.gotItLabel.textAlignment = .center
        self.gotItView.addSubview(self.gotItLabel)
        self.gotItLabel.activateConstraints([
            self.gotItLabel.centerYAnchor.constraint(equalTo: self.gotItView.centerYAnchor),
            self.gotItLabel.leadingAnchor.constraint(equalTo: self.gotItView.leadingAnchor, constant: 16),
            self.gotItLabel.trailingAnchor.constraint(equalTo: self.gotItView.trailingAnchor, constant: -16)
        ])
    
        self.gotItView.hide()
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
        self.closeIcon.tintColor = CSS.shared.displayMode().sec_textColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        
        self.gotItView.backgroundColor = self.backgroundColor
        self.gotItLabel.textColor = self.titleLabel.textColor
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = self.WIDTH - 16 - 16
        let result: CGFloat = 15 + 48 + 15 + self.titleLabel.calculateHeightFor(width: W) + 16 + 48 + 30
        
        return result 
    }

     @objc func onPodcastIconButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        
        var url: String?
        switch(tag) {
            case 1:
                url = "https://podcasts.apple.com/us/podcast/improve-the-news/id1618971104?ign-itscg=30200&ign-itsct=podcast_box_player"
            case 2:
                url = "https://open.spotify.com/show/6f0N5HoyXABPBM8vS0iI8H"
            
            case 3:
                url = "https://music.amazon.com/podcasts/f5de9928-7979-4710-ab1a-13dc22007e70/improve-the-news"
            
            default:
                NOTHING()
        }
        
        if let _url = url {
            OPEN_URL(_url)
        }
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.gotItView.show()
        self.writeStatus(2) // Clicked on "Close" - Don't show again OFF
    }
    
}

extension iPhoneBannerPodCast_v3 {

    private func writeStatus(_ num: Int) {
        WRITE(LocalKeys.misc.bannerPrefix + "pC", value: "0" + String(num))
        self.addBannerToCodes(code: "pC")
        
        WRITE(LocalKeys.misc.bannerPrefix + "yT", value: "0" + String(num))
        self.addBannerToCodes(code: "yT")
    }
    
    private func addBannerToCodes(code: String) {
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            var allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            var found = false
            for bCode in allBannerCodes {
                if(bCode == code) {
                    found = true
                    break
                }
            }
            
            if(!found) {
                allBannerCodes.append(code)
                let newStringArray = allBannerCodes.joined(separator: ",")
                WRITE(LocalKeys.misc.allBannerCodes, value: newStringArray)
            }
            
        } else {
            WRITE(LocalKeys.misc.allBannerCodes, value: code)
        }
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
    }

}
