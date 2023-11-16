//
//  iPhoneBannerNLCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/04/2023.
//

import UIKit

class iPhoneBannerNLCell_v3: UITableViewCell {
    
    static let identifier = "iPhoneBannerNLCell_v3"
    private var banner: Banner!
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let emailText = FormTextView()
    let secTextLabel = UILabel()
    let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.close")))
    
    
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
        
        self.titleLabel.font = CSS.shared.iPhoneBanner_titleFont
        self.titleLabel.numberOfLines = 0
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: CSS.shared.iPhoneSide_padding*2)
        ])
        
        let formHStack = HSTACK(into: self.containerView)
        formHStack.activateConstraints([
            formHStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            formHStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            formHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: CSS.shared.iPhoneSide_padding/2),
            formHStack.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        self.emailText.buildInto(vstack: formHStack)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .done,
            charactersLimit: 50, placeHolderText: "yourname@email.com", textColor: UIColor(hex: 0x1D242F) )
        self.emailText.delegate = self
        
        self.emailText.backgroundColor = .white
        self.emailText.layer.borderWidth = 0
        self.emailText.layer.cornerRadius = 4.0
        self.emailText.placeHolderLabel.textColor = UIColor(hex: 0xBBBBBB)
        self.emailText.placeHolderLabel.alpha = 0.5
        self.emailText.activateConstraints([
        ])
        ADD_SPACER(to: formHStack, width: CSS.shared.iPhoneSide_padding)
        
        let actionButton = UIButton(type: .custom)
        actionButton.setTitle("Go!", for: .normal)
        actionButton.layer.cornerRadius = 4.0
        actionButton.backgroundColor = CSS.shared.actionButton_bgColor
        actionButton.titleLabel?.font = CSS.shared.actionButton_iPhone_font
        actionButton.setTitleColor(CSS.shared.actionButton_textColor, for: .normal)
        formHStack.addArrangedSubview(actionButton)
        actionButton.activateConstraints([
            actionButton.widthAnchor.constraint(equalToConstant: 69)
        ])
        actionButton.addTarget(self, action: #selector(onSubscribeButtonTap), for: .touchUpInside)
        
        self.containerView.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 32),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 32),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.closeIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: CSS.shared.iPhoneSide_padding)
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
        self.titleLabel.text = "Sign up to our daily newsletter"
        //self.emailText.setText("gatolab@gmail.com")
        // ------------------------
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.containerView.backgroundColor = CSS.shared.displayMode().banner_bgColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        
        self.emailText.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.emailText.placeHolderLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.emailText.mainTextField.textColor = CSS.shared.displayMode().main_textColor
        self.emailText.mainTextField.tintColor = CSS.shared.displayMode().main_textColor
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 2)
        
        return (CSS.shared.iPhoneSide_padding*2) + self.titleLabel.calculateHeightFor(width: W) +
                (CSS.shared.iPhoneSide_padding/2) + 48 +
                (CSS.shared.iPhoneSide_padding * 2)
    }
    
}

// MARK: - FormTextViewDelegate
extension iPhoneBannerNLCell_v3: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        self.endEditing(true)
    }
}

// MARK: - Actions & misc
extension iPhoneBannerNLCell_v3 {

    @objc func onSubscribeButtonTap(_ sender: UIButton) {
        if(self.emailText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your email")
        } else if(!VALIDATE_EMAIL(self.emailText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
        } else {
            CustomNavController.shared.loading.show()
            API.shared.subscribeToNewsletter(email: emailText.text()) { (success, _) in
                var msg = "Subscription successful"
                if(!success){ msg = "Error while processing your request. Please, try again later" }
                
                MAIN_THREAD {
                    if(success){
                        self.emailText.setText("")
                        CustomNavController.shared.viewControllers.last!.view.endEditing(true)
                    }

                    CustomNavController.shared.loading.hide()
                    CustomNavController.shared.infoAlert(message: msg)
                }
            }
        }
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
//        if(self.dontShowAgain) {
            self.writeStatus(3) // Clicked on "Close" - Don't show again ON
            WRITE(LocalKeys.misc.bannerDontShowAgain, value: "1")
            NOTIFY(Notification_removeBanner)
//        }
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


/*

    let headerLabel = BannerCell.createHeaderLabel(text: "Lorem ipsum")
    let emailText = FormTextView()
    let secTextLabel = BannerCell.createTextLabel(text: "Lorem ipsum")
    let dontShowAgainLabel = UILabel()
    let checkImage = UIImageView()
    let closeIcon = UIImageView()
    
    private var bannerCode = ""
    private var dontShowAgain = false
    
    

    
    
    private func buildContent() {
        
        

}



// MARK: - Event(s)
extension iPadBannerNewsletterCell {

    
    
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

// MARK: - Store settings locally
extension iPadBannerNewsletterCell {
    
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
*/
