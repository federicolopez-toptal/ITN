//
//  iPhoneBannerCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPhoneBannerCell_v3: UITableViewCell {

    static let identifier = "iPhoneBannerCell_v3"
    static var lastBannerLoaded: String = ""
    
    private var banner: Banner!
    private var dontShowAgain = false
    
    let containerView = UIView()
    let mainImageView = CustomImageView()
    var imageHeightConstraint: NSLayoutConstraint?
    let titleLabel = UILabel()
    let descrLabel = UILabel()
    let checkLabel = UILabel()
    
    let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.close")))
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
        
        self.containerView.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.mainImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        self.imageHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 200)
        self.imageHeightConstraint?.isActive = true
        
        let imageButton = UIButton(type: .system)
        self.containerView.addSubview(imageButton)
        imageButton.activateConstraints([
            imageButton.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: 0),
            imageButton.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: 0),
            imageButton.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 0),
            imageButton.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 0),
        ])
        imageButton.addTarget(self, action: #selector(onImageButtonTap(_:)), for: .touchUpInside)
        
        self.titleLabel.font = CSS.shared.iPhoneBanner_titleFont
        self.titleLabel.numberOfLines = 0
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        
        self.descrLabel.font = CSS.shared.iPhoneBanner_textFont
        self.descrLabel.numberOfLines = 0
        self.containerView.addSubview(self.descrLabel)
        self.descrLabel.activateConstraints([
            self.descrLabel.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor),
            self.descrLabel.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor),
            self.descrLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4)
        ])
            
        /////////////////////////////////////////////////////////////////////////////
        let checkSquare = UIImageView(image: UIImage(named: "banner.check.square"))
        self.containerView.addSubview(checkSquare)
        checkSquare.activateConstraints([
            checkSquare.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor),
            checkSquare.topAnchor.constraint(equalTo: self.descrLabel.bottomAnchor, constant: (CSS.shared.iPhoneSide_padding*2)),
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
           
        self.checkLabel.font = CSS.shared.iPhoneBanner_textFont
        self.checkLabel.text = "Don't show this again"
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
        
        ////////////////////////////////////////////////////////
        self.containerView.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 32),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 32),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.closeIcon.centerYAnchor.constraint(equalTo: checkSquare.centerYAnchor)
        ])

        let closeButton = UIButton(type: .system)
        self.containerView.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    }
    
    func populate(with banner: Banner) {
        self.banner = banner
        
        self.mainImageView.showCorners(false)
        self.mainImageView.load(url: self.banner.imgUrl) { (success, imgSize) in
            if success, let _imgSize = imgSize {
                let compW = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 2)
                let compH = (_imgSize.height * compW)/_imgSize.width
                self.imageHeightConstraint?.constant = compH
                
                if(self.banner.code != iPhoneBannerCell_v3.lastBannerLoaded) {
                    iPhoneBannerCell_v3.lastBannerLoaded = self.banner.code
                    NOTIFY(Notification_refreshMainFeed)
                }
            }
        }
        
        self.titleLabel.text = self.banner.headerText
        self.descrLabel.text = self.banner.mainText
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.containerView.backgroundColor = CSS.shared.displayMode().banner_bgColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.descrLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.checkLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("circle.close"))
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding)
        
        return CSS.shared.iPhoneSide_padding + self.imageHeightConstraint!.constant +
                CSS.shared.iPhoneSide_padding + self.titleLabel.calculateHeightFor(width: W) + 4 +
                self.descrLabel.calculateHeightFor(width: W) + (CSS.shared.iPhoneSide_padding*2) + 18 +
                (CSS.shared.iPhoneSide_padding * 2)
    }
    
    ///////////////////////////////////////////////////////////////////////////
    static func heightFor(banner: Banner) -> CGFloat {
        var result: CGFloat = 1
        
        //print("CODE", banner.code)
        switch(banner.code) {
            case "pC":
                result = 350
            case "yT":
                result = 360
            case "lO":
                result = 265
        
            default:
                result = 500
        }
        
        return result
    }
    
}

// MARK: Action(s)
extension iPhoneBannerCell_v3 {

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
    
    @objc func onImageButtonTap(_ sender: UIButton) {
        self.writeStatus(4) // Click on image
        
        var url = self.banner.url
        if(url.isEmpty){ url = "https://www.youtube.com/watch?v=PRLF17Pb6vo" }
        OPEN_URL(url)
    }
    
    @objc func onCheckButtonTap(_ sender: UIButton) {
        self.checkImage.isHidden = !self.checkImage.isHidden
        self.dontShowAgain = !self.checkImage.isHidden
    }
}

// MARK: misc
extension iPhoneBannerCell_v3 {
    
    private func writeStatus(_ num: Int) {
        let key = LocalKeys.misc.bannerPrefix + self.banner!.code
        WRITE(key, value: "0" + String(num))
        self.addThisBannerToCodes()
    }
    
    private func readStatus() -> String? {
        let key = LocalKeys.misc.bannerPrefix + self.banner!.code
        return READ(key)
    }
    
    /////////////////////////////////////////////
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


