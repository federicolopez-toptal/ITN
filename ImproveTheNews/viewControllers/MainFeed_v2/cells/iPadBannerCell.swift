//
//  iPadBannerCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadBannerCell: UITableViewCell {

    static let identifier = "iPadBannerCell"

    let mainContainer = UIView()
    let closeIcon = UIImageView()
    let headerLabel = UILabel()
    let descrLabel = UILabel()
    let dontShowAgainLabel = UILabel()
    let checkImage = UIImageView()
    
    let mainImageView = UIImageView()
    var imageWidthConstraint: NSLayoutConstraint?
    var imageHeightConstraint: NSLayoutConstraint?
    
    private var bannerURL = ""
    private var bannerCode = ""
    private var dontShowAgain = false
    
    
    

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        let margin = IPAD_ITEMS_SEP
    
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin)
        ])
        
        let vLine = UIView()
        vLine.backgroundColor = UIColor(hex: 0xDA4933)
        self.mainContainer.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor),
            vLine.topAnchor.constraint(equalTo: self.mainContainer.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))?.withRenderingMode(.alwaysTemplate)
        self.closeIcon.backgroundColor = .clear
        self.mainContainer.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 24),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 24),
            self.closeIcon.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: margin),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -margin)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.mainContainer.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        let hStack = HSTACK(into: self.mainContainer)
        hStack.backgroundColor = .clear //.yellow.withAlphaComponent(0.1)
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -margin),
            hStack.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: margin*3),
            //hStack.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -margin*2)
        ])
        
            let vStackImage = VSTACK(into: hStack)
            vStackImage.backgroundColor = .clear //.green
            self.imageWidthConstraint = vStackImage.widthAnchor.constraint(equalToConstant: 350)
            vStackImage.activateConstraints([
                self.imageWidthConstraint!
            ])

            vStackImage.addArrangedSubview(self.mainImageView)
            self.mainImageView.backgroundColor = .clear //.cyan
            self.imageHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 100)
            self.mainImageView.activateConstraints([
                self.imageHeightConstraint!
            ])
            self.mainImageView.contentMode = .scaleAspectFit // non-stretched
            ADD_SPACER(to: vStackImage, backgroundColor: .clear, height: 50)

            let imageButton = UIButton(type: .system)
            imageButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            vStackImage.addSubview(imageButton)
            imageButton.activateConstraints([
                imageButton.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: 0),
                imageButton.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: 0),
                imageButton.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 0),
                imageButton.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 0),
            ])
            imageButton.addTarget(self, action: #selector(onImageButtonTap(_:)), for: .touchUpInside)


        ADD_SPACER(to: hStack, width: margin)
        
            let vStackTexts = VSTACK(into: hStack)
            vStackTexts.backgroundColor = .clear //.cyan
            ADD_SPACER(to: vStackTexts, height: margin*2)
            
            self.headerLabel.numberOfLines = 0
            self.headerLabel.font = DM_SERIF_DISPLAY_fixed(26) //MERRIWEATHER_BOLD(26)
            self.headerLabel.text = "Header text"
            vStackTexts.addArrangedSubview(self.headerLabel)
            
            ADD_SPACER(to: vStackTexts, height: margin)
            self.descrLabel.numberOfLines = 0
            self.descrLabel.font = DM_SERIF_DISPLAY_fixed(16) //MERRIWEATHER(16)
            self.descrLabel.text = "Description text"
            vStackTexts.addArrangedSubview(self.descrLabel)
            
            ADD_SPACER(to: vStackTexts, height: margin*2)
                let hStackCheck = HSTACK(into: vStackTexts, spacing: 10)
                hStackCheck.backgroundColor = .clear //.orange
                hStackCheck.activateConstraints([
                    hStackCheck.heightAnchor.constraint(equalToConstant: 18)
                ])
            
                let square = UIImageView(image: UIImage(named: "banner.check.square"))
                hStackCheck.addArrangedSubview(square)
                NSLayoutConstraint.activate([
                    square.widthAnchor.constraint(equalToConstant: 18),
                    square.heightAnchor.constraint(equalToConstant: 18)
                ])
                
                self.dontShowAgainLabel.textColor = .black
                self.dontShowAgainLabel.backgroundColor = .clear //.yellow
                self.dontShowAgainLabel.font = ROBOTO(15)
                self.dontShowAgainLabel.numberOfLines = 1
                self.dontShowAgainLabel.text = "Don't show this again"
                hStackCheck.addArrangedSubview(self.dontShowAgainLabel)

                self.checkImage.image = UIImage(named: "slidersPanel.split.check")
                hStackCheck.addSubview(self.checkImage)
                self.checkImage.activateConstraints([
                    self.checkImage.widthAnchor.constraint(equalToConstant: 18),
                    self.checkImage.heightAnchor.constraint(equalToConstant: 14),
                    self.checkImage.leadingAnchor.constraint(equalTo: hStackCheck.leadingAnchor, constant: 5),
                    self.checkImage.topAnchor.constraint(equalTo: hStackCheck.topAnchor, constant: 0)
                ])
                self.checkImage.hide()
                
                let checkButton = UIButton(type: .system)
                checkButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                hStackCheck.addSubview(checkButton)
                checkButton.activateConstraints([
                    checkButton.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: -5),
                    checkButton.topAnchor.constraint(equalTo: square.topAnchor, constant: -5),
                    checkButton.bottomAnchor.constraint(equalTo: square.bottomAnchor, constant: 5),
                    checkButton.widthAnchor.constraint(equalToConstant: 200)
                ])
                checkButton.addTarget(self, action: #selector(onCheckButtonTap(_:)), for: .touchUpInside)

            ADD_SPACER(to: vStackTexts)

        ADD_SPACER(to: hStack, width: margin*2)
    }
    
    func populate(with banner: Banner) {
        //banner.trace()
        self.mainImageView.image = nil
        if let _url = URL(string: banner.imgUrl) {
            self.mainImageView.sd_setImage(with: _url) { (img, error, cacheType, url) in
                if let _img = img {
                    let W: CGFloat = 350
                    let H = (_img.size.height * W)/_img.size.width

                    self.imageWidthConstraint?.constant = W
                    self.imageHeightConstraint?.constant = H
                }
            }
        }
    
        self.bannerURL = banner.url
        self.bannerCode = banner.code
    
        self.headerLabel.text = banner.headerText
        self.descrLabel.text = banner.mainText
    
//        if self.readStatus() == nil {
//            self.writeStatus(1) // Just show the banner, no user interaction
//        }
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE9EAEB)
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))?.withRenderingMode(.alwaysTemplate)
        self.headerLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.descrLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.dontShowAgainLabel.textColor = self.descrLabel.textColor
        
        self.closeIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
}

extension iPadBannerCell {

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
    
    // MARK: - Event(s)
    @objc func onCheckButtonTap(_ sender: UIButton) {
        self.checkImage.isHidden = !self.checkImage.isHidden
        self.dontShowAgain = !self.checkImage.isHidden
    }
    
    @objc func onImageButtonTap(_ sender: UIButton) {
        self.writeStatus(4) // Click on image
        
        var url = self.bannerURL
        if(url.isEmpty){ url = "https://www.youtube.com/watch?v=PRLF17Pb6vo" }
        OPEN_URL(url)
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
    
    // MARK: - misc
    private func writeStatus(_ num: Int) {
        let key = LocalKeys.misc.bannerPrefix + self.bannerCode
        WRITE(key, value: "0" + String(num))
        self.addThisBannerToCodes()
    }
    
    private func readStatus() -> String? {
        let key = LocalKeys.misc.bannerPrefix + self.bannerCode
        return READ(key)
    }
    
    private func addThisBannerToCodes() {
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            var allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            var found = false
            for bCode in allBannerCodes {
                if(bCode == self.bannerCode) {
                    found = true
                    break
                }
            }
            
            if(!found) {
                allBannerCodes.append(self.bannerCode)
                let newStringArray = allBannerCodes.joined(separator: ",")
                WRITE(LocalKeys.misc.allBannerCodes, value: newStringArray)
            }
            
        } else {
            WRITE(LocalKeys.misc.allBannerCodes, value: self.bannerCode)
        }
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
    }
}
