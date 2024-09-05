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
    var checkSelection: Int = -1
    var bottomFormHeight: CGFloat = 150
    
    let navBar = NavBarView()
    let scrollview = UIScrollView()
    var scrollviewBottomConstraint: NSLayoutConstraint?
    
    let bottomForm = UIView()
    let bottomFormDescrLabel = UILabel()
    var bottomFormBottomConstraint: NSLayoutConstraint?
    let emailTextField = FigureFilterTextView()


    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        if(IPHONE()) {
            self.bottomFormHeight += 16 + 40
        } else {
            self.bottomFormHeight += 22
        }
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
        contentView.backgroundColor = self.view.backgroundColor
        self.scrollview.addSubview(contentView)
        contentView.activateConstraints([
            contentView.topAnchor.constraint(equalTo: self.scrollview.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: self.scrollview.centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: self.W()),
            //containerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
        
        let contentSizeHeight: CGFloat = IPHONE() ? 630 : 820
        contentView.heightAnchor.constraint(equalToConstant: contentSizeHeight).isActive = true
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
        
//        if(IPHONE()) {
//            let dailyRect = self.createRect(type: 1, heigth: 218)
//            let weeklyRect = self.createRect(type: 2, heigth: 218)
//            
//            let vstack = VSTACK(into: containerView, spacing: 16)
//            vstack.activateConstraints([
//                vstack.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 16),
//                vstack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//                vstack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
//            ])
//            
//            vstack.addArrangedSubview(dailyRect)
//            vstack.addArrangedSubview(weeklyRect)
//        } else {
//            let dailyRect = self.createRect(type: 1, heigth: 270)
//            let weeklyRect = self.createRect(type: 2, heigth: 270)
//                        
//            let vstack = HSTACK(into: containerView, spacing: 16)
//            vstack.activateConstraints([
//                vstack.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 16),
//                vstack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//                vstack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
//            ])
//            
//            dailyRect.widthAnchor.constraint(equalToConstant: (W()-16)/2).isActive = true
//            weeklyRect.widthAnchor.constraint(equalToConstant: (W()-16)/2).isActive = true
//            
//            vstack.addArrangedSubview(dailyRect)
//            vstack.addArrangedSubview(weeklyRect)
//        }
        
            let dailyRect = self.createRect(type: 1, heigth: IPHONE() ? 218 : 270)
            let weeklyRect = self.createRect(type: 2, heigth: IPHONE() ? 218 : 270)
            
            let vstack = VSTACK(into: contentView, spacing: 16)
            vstack.activateConstraints([
                vstack.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 16),
                vstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                vstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
            
            vstack.addArrangedSubview(dailyRect)
            vstack.addArrangedSubview(weeklyRect)
        
        
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
        
        self.fillBottomForm()
        self.bottomForm.hide()
        
        // -----------------------------------------
        self.addKeyboardObservers()
        self.refreshDisplayMode()
    }
    
    func fillBottomForm() {
        // title
        let fontSize: CGFloat = IPHONE() ? 18 : 24
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY_fixed(fontSize)
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.text = "Subscribe"
        
        self.bottomForm.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.topAnchor.constraint(equalTo: self.bottomForm.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16)
        ])
        
        self.bottomFormDescrLabel.font = AILERON(IPHONE() ? 14 : 16)
        self.bottomFormDescrLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.bottomFormDescrLabel.text = "Lorem Ipsum"
        
        self.bottomForm.addSubview(self.bottomFormDescrLabel)
        self.bottomFormDescrLabel.activateConstraints([
            self.bottomFormDescrLabel.leadingAnchor.constraint(equalTo: self.bottomForm.leadingAnchor, constant: 16),
            self.bottomFormDescrLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark")?.withRenderingMode(.alwaysTemplate))
        self.bottomForm.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.bottomForm.topAnchor, constant: 11),
            closeIcon.trailingAnchor.constraint(equalTo: self.bottomForm.trailingAnchor, constant: -11)
        ])
        closeIcon.tintColor = titleLabel.textColor
        
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
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
}

extension NewsletterSignUp {
    
    func createRect(type: Int, heigth: CGFloat) -> UIView {
        // view
        let resultView = UIView()
        resultView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xdddddd)
        resultView.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        
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
        
        // CHECK (bg)
        let checkSize: CGFloat = IPHONE() ? 24 : 32
        
        let checkView_bg = UIView()
        checkView_bg.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191c) : .white
        checkView_bg.layer.borderWidth = 1.0
        checkView_bg.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4c4e50).cgColor : UIColor(hex: 0xbbbdc0).cgColor
        checkView_bg.layer.cornerRadius = checkSize/2
        
        resultView.addSubview(checkView_bg)
        checkView_bg.activateConstraints([
            checkView_bg.widthAnchor.constraint(equalToConstant: checkSize),
            checkView_bg.heightAnchor.constraint(equalToConstant: checkSize),
            checkView_bg.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -16),
            checkView_bg.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -16)
        ])
        
        // CHECK (over)
        let checkView_over = UIView()
        checkView_over.backgroundColor = checkView_bg.backgroundColor
        checkView_over.layer.borderWidth = 1.0
        checkView_over.layer.borderColor = (type==1) ? UIColor(hex: 0x71d656).cgColor : UIColor(hex: 0x53929d).cgColor
        checkView_over.layer.cornerRadius = checkSize/2
        resultView.addSubview(checkView_over)
        checkView_over.activateConstraints([
            checkView_over.widthAnchor.constraint(equalToConstant: checkSize),
            checkView_over.heightAnchor.constraint(equalToConstant: checkSize),
            checkView_over.leadingAnchor.constraint(equalTo: checkView_bg.leadingAnchor),
            checkView_over.topAnchor.constraint(equalTo: checkView_bg.topAnchor)
        ])
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
        
        checkView_over.hide()
        checkView_over.tag = 444 + type
        
        // Button area
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        resultView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            buttonArea.topAnchor.constraint(equalTo: resultView.topAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: resultView.bottomAnchor)
        ])
        buttonArea.tag = type
        buttonArea.addTarget(self, action: #selector(self.checkOnTap(_:)), for: .touchUpInside)
        
        return resultView
    }
    
    @objc func onBottomFormCloseTap(_ sender: UIButton?) {
        self.checkSelection = -1
        
        // Update UI
        let dailyCheck = self.view.viewWithTag(444+1)!
        let weeklyCheck = self.view.viewWithTag(444+2)!
        dailyCheck.hide()
        weeklyCheck.hide()
        
        let bottomValue = IPHONE_bottomOffset()
        self.bottomForm.hide()
        
        self.scrollviewBottomConstraint?.constant = bottomValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        HIDE_KEYBOARD(view: self.view)
    }
    
    @objc func checkOnTap(_ sender: UIButton?) {
        let type = sender!.tag
        
        if(type != self.checkSelection) {
            self.checkSelection = type
        } else {
            self.checkSelection = -1
        }
        
        // Update UI
        let dailyCheck = self.view.viewWithTag(444+1)!
        let weeklyCheck = self.view.viewWithTag(444+2)!
        dailyCheck.hide()
        weeklyCheck.hide()
        
        if(self.checkSelection == 1) {
            dailyCheck.show()
        } else if(self.checkSelection == 2) {
            weeklyCheck.show()
        }
        
        var bottomValue = IPHONE_bottomOffset()
        if(self.checkSelection != -1) {
            bottomValue -= self.bottomFormHeight
            
            self.bottomFormDescrLabel.text = (type==1) ? "Daily Briefing (inc Weekly Roundup)" : "Weekly Roundup only"
        }
        
        // pre animation
        if(self.checkSelection == -1) {
                self.bottomForm.hide()
            }
        
        self.scrollviewBottomConstraint?.constant = bottomValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            // post animation
            if(self.checkSelection != -1) {
                self.bottomForm.show()
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
        
        if(n.name==UIResponder.keyboardWillShowNotification) {
            self.bottomFormBottomConstraint?.constant = -H
            
            if(SAFE_AREA()!.bottom > 0) {
                self.scrollviewBottomConstraint?.constant = IPHONE_bottomOffset() - self.bottomFormHeight - 215
            } else {
                self.scrollviewBottomConstraint?.constant = IPHONE_bottomOffset() - self.bottomFormHeight
            }
            
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            self.bottomFormBottomConstraint?.constant = IPHONE_bottomOffset()
            
            if(!self.bottomForm.isHidden) {
                self.scrollviewBottomConstraint?.constant = IPHONE_bottomOffset() - self.bottomFormHeight
            } else {
                self.scrollviewBottomConstraint?.constant = IPHONE_bottomOffset()
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }
    
    @objc func onBottomFormSubmitTap(_ sender: UIButton?) {
        self.emailTextField.searchTextField.text = "gatolab@gmail.com" //!!!
        
        if(!self.validateForm()) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
            return
        }
        
        self.showLoading()
        self.scrollview.isUserInteractionEnabled = false
        self.bottomForm.isUserInteractionEnabled = false
    
        API.shared.changeSubscriptionTypeTo(type: self.checkSelection, email: self.emailTextField.text()) { (success, serverMSg) in
            MAIN_THREAD { //---
                self.scrollview.isUserInteractionEnabled = true
                self.bottomForm.isUserInteractionEnabled = true
                
                if(!success) {
                    CustomNavController.shared.infoAlert(message: serverMSg)
                } else {
                    CustomNavController.shared.infoAlert(message: "Newsletter options successfully updated")
                }
            } //---
            
            self.hideLoading()
        }
    }
    
    func validateForm() -> Bool {
        if( VALIDATE_EMAIL(self.emailTextField.text()) ) {
            return true
        }
        return false
    }
}

extension NewsletterSignUp: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
