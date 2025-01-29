//
//  newAd.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/12/2024.
//

import Foundation
import UIKit

// --------------------------
let Notification_newAdOnClose = Notification.Name("NewAdOnClose")

// --------------------------
enum NewAdType: String {
    case undefined = "..."

    case usElection = "usElection"
    case newsLetter = "newsletter"
    case podcast = "podcast"
    case whatsApp = "whatsApp"
}

class DP3_newAd: DP3_item {
    var type: NewAdType

    init(type: NewAdType) {
        self.type = type
    }
}

// --------------------------
class newAds {
    
    // Append ads, for testing purposes
    static func appendAds(to dataProvider: inout [DP3_item], topic: String) {
        

        var currentAd = 0
        let ads: [NewAdType] = [.newsLetter, .podcast, .whatsApp]
        //let ads: [NewAdType] = [.podcast, .usElection, .newsLetter, .whatsApp]
        for (i, DP) in dataProvider.enumerated() {
            if(DP is DP3_more && currentAd != -1) {
                let adType = ads[currentAd]
                
                if( !newAdCell_v3.keyExists(key: newAdCell_v3.key(type: adType)) ) {
                    // 1. Append Ad
                    let newAd = DP3_newAd(type: adType)
                    dataProvider.insert(newAd, at: i+1)
                    
                    // 2. Remove topic line separator
                    let nextIndex = i+2
                    if(nextIndex < dataProvider.count) {
                        dataProvider.remove(at: i+2)
                    }
                }

                if(topic != "news") {
                    break
                }

                currentAd += 1
                if(currentAd == ads.count) {
                    //currentAd = 0
                    currentAd = -1
                }
            }
        }
        
    }

}

// --------------------------
class newAdCell_v3: UITableViewCell {

    static let identifier = "newAdCell_v3"
    static let version = "0.6"
    
    static let orange = UIColor(hex: 0xDA4933)
    static let green = UIColor(hex: 0x71D656)
    static let cyan = UIColor(hex: 0x60C4D6)
    
    static var adTypeClosed: NewAdType = .undefined
    
    var currentType: NewAdType = .undefined
    var currentDisplayMode: DisplayMode = .dark
    var colorRectHeightConstraint: NSLayoutConstraint? = nil

    let mainImageView = UIImageView()
    var mainImageViewWidthConstraint: NSLayoutConstraint? = nil
    var mainImageViewHeightConstraint: NSLayoutConstraint? = nil
    
    let mainContentView = UIView()
    let actionButtonArea = UIButton(type: .system)
    let closeButtonImageView = UIImageView()
    let closeButton = UIButton(type: .system)
    
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        let colorRect = UIView()
        colorRect.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xe3e3e3)
        self.contentView.addSubview(colorRect)
        colorRect.clipsToBounds = true
        
        if(IPHONE()) {
            colorRect.activateConstraints([
                colorRect.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                colorRect.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11),
                colorRect.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
        } else {
            colorRect.activateConstraints([
                colorRect.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
                colorRect.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 19),
                colorRect.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
            ])
        }
        
        self.colorRectHeightConstraint = colorRect.heightAnchor.constraint(equalToConstant: self.colorRectHeight())
        self.colorRectHeightConstraint?.isActive = true
        
        colorRect.addSubview(self.mainImageView)
        self.mainImageView.backgroundColor = .clear //.green
        self.mainImageViewWidthConstraint = self.mainImageView.widthAnchor.constraint(equalToConstant: 10)
        self.mainImageViewHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 10)
        self.mainImageView.activateConstraints([
            self.mainImageView.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            self.mainImageView.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor),
            self.mainImageViewWidthConstraint!,
            self.mainImageViewHeightConstraint!
        ])
        
        colorRect.addSubview(self.closeButtonImageView)
        self.closeButtonImageView.image = UIImage(named: "popup.close.bright")!.withRenderingMode(.alwaysTemplate)
        self.closeButtonImageView.tintColor = .red
        self.closeButtonImageView.activateConstraints([
            self.closeButtonImageView.widthAnchor.constraint(equalToConstant: 24),
            self.closeButtonImageView.heightAnchor.constraint(equalToConstant: 24),
            self.closeButtonImageView.topAnchor.constraint(equalTo: colorRect.topAnchor,
                constant: IPHONE() ? 5 : 10),
            self.closeButtonImageView.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor,
                constant: IPHONE() ? -5 : -10)
        ])
        
        colorRect.addSubview(self.mainContentView)
        self.mainContentView.activateConstraints([
            self.mainContentView.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            self.mainContentView.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            self.mainContentView.topAnchor.constraint(equalTo: colorRect.topAnchor),
            self.mainContentView.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor)
        ])
        
        colorRect.addSubview(self.actionButtonArea)
        self.actionButtonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.actionButtonArea.activateConstraints([
            self.actionButtonArea.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            self.actionButtonArea.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            self.actionButtonArea.topAnchor.constraint(equalTo: colorRect.topAnchor),
            self.actionButtonArea.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor)
        ])
        self.actionButtonArea.addTarget(self, action: #selector(self.actionButtonAreaOnTap(_:)), for: .touchUpInside)
        
        colorRect.addSubview(self.closeButton)
        self.closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.closeButton.activateConstraints([
            self.closeButton.centerXAnchor.constraint(equalTo: self.closeButtonImageView.centerXAnchor),
            self.closeButton.centerYAnchor.constraint(equalTo: self.closeButtonImageView.centerYAnchor),
            self.closeButton.widthAnchor.constraint(equalToConstant: 40),
            self.closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.closeButton.addTarget(self, action: #selector(self.closeButtonOnTap(_:)), for: .touchUpInside)
    }
    
    // ----------------------------------
    @objc func closeButtonOnTap(_ sender: UIButton?) {
        WRITE(self.key(), value: "CLOSED")
        newAdCell_v3.adTypeClosed = self.currentType
        NOTIFY(Notification_newAdOnClose)
    }
    
    @objc func actionButtonAreaOnTap(_ sender: UIButton?) {
        switch(self.currentType) {
            case .usElection:
                ControversiesViewController.topic = "us-election-2024"
                CustomNavController.shared.tabsBar.selectTab(4, loadContent: true)
                
            case .newsLetter:
                let vc = NewsletterSignUp()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
            case .whatsApp:
                OPEN_URL("https://chat.whatsapp.com/GDJz4KdKt3hDk6cN9Pe94u")
                
            case .podcast:
                let vc = PodcastViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
            default:
                print("Default")
        }
    }
    
    // ----------------------------------
    func populateWithType(_ type: NewAdType) {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        if let colorRect = self.mainImageView.superview {
            colorRect.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xe3e3e3)
        }
        self.closeButtonImageView.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        
        ///////////////////////////////////////////////////////
        if(self.currentType == .undefined) {
            self.currentDisplayMode = DisplayMode.current()
            self.currentType = type
        } else {
            if(type == self.currentType && self.currentDisplayMode == DisplayMode.current()) {
                return
            }
        }
        
        self.currentType = type
        self.currentDisplayMode = DisplayMode.current()
        
        let image = UIImage(named: self.imageName(from: type.rawValue))
        if let _image = image {
            let H = self.colorRectHeight()
            let W = (H * image!.size.width)/image!.size.height
            
            self.mainImageView.image = _image
            self.mainImageViewHeightConstraint?.constant = H
            self.mainImageViewWidthConstraint?.constant = W
        }
        
        self.colorRectHeightConstraint?.constant = self.colorRectHeight()
        self.addContent()
        
        self.actionButtonArea.superview?.bringSubviewToFront(self.actionButtonArea)
        self.closeButton.superview?.bringSubviewToFront(self.closeButton)
    }

    func addContent() {
        print(IPAD(), SCREEN_SIZE())
        
        REMOVE_ALL_SUBVIEWS(from: self.mainContentView)
// US Election
        if(self.currentType == .usElection) {
            var titleText = "Verity US Election Portal"
            if(IPHONE()) {
                titleText = "Verity US\nElection Portal"
            }
            let titleLabel = self.titleLabel(text: titleText)
            self.mainContentView.addSubview(titleLabel)
            
            let actionButton = self.actionButton(text: "Explore", bgColor: newAdCell_v3.orange)
            self.mainContentView.addSubview(actionButton)
            
            titleLabel.activateConstraints([
                titleLabel.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor,
                    constant: IPHONE() ? 21 : 32),
                titleLabel.topAnchor.constraint(equalTo: self.mainContentView.topAnchor,
                    constant: IPHONE() ? 15 : 30)
            ])
            
            if(IPHONE()) {
                actionButton.activateConstraints([
                    actionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    actionButton.widthAnchor.constraint(equalToConstant: 96)
                ])
            } else {
                actionButton.activateConstraints([
                    actionButton.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -255),
                    actionButton.widthAnchor.constraint(equalToConstant: 124),
                    actionButton.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor)
                ])
                
                let subTitleLabel = self.subTitleLabel(text: "Find out Where Candidates Stand on Key Issues.")
                self.mainContentView.addSubview(subTitleLabel)
                subTitleLabel.activateConstraints([
                    subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
                ])
            }
// Neswsletter
        } else if(self.currentType == .newsLetter) {
            var titleText = "Sign Up for Our Free Newsletters"
            if(IPHONE()) {
                titleText = "Sign Up for Our Free\nNewsletters"
            }
            let titleLabel = self.titleLabel(text: titleText)
            self.mainContentView.addSubview(titleLabel)
            
            let actionButton = self.actionButton(text: "Sign Up!", bgColor: newAdCell_v3.green)
            self.mainContentView.addSubview(actionButton)
            
            if(IPHONE()) {
                titleLabel.activateConstraints([
                    titleLabel.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 21),
                    titleLabel.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: 15)
                ])
                
                actionButton.activateConstraints([
                    actionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    actionButton.widthAnchor.constraint(equalToConstant: 96)
                ])
            } else {
                titleLabel.activateConstraints([
                    titleLabel.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 42),
                    titleLabel.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor)
                ])

                actionButton.activateConstraints([
                    actionButton.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -288),
                    actionButton.widthAnchor.constraint(equalToConstant: IPHONE() ? 111 : 143),
                    actionButton.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor)
                ])
                
                if(SMALL_IPAD()) {
                    titleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -15).isActive = true
                }
            }
// WhatsApp
        } else if(self.currentType == .whatsApp) {
            var titleText = "Join the Verity\nCommunity on WhatsApp!"
            if(IPHONE()){ titleText = "Join the Verity Community\non WhatsApp!" }
            let titleLabel = self.titleLabel(text: titleText)
            let actionButton = self.actionButton(text: "Join Now!", bgColor: newAdCell_v3.cyan)
            
            self.mainContentView.addSubview(actionButton)
            self.mainContentView.addSubview(titleLabel)
            
            if(IPHONE()) {
                titleLabel.activateConstraints([
                    titleLabel.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 21),
                    titleLabel.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: 15)
                ])
                
                actionButton.activateConstraints([
                    actionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    actionButton.widthAnchor.constraint(equalToConstant: 111)
                ])
            } else {
                titleLabel.activateConstraints([
                    titleLabel.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 42),
                    titleLabel.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: 15)
                ])
            
                actionButton.activateConstraints([
                    actionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    actionButton.widthAnchor.constraint(equalToConstant: 140)
                ])
            
                let logo = UIImageView(image: UIImage(named: "whatsAppLogo"))
                self.mainContentView.addSubview(logo)
                logo.activateConstraints([
                    logo.widthAnchor.constraint(equalToConstant: 66),
                    logo.heightAnchor.constraint(equalToConstant: 66),
                    logo.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor)
                ])
                
                if(!SMALL_IPAD()) {
                    logo.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -350).isActive = true
                } else {
                    logo.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -300).isActive = true
                }
            }
// Podcast
        } else if(self.currentType == .podcast) {
            let img = UIImage(named: "podcast_title")?.withRenderingMode(.alwaysTemplate)
            let titleImageView = UIImageView(image: img)
            titleImageView.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            self.mainContentView.addSubview(titleImageView)

            if(IPHONE()) {
                titleImageView.activateConstraints([
                    titleImageView.widthAnchor.constraint(equalToConstant: 70),
                    titleImageView.heightAnchor.constraint(equalToConstant: 58),
                    titleImageView.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 17),
                    titleImageView.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: 20)
                ])
            } else {
                titleImageView.activateConstraints([
                    titleImageView.widthAnchor.constraint(equalToConstant: 70),
                    titleImageView.heightAnchor.constraint(equalToConstant: 58),
                    titleImageView.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: 25),
                    titleImageView.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor)
                ])
            }
            
            var subTitle = "The Day’s Biggest Stories with\nScott Wallace & the Podcast Team."
            if(IPHONE()){ subTitle = "With Scott Wallace &\nthe Podcast Team." }
            
            let subTitleLabel = self.subTitleLabel(text: subTitle)
            self.mainContentView.addSubview(subTitleLabel)
            
            if(IPHONE()) {
                subTitleLabel.font = AILERON(15)
            
                subTitleLabel.activateConstraints([
                    subTitleLabel.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor),
                    subTitleLabel.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 10)
                ])
            } else {
                subTitleLabel.centerYAnchor.constraint(equalTo: self.mainContentView.centerYAnchor).isActive = true
            
                if(!SMALL_IPAD()) {
                    subTitleLabel.activateConstraints([
                        subTitleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 42)
                    ])
                } else {
                    subTitleLabel.activateConstraints([
                        subTitleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 16),
                        subTitleLabel.widthAnchor.constraint(equalToConstant: 200)
                    ])
                    
                    subTitleLabel.font = AILERON(15)
                    subTitleLabel.numberOfLines = 0
                }
            }
        
        }
        
    }

    // ----------------------------------
    func calculateHeight() -> CGFloat {
        if(IPHONE()) {
            return 11 + self.colorRectHeight()
        } else {
            return 19 + self.colorRectHeight() + 10
        }
    }
    
}

// MARK: - Utils
extension newAdCell_v3 {
    
    func key() -> String {
        return newAdCell_v3.key(type: self.currentType)
    }
    
    static func key(type: NewAdType) -> String {
        return "newAd_" + type.rawValue + "_v" + String(newAdCell_v3.version)
    }
    
    static func keyExists(key: String) -> Bool {
        if let _value = READ( key ) {
            return true
        } else {
            return false
        }
    }
    
    private func colorRectHeight() -> CGFloat {
        var result: CGFloat = 0
        if(IPHONE()) {
            result = 142
        } else {
            if(self.currentType == .whatsApp) {
                result = 180
            } else {
                result = 140
            }
        }
        
        return result
    }
    
    private func imageName(from name: String) -> String {
        let suffix = IPHONE() ? "_iPhone" : "_iPad"
        return name + suffix
    }
    
    private func titleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = CSS.shared.displayMode().main_textColor
        label.font = DM_SERIF_DISPLAY(IPHONE() ? 21 : 30)
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
    
    private func subTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = CSS.shared.displayMode().main_textColor
        label.font = AILERON(17)
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
    
    private func actionButton(text: String, bgColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = bgColor
        if(bgColor == newAdCell_v3.orange) {
            button.setTitleColor(.white, for: .normal)
        } else {
            button.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        }
        button.titleLabel?.font = AILERON_SEMIBOLD(14)
        button.setTitle(text, for: .normal)
        
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: IPHONE() ? 40 : 48)
        ])
        button.layer.cornerRadius = IPHONE() ? 20 : 24
        
        return button
    }
    
    func SMALL_IPAD() -> Bool {
        var result = false
        if(IPAD() && SCREEN_SIZE().width <= 834 && SCREEN_SIZE().height <= 1194) { // iPad (11 inches screen)
            return true
        }
        
        return result
    }
}
