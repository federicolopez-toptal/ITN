//
//
//  NewsletterSignUp.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/09/2024.
//

import Foundation
import UIKit


class NewsletterSignUp: BaseViewController {
    
    var iPad_W: CGFloat = -1
    var bottomFormHeight: CGFloat = 150
    
    var email = ""
    var subscriptions = [String]()
    var checkSelection: Int = 0
    
    let navBar = NavBarView()
    let scrollview = UIScrollView()
    var scrollviewBottomConstraint: NSLayoutConstraint?
    
    let bottomForm = UIView()
    var bottomFormBottomConstraint: NSLayoutConstraint?
    let bottomFormDescrLabel = UILabel()
    let emailTextField = FigureFilterTextView()
    var keyboardIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
         if(IPHONE()) {
            self.bottomFormHeight += 16 + 40
        } else {
            self.bottomFormHeight += 22
        }
        
        self.addKeyboardObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Newsletters")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UUID.shared.trace()
        
        var shouldLoad = false
        if(READ(LocalKeys.user.JWT) != nil) {
            shouldLoad = true
        }
                
        if(shouldLoad) {
            self.showLoading()
            API.shared.getUserInfo { (success, serverMsg, user) in
                self.hideLoading()
                if let _user = user {
                    self.email = _user.email
                    
                    self.subscriptions = []
                    for S in _user.subscriptions {
                        self.subscriptions.append(S.lowercased())
                    }
                    
                    //print("VERIFIED", _user.verified)
                }
                
                self.updateRects()
                
                if(!self.email.isEmpty) {
                    MAIN_THREAD {
                        self.emailTextField.setText(self.email, enabled: false)
                    }
                }
            }
        } else {
            self.updateRects()
        }
        
        CHECK_AUTHENTICATED()
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.view.addSubview(self.scrollview)
        self.scrollview.backgroundColor = self.view.backgroundColor
        self.scrollview.activateConstraints([
            self.scrollview.topAnchor.constraint(equalTo: self.navBar.bottomAnchor),
            self.scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.scrollviewBottomConstraint = self.scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                            constant: IPHONE_bottomOffset())
        self.scrollviewBottomConstraint?.isActive = true
        
        let contentView = UIView()
        let contentSizeHeight: CGFloat = IPHONE() ? 630 : 820
        contentView.backgroundColor = self.view.backgroundColor
        self.scrollview.addSubview(contentView)
        contentView.activateConstraints([
            contentView.topAnchor.constraint(equalTo: self.scrollview.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: self.scrollview.centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: self.W()),
            contentView.heightAnchor.constraint(equalToConstant: contentSizeHeight)
        ])
        self.scrollview.contentSize = CGSize(width: self.W(), height: contentSizeHeight)
        
        let titleLabel = UILabel()
        titleLabel.text = "Sign up to our Free Newsletters"
        titleLabel.font = DM_SERIF_DISPLAY_fixed(18)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        contentView.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        let descrLabel = UILabel()
        descrLabel.text = """
        Never miss a thing again! Subscribe for the latest & best curated stories from around the world direct to your device. 100% free :) Choose from:
        """
        descrLabel.font = AILERON(16)
        descrLabel.numberOfLines = 0
        descrLabel.textColor = CSS.shared.displayMode().sec_textColor
        contentView.addSubview(descrLabel)
        descrLabel.activateConstraints([
            descrLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descrLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descrLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        let dailyRect = self.createRect(type: 1, heigth: IPHONE() ? 230 : 270)
        let weeklyRect = self.createRect(type: 2, heigth: IPHONE() ? 230 : 270)
        
        let vstack = VSTACK(into: contentView, spacing: 16)
        vstack.activateConstraints([
            vstack.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 16),
            vstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        vstack.addArrangedSubview(dailyRect)
        vstack.addArrangedSubview(weeklyRect)
        
        self.fillBottomForm()
        self.bottomForm.hide()
    }
    
    func fillBottomForm() {
        self.bottomForm.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.bottomForm)
        self.bottomForm.activateConstraints([
            self.bottomForm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.bottomForm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.bottomForm.heightAnchor.constraint(equalToConstant: self.bottomFormHeight)
        ])
        self.bottomFormBottomConstraint = self.bottomForm.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                            constant: IPHONE_bottomOffset())
        self.bottomFormBottomConstraint?.isActive = true
        
        // line
        let topLineView = UIView()
        self.bottomForm.addSubview(topLineView)
        topLineView.activateConstraints([
            topLineView.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: self.bottomForm.topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        topLineView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.1) : .black.withAlphaComponent(0.25)
        
        // title
        let fontSize: CGFloat = IPHONE() ? 18 : 24
        let formTitleLabel = UILabel()
        formTitleLabel.font = DM_SERIF_DISPLAY_fixed(fontSize)
        formTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        formTitleLabel.text = "Subscribe"
        self.bottomForm.addSubview(formTitleLabel)
        formTitleLabel.activateConstraints([
            formTitleLabel.topAnchor.constraint(equalTo: self.bottomForm.topAnchor, constant: 16),
            formTitleLabel.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16)
        ])
        
        self.bottomFormDescrLabel.font = AILERON(IPHONE() ? 14 : 16)
        self.bottomFormDescrLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.bottomFormDescrLabel.text = "Lorem Ipsum"
        self.bottomForm.addSubview(self.bottomFormDescrLabel)
        self.bottomFormDescrLabel.activateConstraints([
            self.bottomFormDescrLabel.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16),
            self.bottomFormDescrLabel.topAnchor.constraint(equalTo: formTitleLabel.bottomAnchor, constant: 16)
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark")?.withRenderingMode(.alwaysTemplate))
        self.bottomForm.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.bottomForm.topAnchor, constant: 11),
            closeIcon.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -11)
        ])
        closeIcon.tintColor = formTitleLabel.textColor
        
        let closeIconButton = UIButton(type: .custom)
        closeIconButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.bottomForm.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(self.onBottomFormCloseTap(_:)), for: .touchUpInside)
        
        if(IPHONE()) {
            self.emailTextField.buildInto(view: self.bottomForm)
            self.emailTextField.activateConstraints([
                self.emailTextField.topAnchor.constraint(equalTo: self.bottomFormDescrLabel.bottomAnchor, constant: 16),
                self.emailTextField.heightAnchor.constraint(equalToConstant: 40),
                self.emailTextField.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16),
                self.emailTextField.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -16)
            ])
            
            let submitButton = UIButton(type: .custom)
            submitButton.backgroundColor = CSS.shared.cyan
            submitButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
            submitButton.setTitle("Submit", for: .normal)
            submitButton.titleLabel?.font = AILERON(16)
            
            self.bottomForm.addSubview(submitButton)
            submitButton.activateConstraints([
                submitButton.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16),
                submitButton.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -16),
                submitButton.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 16),
                submitButton.heightAnchor.constraint(equalToConstant: 40)
            ])
            submitButton.layer.cornerRadius = 4.0
            submitButton.addTarget(self, action: #selector(self.onBottomFormSubmitTap(_:)), for: .touchUpInside)
        } else {
            self.emailTextField.buildInto(view: self.bottomForm)
            self.emailTextField.activateConstraints([
                self.emailTextField.topAnchor.constraint(equalTo: self.bottomFormDescrLabel.bottomAnchor, constant: 16),
                self.emailTextField.heightAnchor.constraint(equalToConstant: 40),
                self.emailTextField.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16),
                self.emailTextField.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -16-16-120)
            ])
            
            let submitButton = UIButton(type: .custom)
            submitButton.backgroundColor = CSS.shared.cyan
            submitButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
            submitButton.setTitle("Submit", for: .normal)
            submitButton.titleLabel?.font = AILERON(16)
            
            self.bottomForm.addSubview(submitButton)
            submitButton.activateConstraints([
                submitButton.leadingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor, constant: 16),
                submitButton.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -16),
                submitButton.topAnchor.constraint(equalTo: self.emailTextField.topAnchor),
                submitButton.heightAnchor.constraint(equalToConstant: 40)
            ])
            submitButton.layer.cornerRadius = 4.0
            submitButton.addTarget(self, action: #selector(self.onBottomFormSubmitTap(_:)), for: .touchUpInside)
        }
        
        self.emailTextField.placeHolderLabel.text = "Enter your email address"
        self.emailTextField.searchTextField.keyboardType = .emailAddress
        self.emailTextField.searchTextField.returnKeyType = .send
    }
    
}

extension NewsletterSignUp {

    func createRect(type: Int, heigth: CGFloat) -> UIView {
        // view
        let resultView = UIView()
        resultView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xdddddd)
        resultView.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        resultView.tag = 111 + type
        
        // icon
        let imageName = (type==1) ? "dailySubscr" : "weeklySubscr"
        let icon = UIImageView(image: UIImage(named: imageName))
        resultView.addSubview(icon)
        
        let iconSize: CGFloat = IPHONE() ? 40 : 56
        icon.activateConstraints([
            icon.widthAnchor.constraint(equalToConstant: iconSize),
            icon.heightAnchor.constraint(equalToConstant: iconSize),
            icon.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 16)
        ])
        
        // title
        let fontSize: CGFloat = IPHONE() ? 18 : 24
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY_fixed(fontSize)
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.numberOfLines = 0
        titleLabel.text = (type==1) ? "Daily Briefing*" : "Weekly Roundup Only"
        
        resultView.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: IPHONE() ? 8 : 36),
            titleLabel.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -16),
        ])
        
        // description
        let descrLabel = UILabel()
        descrLabel.font = AILERON(IPHONE() ? 14 : 16)
        descrLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        descrLabel.numberOfLines = 0
        
        descrLabel.text = (type==1) ? "The latest stories from around the world each day, direct to your inbox.\n*Includes our Weekly Roundup newsletter." : "The best curated stories from each week, direct to your inbox!"
        
        resultView.addSubview(descrLabel)
        descrLabel.activateConstraints([
            descrLabel.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 16),
            descrLabel.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -16),
            descrLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    
    // Unsubscribe
        let removeButton = UIButton(type: .custom)
        removeButton.backgroundColor = CSS.shared.cyan
        removeButton.setTitle("Unsubscribe", for: .normal)
        removeButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        removeButton.titleLabel?.font = AILERON(16)
        removeButton.layer.cornerRadius = 4.0
        
        resultView.addSubview(removeButton)
        removeButton.activateConstraints([
            removeButton.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 16),
            removeButton.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -16),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -16),
        ])
        removeButton.addTarget(self, action: #selector(self.onRemoveButtonTap(_:)), for: .touchUpInside)
        removeButton.tag = 10
        removeButton.hide()
        
    // Check
        let checkSize: CGFloat = IPHONE() ? 24 : 32
    
        let checkContainer = UIView()
        checkContainer.backgroundColor = .clear //.systemPink
        resultView.addSubview(checkContainer)
        checkContainer.activateConstraints([
            checkContainer.widthAnchor.constraint(equalToConstant: checkSize+32),
            checkContainer.heightAnchor.constraint(equalToConstant: checkSize+32),
            checkContainer.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            checkContainer.bottomAnchor.constraint(equalTo: resultView.bottomAnchor)
        ])
        checkContainer.tag = 20
        checkContainer.hide()
        
        // bg
        let checkView_bg = UIView()
        checkView_bg.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191c) : .white
        checkView_bg.layer.borderWidth = 1.0
        checkView_bg.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4c4e50).cgColor : UIColor(hex: 0xbbbdc0).cgColor
        checkView_bg.layer.cornerRadius = checkSize/2
        checkContainer.addSubview(checkView_bg)
        checkView_bg.activateConstraints([
            checkView_bg.widthAnchor.constraint(equalToConstant: checkSize),
            checkView_bg.heightAnchor.constraint(equalToConstant: checkSize),
            checkView_bg.centerXAnchor.constraint(equalTo: checkContainer.centerXAnchor),
            checkView_bg.centerYAnchor.constraint(equalTo: checkContainer.centerYAnchor)
        ])
        
        // CHECK (over)
        let checkView_over = UIView()
        checkView_over.backgroundColor = checkView_bg.backgroundColor
        checkView_over.layer.borderWidth = 1.0
        checkView_over.layer.borderColor = (type==1) ? UIColor(hex: 0x71d656).cgColor : UIColor(hex: 0x53929d).cgColor
        checkView_over.layer.cornerRadius = checkSize/2
        checkContainer.addSubview(checkView_over)
        checkView_over.activateConstraints([
            checkView_over.widthAnchor.constraint(equalToConstant: checkSize),
            checkView_over.heightAnchor.constraint(equalToConstant: checkSize),
            checkView_over.leadingAnchor.constraint(equalTo: checkView_bg.leadingAnchor),
            checkView_over.topAnchor.constraint(equalTo: checkView_bg.topAnchor)
        ])
        checkView_over.tag = 30
        
        // dot
        let dotView = UIView()
        dotView.backgroundColor = (type==1) ? UIColor(hex: 0x71d656) : UIColor(hex: 0x53929d)
        checkView_over.addSubview(dotView)
        dotView.activateConstraints([
            dotView.widthAnchor.constraint(equalToConstant: checkSize/2),
            dotView.heightAnchor.constraint(equalToConstant: checkSize/2),
            dotView.centerXAnchor.constraint(equalTo: checkView_over.centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: checkView_over.centerYAnchor)
        ])
        dotView.layer.cornerRadius = checkSize/4
        
        // Button area
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.blue.withAlphaComponent(0.25)
        checkContainer.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: checkView_bg.leadingAnchor, constant: -10),
            buttonArea.topAnchor.constraint(equalTo: checkView_bg.topAnchor, constant: -10),
            buttonArea.trailingAnchor.constraint(equalTo: checkView_bg.trailingAnchor, constant: 10),
            buttonArea.bottomAnchor.constraint(equalTo: checkView_bg.bottomAnchor, constant: 10)
        ])
        buttonArea.tag = type
        buttonArea.addTarget(self, action: #selector(self.checkOnTap(_:)), for: .touchUpInside)
        
        checkView_over.hide()
        return resultView
    }
    
    func updateRects() {
        MAIN_THREAD {
            for i in 1...2 {
                let rectView = self.view.viewWithTag(111+i)!
                    let removeButton = rectView.viewWithTag(10)!
                let checkContainerView = rectView.viewWithTag(20)!
                    let checkOverView = checkContainerView.viewWithTag(30)!
                
                removeButton.hide()
                checkContainerView.hide()
                checkOverView.hide()
                
                if(i==1) {
                    if(self.subscriptions.contains("daily")) {
                        removeButton.show()
                    } else {
                        checkContainerView.show()
                    }
                }
                
                if(i==2) {
                    if(self.subscriptions.contains("weekly")) {
                        removeButton.show()
                    } else {
                        checkContainerView.show()
                    }
                }
                
                if(self.checkSelection==i) {
                    checkOverView.show()
                }
            }
        }
    }

    func W() -> CGFloat {
        if(IPHONE()) {
            return SCREEN_SIZE().width - 32
        } else {
            if(self.iPad_W == -1) {
                var value: CGFloat = 0
                let w = SCREEN_SIZE().width
                let h = SCREEN_SIZE().height
                
                if(w<h){ value = w }
                else{ value = h }
                //self.iPad_W = value - 74
                self.iPad_W = value - IPAD_sideOffset()
            }
        
            return self.iPad_W
        }
    }
    
}

extension NewsletterSignUp: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

extension NewsletterSignUp {
    @objc func onRemoveButtonTap(_ sender: UIButton?) {
        let msg = "We’re sorry to see you go! Click the Unsubscribe button below to finish unsubscribing to our newsletter"
        
         MAIN_THREAD {
            let alert = UIAlertController(title: "⚠️ Remove subscription", message: msg, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Unsubscribe", style: .default) { action in
                let num = sender!.superview!.tag-111
                self.remove_part2(num)
            }
            let noAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true)
        }
    }
    
    private func remove_part2(_ num: Int) {
        var subsCopy = [String]()
        
        if(num==1) {
            subsCopy = self.remove("daily")
        } else if(num==2) {
            subsCopy = self.remove("weekly")
        }
        
        self.showLoading()
        API.shared.changeSubscriptionTypeTo(types: subsCopy, email: self.email) { (success, serverMSg) in
            self.hideLoading()
            
            if(success) {
                self.subscriptions = subsCopy
                self.updateRects()
                
                let msg = "You will no longer receive email newsletters to the email address: " + self.email
                ALERT(vc: self, title: "Successfully unsubscribed", message: msg) {
                    /* ... */
                }
            }
        }
    }
    
    func remove(_ itemName: String) -> [String] {
        var copy = self.subscriptions
    
        for (i, S) in self.subscriptions.enumerated() {
            if(S == itemName) {
                copy.remove(at: i)
                break
            }
        }
        
        return copy
    }
    
    @objc func checkOnTap(_ sender: UIButton?) {
        let type = sender!.tag
        
        if(type == self.checkSelection) {
            self.checkSelection = 0
        } else {
            self.checkSelection = type
        }
        
        self.updateRects()
        self.showBottomForm()
    }
    
    func showBottomForm() {
        var bottomValue = IPHONE_bottomOffset()
        if(self.checkSelection != 0) {
            bottomValue -= self.bottomFormHeight
            self.bottomFormDescrLabel.text = (self.checkSelection==1) ? "Daily Briefing (inc Weekly Roundup)" : "Weekly Roundup only"
        }
        
        if(self.keyboardIsVisible) {
            return
        }
        
        // pre animation
        if(self.checkSelection == 0) {
            self.bottomForm.hide()
        }
        
        self.scrollviewBottomConstraint?.constant = bottomValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            // post animation
            if(self.checkSelection != 0) {
                self.bottomForm.show()
            }
        }
    }
    
    func hideBottomForm() {
        let bottomValue = IPHONE_bottomOffset()
        self.bottomForm.hide()
        
        self.scrollviewBottomConstraint?.constant = bottomValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        HIDE_KEYBOARD(view: self.view)
    }
    
    @objc func onBottomFormCloseTap(_ sender: UIButton?) {
        self.checkSelection = 0
        self.updateRects()
        self.hideBottomForm()
    }
    
    func validateForm() -> Bool {
        if( VALIDATE_EMAIL(self.emailTextField.text()) ) {
            return true
        }
        return false
    }
    
    @objc func onBottomFormSubmitTap(_ sender: UIButton?) {
        var subs = [String]()
        if(self.checkSelection == 1) {
            subs = ["daily", "weekly"]
        } else {
            subs = self.subscriptions
            subs.append("weekly")
        }
        
        if(READ(LocalKeys.user.JWT) == nil) {
            // NO USER
            if(!self.validateForm()) {
                CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
                return
            }
            
            self.showLoading()
            API.shared.signUp(email: self.emailTextField.text(),
                              subscriptions: subs) { (success, msg) in
                self.hideLoading()
                
                if(success) {
                    self.subscriptions = subs
                    self.checkSelection = 0
                    self.updateRects()
                    
                    MAIN_THREAD {
                        self.email = self.emailTextField.text()
                        self.hideBottomForm()
                        
                        let msg = "Subscription successful. You'll receive a validation email to complete the process"
                        CustomNavController.shared.infoAlert(message: msg)

                        UUID.shared.trace()
                    }
                } else {
                    CustomNavController.shared.infoAlert(message: msg)
                }
            }
        } else {
            // EXISTING USER
            self.showLoading()
            API.shared.changeSubscriptionTypeTo(types: subs, email: self.emailTextField.text()) { (success, serverMSg) in
                self.hideLoading()
                
                if(success) {
                    self.subscriptions = subs
                    self.checkSelection = 0
                    self.updateRects()
                    
                    MAIN_THREAD {
                        self.email = self.emailTextField.text()
                        self.hideBottomForm()
                    }
                    
                    DELAY(0.3) {
                        self.showThanksPopup()
                    }
                }
            }
        }
    }
    
    func showThanksPopup() {
        MAIN_THREAD {
            let descr = """
            You successfully signed up to The Daily Briefing newsletter. You can manage your subscriptions on this page or, by clicking the unsubscribe link in the footer of the newsletter.
            """
        
            let popup = StoryInfoPopupView(title: "Thanks for signing up!",
                description: descr, linkedTexts: [], links: [], height: 210)
                        
            popup.pushFromBottom()
        }
    }
    
}

extension NewsletterSignUp {

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardEvent(n: Notification) {
        let H = getKeyboardHeight(fromNotification: n)
        
        var bottomFormBottomValue: CGFloat = 0
        var scrollviewBottomValue: CGFloat = 0
        
        if(n.name==UIResponder.keyboardWillShowNotification) {
            bottomFormBottomValue = -H
            self.keyboardIsVisible = true
            
            if(SAFE_AREA()!.bottom > 0) {
                scrollviewBottomValue = IPHONE_bottomOffset() - self.bottomFormHeight - 215
            } else {
                scrollviewBottomValue = IPHONE_bottomOffset() - self.bottomFormHeight
            }
            
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            bottomFormBottomValue = IPHONE_bottomOffset()
            self.keyboardIsVisible = false
            
            if(!self.bottomForm.isHidden) {
                scrollviewBottomValue = IPHONE_bottomOffset() - self.bottomFormHeight
            } else {
                scrollviewBottomValue = IPHONE_bottomOffset()
            }
        }
        
        self.bottomFormBottomConstraint?.constant = bottomFormBottomValue
        self.scrollviewBottomConstraint?.constant = scrollviewBottomValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }

}
