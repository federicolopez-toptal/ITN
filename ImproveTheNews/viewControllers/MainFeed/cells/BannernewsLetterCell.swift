//
//  BannernewsLetterCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/04/2023.
//

import UIKit

class BannernewsLetterCell: UICollectionViewCell {
    
    static let identifier = "BannernewsLetterCell"
    
    let mainContainer = UIView()
    let headerLabel = BannerCell.createHeaderLabel(text: "Lorem ipsum")
    let emailText = FormTextView()
    let textLabel = BannerCell.createTextLabel(text: "Lorem ipsum")
    let dontShowAgainLabel = UILabel()
    let checkImage = UIImageView()
    let closeIcon = UIImageView()
    
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
        
        // -----------------------------
        let hStack_title = HSTACK(into: vStack)
        hStack_title.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        
        // ITN logo
        let logo = UIImageView(image: UIImage(named: ("navBar.circleLogo")))
        hStack_title.addArrangedSubview(logo)
        logo.activateConstraints([
            logo.widthAnchor.constraint(equalToConstant: 44),
            logo.heightAnchor.constraint(equalToConstant: 44)
        ])
        ADD_SPACER(to: hStack_title, width: 10)
        self.headerLabel.font = MERRIWEATHER_BOLD(19)
        hStack_title.addArrangedSubview(self.headerLabel)
        
        // -----------------------------
        ADD_SPACER(to: vStack, height: 3)
        
        self.emailText.buildInto(vstack: vStack)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .done,
            charactersLimit: 50, placeHolderText: "Enter your Email",
            textColor: UIColor(hex: 0x1D242F) )
        self.emailText.delegate = self
        
        self.emailText.backgroundColor = .white
        self.emailText.layer.borderWidth = 1.0
        self.emailText.layer.borderColor = UIColor(hex: 0xBBBBBB).cgColor
        self.emailText.placeHolderLabel.textColor = UIColor(hex: 0xBBBBBB)
        
        // -----------------------------
        let hStack_button = HSTACK(into: vStack)
        hStack_button.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        ADD_SPACER(to: hStack_button)
        
        let subscribeLabel = UILabel()
        subscribeLabel.backgroundColor = UIColor(hex: 0xFF643C)
        subscribeLabel.textColor = .white
        subscribeLabel.text = "Subscribe"
        subscribeLabel.textAlignment = .center
        subscribeLabel.font = ROBOTO_BOLD(15)
        subscribeLabel.layer.masksToBounds = true
        subscribeLabel.layer.cornerRadius = 12
        subscribeLabel.addCharacterSpacing(kernValue: 1.0)
        hStack_button.addArrangedSubview(subscribeLabel)
        subscribeLabel.activateConstraints([
            subscribeLabel.widthAnchor.constraint(equalToConstant: 150),
            subscribeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let subscribeButton = UIButton(type: .custom)
        subscribeButton.backgroundColor = .clear //.green
        hStack_button.addSubview(subscribeButton)
        subscribeButton.activateConstraints([
            subscribeButton.leadingAnchor.constraint(equalTo: subscribeLabel.leadingAnchor),
            subscribeButton.topAnchor.constraint(equalTo: subscribeLabel.topAnchor),
            subscribeButton.trailingAnchor.constraint(equalTo: subscribeLabel.trailingAnchor),
            subscribeButton.bottomAnchor.constraint(equalTo: subscribeLabel.bottomAnchor)
        ])
        subscribeButton.addTarget(self, action: #selector(onSubscribeButtonTap(_:)), for: .touchUpInside)
        
        // -----------------------------
        ADD_SPACER(to: vStack, height: 3)
        vStack.addArrangedSubview(self.textLabel)
        self.textLabel.minimumScaleFactor = 1.0
        ADD_SPACER(to: vStack, height: 20)
        
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
            self.closeIcon.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 0),
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
        
        // -----------------------------
        ADD_SPACER(to: vStack)
    }
    
    
    func populate(with banner: Banner?) {
        guard let _banner = banner else {
            return
        }
        //_banner.trace()
        
        self.bannerCode = _banner.code
        self.headerLabel.text = _banner.headerText
        self.textLabel.text = _banner.mainText
        //self.emailText.setText("gatolab@gmail.com")
        
        // ------------------------
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.headerLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.textLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.dontShowAgainLabel.textColor = self.textLabel.textColor
    }
    
    // --------------------------------------------------
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 360)
    }
    
}

// MARK: - Store settings locally
extension BannernewsLetterCell {
    
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
extension BannernewsLetterCell {
    
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
    
    @objc func onSubscribeButtonTap(_ sender: UIButton) {
        if(self.emailText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your email")
        } else if(!VALIDATE_EMAIL(self.emailText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
        } else {
            CustomNavController.shared.loading.show()
            API.shared.subscribeToNewsletter(email: emailText.text()) { (success, serverMsg) in
                print("MSG", serverMsg)
                
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
    
}

// MARK: - FormTextViewDelegate
extension BannernewsLetterCell: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        self.endEditing(true)
    }
}
