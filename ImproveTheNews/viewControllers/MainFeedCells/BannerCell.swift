//
//  BannerCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/09/2022.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    static let identifier = "BannerCell"
    //private let HEIGHT: CGFloat = 1.0     Height based on content!
    
    private var bannerURL = ""
    private var dontShowAgain = false
    private var bannerCode = ""
        
    let mainContainer = UIView()
    let mainImageView = UIImageView()
    var mainImageHeightConstraint: NSLayoutConstraint?
    let headerLabel = UILabel()
    let textLabel = UILabel()
    let dontShowAgainLabel = UILabel()
    let checkImage = UIImageView()
    let closeIcon = UIImageView()
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: SCREEN_SIZE().width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        return layoutAttributes
    }
    
}

extension BannerCell {
    
    private func buildContent() {

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 200)
            self.contentView.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width)
        ])
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
        
        let sideLine = UIView()
        sideLine.backgroundColor = UIColor(hex: 0xFF643C)
        self.mainContainer.addSubview(sideLine)
        sideLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sideLine.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor),
            sideLine.topAnchor.constraint(equalTo: self.mainContainer.topAnchor),
            sideLine.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor),
            sideLine.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        let vStack = VSTACK(into: self.mainContainer, spacing: 10)
        vStack.backgroundColor = .clear //.systemPink
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -19),
            vStack.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10)
        ])
                
        self.mainImageView.backgroundColor = .darkGray
        vStack.addArrangedSubview(self.mainImageView)
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.mainImageHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 10)
        NSLayoutConstraint.activate([
            self.mainImageView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: vStack.topAnchor),
            self.mainImageHeightConstraint!
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        
        let imageButton = UIButton(type: .system)
        imageButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        vStack.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: -5),
            imageButton.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: -5),
            imageButton.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 5),
            imageButton.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 5),
        ])
        imageButton.addTarget(self, action: #selector(onImageButtonTap(_:)), for: .touchUpInside)
    
    // -------------------------------
    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 16)
    let roboto = UIFont(name: "Roboto-Regular", size: 15)
    
        self.headerLabel.backgroundColor = .clear
        self.headerLabel.textColor = .black
        self.headerLabel.numberOfLines = 4
        self.headerLabel.font = merriweather_bold
        self.headerLabel.text = "Test title"
        self.headerLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        vStack.addArrangedSubview(self.headerLabel)
        
        self.textLabel.backgroundColor = .clear
        self.textLabel.textColor = .black
        self.textLabel.numberOfLines = 4
        self.textLabel.font = roboto
        self.textLabel.text = "Test title"
        self.textLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        vStack.addArrangedSubview(self.textLabel)
        
        let hStack = HSTACK(into: vStack, spacing: 10)
        hStack.backgroundColor = .clear //.orange
        vStack.addArrangedSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
        self.dontShowAgainLabel.font = roboto
        self.dontShowAgainLabel.numberOfLines = 1
        self.dontShowAgainLabel.text = "Don't show this again"
        hStack.addArrangedSubview(self.dontShowAgainLabel)
        
        // -------------------------------
        self.checkImage.image = UIImage(named: "slidersPanel.split.check")
        hStack.addSubview(self.checkImage)
        self.checkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.checkImage.widthAnchor.constraint(equalToConstant: 18),
            self.checkImage.heightAnchor.constraint(equalToConstant: 14),
            self.checkImage.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: 5),
            self.checkImage.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 0)
        ])
        self.checkImage.hide()
        
        let checkButton = UIButton(type: .system)
        checkButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        hStack.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: -5),
            checkButton.topAnchor.constraint(equalTo: square.topAnchor, constant: -5),
            checkButton.bottomAnchor.constraint(equalTo: square.bottomAnchor, constant: 5),
            checkButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        checkButton.addTarget(self, action: #selector(onCheckButtonTap(_:)), for: .touchUpInside)
        
        // -------------------------------
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))
        self.closeIcon.backgroundColor = .clear //.systemPink
        vStack.addSubview(self.closeIcon)
        self.closeIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 24),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 24),
            self.closeIcon.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 0),
            self.closeIcon.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: -5),
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        vStack.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: vStack)
    }
    
    func populate(with banner: Banner) {
        self.mainImageView.image = nil
        if let _url = URL(string: banner.imgUrl) {
            self.mainImageView.sd_setImage(with: _url) { (img, error, cacheType, url) in
                if let _img = img {
                    let w: CGFloat = SCREEN_SIZE().width - 16 - 16 - 20 - 19
                    let h = (_img.size.height * w)/_img.size.width
                    self.mainImageHeightConstraint?.constant = h
                }
            }
        } else {
            self.mainImageHeightConstraint?.constant = 0
        }
        
        self.headerLabel.text = banner.headerText
        self.textLabel.text = banner.mainText
        
        self.bannerURL = banner.url
        self.bannerCode = banner.code
    
        if self.readStatus() == nil {
            self.writeStatus(1) // Just show the banner, no user interaction
        }
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xEAEBEC)
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        
        self.headerLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.textLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.dontShowAgainLabel.textColor = self.textLabel.textColor
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))
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
    }
    
}

// MARK: - Event(s)
extension BannerCell {
    
    @objc func onCheckButtonTap(_ sender: UIButton) {
        self.checkImage.isHidden = !self.checkImage.isHidden
        self.dontShowAgain = !self.checkImage.isHidden
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        if(self.dontShowAgain) {
            self.writeStatus(3) // Clicked on "Close" - Don't show again ON
        } else {
            self.writeStatus(2) // Clicked on "Close" - Don't show again OFF
        }
        NOTIFY(Notification_reloadMainFeed)
    }
    
    @objc func onImageButtonTap(_ sender: UIButton) {
        self.writeStatus(4) // Click on image
        OPEN_URL(self.bannerURL)
        NOTIFY(Notification_reloadMainFeed)
    }
    
}
