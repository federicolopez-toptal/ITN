//
//  BannerCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/09/2022.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    static let identifier = "BannerCell"
        
    let mainContainer = UIView()
    let mainImageView = UIImageView()
    var imageHeightConstraint: NSLayoutConstraint?
    
    let headerLabel = BannerCell.createHeaderLabel(text: "Lorem ipsum")
    let textLabel = BannerCell.createTextLabel(text: "Lorem ipsum")
    let dontShowAgainLabel = UILabel()
    let checkImage = UIImageView()
    let closeIcon = UIImageView()
    
    private var bannerURL = ""
    private var bannerCode = ""
    private var dontShowAgain = false
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 25),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        let vLine = UIView()
        vLine.backgroundColor = UIColor(hex: 0xFF643C)
        self.mainContainer.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor),
            vLine.topAnchor.constraint(equalTo: self.mainContainer.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        let vStack = VSTACK(into: self.mainContainer, spacing: 10)
        vStack.backgroundColor = .clear //.yellow.withAlphaComponent(0.25)
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 15+4),
            vStack.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -15),
            vStack.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -16)
        ])
    
        self.mainImageView.backgroundColor = .systemPink
        vStack.addArrangedSubview(self.mainImageView)
        self.imageHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 10)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: vStack.topAnchor),
            self.imageHeightConstraint!
        ])
        self.mainImageView.contentMode = .scaleAspectFit // non-stretched
            
        let imageButton = UIButton(type: .system)
        imageButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        vStack.addSubview(imageButton)
        imageButton.activateConstraints([
            imageButton.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: 0),
            imageButton.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: 0),
            imageButton.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 0),
            imageButton.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 0),
        ])
        imageButton.addTarget(self, action: #selector(onImageButtonTap(_:)), for: .touchUpInside)
    
        // -----------------------------
        vStack.addArrangedSubview(self.headerLabel)
        vStack.addArrangedSubview(self.textLabel)
    
        // -----------------------------
        let hStack = HSTACK(into: vStack, spacing: 10)
        hStack.backgroundColor = .clear //.orange
        vStack.addArrangedSubview(hStack)
        hStack.activateConstraints([
            hStack.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        let square = UIImageView(image: UIImage(named: "banner.check.square"))
        hStack.addArrangedSubview(square)
        NSLayoutConstraint.activate([
            square.widthAnchor.constraint(equalToConstant: 18),
            square.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        self.dontShowAgainLabel.textColor = .black
        self.dontShowAgainLabel.backgroundColor = .clear //.yellow
        self.dontShowAgainLabel.font = ROBOTO(15)
        self.dontShowAgainLabel.numberOfLines = 1
        self.dontShowAgainLabel.text = "Don't show this again"
        hStack.addArrangedSubview(self.dontShowAgainLabel)
        
        self.checkImage.image = UIImage(named: "slidersPanel.split.check")
        hStack.addSubview(self.checkImage)
        self.checkImage.activateConstraints([
            self.checkImage.widthAnchor.constraint(equalToConstant: 18),
            self.checkImage.heightAnchor.constraint(equalToConstant: 14),
            self.checkImage.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: 5),
            self.checkImage.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 0)
        ])
        self.checkImage.hide()
        
        let checkButton = UIButton(type: .system)
        checkButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        hStack.addSubview(checkButton)
        checkButton.activateConstraints([
            checkButton.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: -5),
            checkButton.topAnchor.constraint(equalTo: square.topAnchor, constant: -5),
            checkButton.bottomAnchor.constraint(equalTo: square.bottomAnchor, constant: 5),
            checkButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        checkButton.addTarget(self, action: #selector(onCheckButtonTap(_:)), for: .touchUpInside)
        
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))
        self.closeIcon.backgroundColor = .clear //.systemPink
        vStack.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 24),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 24),
            self.closeIcon.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 0),
            self.closeIcon.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 5),
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        vStack.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        
        self.refreshDisplayMode()
    }
    
    func populate(with banner: Banner?) {
        guard let _banner = banner else {
            return
        }
        
        //_banner.trace()
        self.mainImageView.image = nil
//        if(Layout.current() == .textImages) {
            if let _url = URL(string: _banner.imgUrl) {
                self.mainImageView.sd_setImage(with: _url) { (img, error, cacheType, url) in
                    if let _img = img {
                        var mustRefresh = false
                        if(Banner.imageHeight == nil) {
                            mustRefresh = true
                        }
                    
                        let W: CGFloat = SCREEN_SIZE().width - 16-16-19-15
                        let H = (_img.size.height * W)/_img.size.width
                        
                        if(Banner.imageHeight != nil) {
                            if(Banner.imageHeight != H) {
                                mustRefresh = true
                            }
                        }
                        Banner.imageHeight = H
                        self.imageHeightConstraint?.constant = H
                        
                        if(mustRefresh) { NOTIFY(Notification_refreshMainFeed) }
                    }
                }
            } else {
                self.imageHeightConstraint?.constant = 0
                Banner.imageHeight = nil
            }
//        } else {
//            self.imageHeightConstraint?.constant = 0
//        }
        
        self.bannerURL = _banner.url
        self.bannerCode = _banner.code
        
        self.headerLabel.text = _banner.headerText
        self.textLabel.text = _banner.mainText
    
//        if self.readStatus() == nil {
//            self.writeStatus(1) // Just show the banner, no user interaction
//        }

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        self.headerLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.textLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.dontShowAgainLabel.textColor = self.textLabel.textColor
        
        
    return
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))
    }
    
    static func calculateHeight(headerText: String, text: String, width: CGFloat) -> CGSize {
        let W: CGFloat = width-16-16-19-15
        
        let tmpHeader = BannerCell.createHeaderLabel(text: headerText)
        let headerHeight = tmpHeader.calculateHeightFor(width: W)
        
        let tmpText = BannerCell.createTextLabel(text: text)
        let textHeight = tmpText.calculateHeightFor(width: W)
        
        let hStackHeight: CGFloat = 18
        var H: CGFloat = 25+16+10+headerHeight+10+textHeight+10+hStackHeight+16
        if let _imageHeight = Banner.imageHeight {
            H += _imageHeight
        }
        
        return CGSize(width: width, height: H)
    }
    
}

// MARK: - UI Util(s)
extension BannerCell {

    static func createHeaderLabel(text: String) -> UILabel {
        let result = UILabel()
        result.backgroundColor = .clear
        result.textColor = .black
        result.numberOfLines = 4
        result.font = MERRIWEATHER_BOLD(16)
        result.text = text
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        
        return result
    }
    
    static func createTextLabel(text: String) -> UILabel {
        let result = UILabel()
        result.backgroundColor = .clear
        result.textColor = .black
        result.numberOfLines = 4
        result.font = ROBOTO(15)
        result.text = text
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        
        return result
    }
    
}


// MARK: - Store settings locally
extension BannerCell {
    
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

// MARK: - Event(s)
extension BannerCell {
    
    @objc func onImageButtonTap(_ sender: UIButton) {
        self.writeStatus(4) // Click on image
        
        var url = self.bannerURL
        if(url.isEmpty){ url = "https://www.youtube.com/watch?v=PRLF17Pb6vo" }
        OPEN_URL(url)
    }

    @objc func onCheckButtonTap(_ sender: UIButton) {
        self.checkImage.isHidden = !self.checkImage.isHidden
        self.dontShowAgain = !self.checkImage.isHidden
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
    
    
    
}
