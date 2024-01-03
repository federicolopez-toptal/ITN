//
//  SignInView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/02/2023.
//

import UIKit

protocol SignInViewDelegate: AnyObject {
    func SignInViewOnTabTap()
    func SignInViewShowLoading(state: Bool)
    func SignInOnSocialButtonTap(index: Int)
}


class SignInView: UIView {

    weak var delegate: SignInViewDelegate?

    let scrollView = UIScrollView()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    let contentView = UIView()
    var VStack: UIStackView!

    let emailText = FormTextView()
    let passText = FormTextView()
    let mainActionButton = UIButton(type: .custom)


    // MARK: - Init
    func buildInto(view containerView: UIView) {
        containerView.addSubview(self)
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: NavBarView.HEIGHT()),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        self.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollViewBottomConstraint
        ])

            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow

        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .green
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.yellow
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            //self.VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        self.buildForm()
        self.addKeyboardObservers()
        self.refreshDisplayMode()
    }
    
    private func buildForm() {
        ADD_SPACER(to: self.VStack, height: 32)
        
        let hStackTabs = HSTACK(into: self.VStack)
        
            ADD_SPACER(to: hStackTabs, width: 16)
        let tabsBgView = UIView()
        tabsBgView.backgroundColor = .red
        tabsBgView.layer.cornerRadius = 20
        tabsBgView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
        hStackTabs.addArrangedSubview(tabsBgView)
        tabsBgView.activateConstraints([
            tabsBgView.heightAnchor.constraint(equalToConstant: 40)
        ])
            ADD_SPACER(to: hStackTabs, width: 16)
        
        let tabsHighlight = UIView()
        tabsHighlight.backgroundColor = DARK_MODE() ? .white  : UIColor(hex: 0x2D2D31)
        tabsHighlight.layer.cornerRadius = 20
        tabsBgView.addSubview(tabsHighlight)
        tabsHighlight.activateConstraints([
            tabsHighlight.leadingAnchor.constraint(equalTo: tabsBgView.leadingAnchor),
            tabsHighlight.topAnchor.constraint(equalTo: tabsBgView.topAnchor),
            tabsHighlight.heightAnchor.constraint(equalToConstant: 40),
            tabsHighlight.widthAnchor.constraint(equalTo: tabsBgView.widthAnchor, multiplier: 0.5)
        ])
    
        let tab1Label = UILabel()
        tab1Label.text = "Sign in"
        tab1Label.font = AILERON(16)
        tab1Label.textAlignment = .center
        tab1Label.textColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        tabsHighlight.addSubview(tab1Label)
        tab1Label.activateConstraints([
            tab1Label.centerYAnchor.constraint(equalTo: tabsHighlight.centerYAnchor),
            tab1Label.centerXAnchor.constraint(equalTo: tabsHighlight.centerXAnchor)
        ])
    
        let W: CGFloat = SCREEN_SIZE().width - 32
        
        
        let tab2Label = UILabel()
        tab2Label.text = "Sign up"
        tab2Label.font = AILERON(16)
        tab2Label.textAlignment = .center
        tab2Label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        tabsBgView.addSubview(tab2Label)
        tab2Label.activateConstraints([
            tab2Label.centerYAnchor.constraint(equalTo: tabsHighlight.centerYAnchor),
            tab2Label.centerXAnchor.constraint(equalTo: tabsBgView.centerXAnchor, constant: W/4)
        ])
    
        let tabButton = UIButton(type: .custom)
        tabButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        hStackTabs.addSubview(tabButton)
        tabButton.activateConstraints([
            tabButton.leadingAnchor.constraint(equalTo: tab2Label.leadingAnchor, constant: -20),
            tabButton.trailingAnchor.constraint(equalTo: tab2Label.trailingAnchor, constant: 20),
            tabButton.topAnchor.constraint(equalTo: tab2Label.topAnchor),
            tabButton.bottomAnchor.constraint(equalTo: tab2Label.bottomAnchor)
        ])
        tabButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)

        //---
        var extraHMargin: CGFloat = 0
        if(IPAD()){ extraHMargin += 80 }

        ADD_SPACER(to: self.VStack, height: 32)

        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)
        let VStack_form = VSTACK(into: HStack_form)
        //VStack_form.backgroundColor = .green
        ADD_SPACER(to: HStack_form, width: 20+extraHMargin)

        let titleLabel = UILabel()
        titleLabel.text = "Sign in"
        titleLabel.font = DM_SERIF_DISPLAY(23)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 32)

        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = AILERON(16)
        emailLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(emailLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.emailText.buildInto(vstack: VStack_form)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .next,
            charactersLimit: 50, placeHolderText: "Your Email", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.emailText.delegate = self
        ADD_SPACER(to: VStack_form, height: 16)
        
        let passLabel = UILabel()
        passLabel.text = "Password"
        passLabel.font = AILERON(16)
        passLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(passLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.passText.buildInto(vstack: VStack_form)
        self.passText.customize(keyboardType: .asciiCapable, returnType: .done,
            charactersLimit: 20, placeHolderText: "Your Password", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.passText.setPasswordMode(true)
        self.passText.delegate = self
        ADD_SPACER(to: VStack_form, height: 16)
        
        let forgotPassLabel = UILabel()
        forgotPassLabel.textColor = UIColor(hex: 0xDA4933)
        forgotPassLabel.font = AILERON(16)
        forgotPassLabel.text = "I've forgotten my password!"
        forgotPassLabel.addUnderline()
        VStack_form.addArrangedSubview(forgotPassLabel)
        ADD_SPACER(to: VStack_form, height: 24)
        
        let forgotPassButton = UIButton(type: .custom)
        forgotPassButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        VStack_form.addSubview(forgotPassButton)
        forgotPassButton.activateConstraints([
            forgotPassButton.leadingAnchor.constraint(equalTo: forgotPassLabel.leadingAnchor, constant: -5),
            forgotPassButton.topAnchor.constraint(equalTo: forgotPassLabel.topAnchor),
            forgotPassButton.widthAnchor.constraint(equalToConstant: 130),
            forgotPassButton.bottomAnchor.constraint(equalTo: forgotPassLabel.bottomAnchor)
        ])
        forgotPassButton.addTarget(self, action: #selector(forgotPassButtonTap(_:)), for: .touchUpInside)
        
        let hStack_mainActionButton = HSTACK(into: VStack_form)
        
        self.mainActionButton.backgroundColor = UIColor(hex: 0x60C4D6)
        self.mainActionButton.layer.cornerRadius = 4.0
        
        if(IPHONE()) {
            hStack_mainActionButton.addArrangedSubview(self.mainActionButton)
            mainActionButton.activateConstraints([
                self.mainActionButton.heightAnchor.constraint(equalToConstant: 52)
            ])
        } else {
            let buttonWidth: CGFloat = 300
            let spacerWidth: CGFloat = ( SCREEN_SIZE().width - 16 - 20 - (extraHMargin*2) - buttonWidth )/2
        
            ADD_SPACER(to: hStack_mainActionButton, width: spacerWidth)
            hStack_mainActionButton.addArrangedSubview(self.mainActionButton)
            mainActionButton.activateConstraints([
                self.mainActionButton.heightAnchor.constraint(equalToConstant: 52),
                self.mainActionButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
            ADD_SPACER(to: hStack_mainActionButton, width: spacerWidth)
        }
        
        self.mainActionButton.addTarget(self, action: #selector(mainActionButtonTap(_:)), for: .touchUpInside)
        ADD_SPACER(to: VStack_form, height: 50) // form bottom space
        
        let mainActionLabel = UILabel()
        mainActionLabel.text = "Sign in"
        mainActionLabel.textColor = UIColor(hex: 0x19191C)
        mainActionLabel.font = AILERON_SEMIBOLD(16)
        VStack_form.addSubview(mainActionLabel)
        mainActionLabel.activateConstraints([
            mainActionLabel.centerXAnchor.constraint(equalTo: self.mainActionButton.centerXAnchor),
            mainActionLabel.centerYAnchor.constraint(equalTo: self.mainActionButton.centerYAnchor)
        ])
        
        /*
        // ---- SOCIAL
        let socialLabel = UILabel()
        socialLabel.font = ROBOTO(16)
        socialLabel.textAlignment = .center
        socialLabel.textColor = UIColor(hex: 0xBBBDC0)
        socialLabel.text = "or user social networks to sign in:"
        VStack_form.addArrangedSubview(socialLabel)
        ADD_SPACER(to: VStack_form, height: 15)
        
        let hStackSocial = HSTACK(into: VStack_form)
        hStackSocial.spacing = 16
        
        var iconsCount = 3
        let sepWidth: CGFloat = SCREEN_SIZE().width - 16 - 20 - (extraHMargin * 2) -
            (35 * CGFloat(iconsCount)) - (hStackSocial.spacing * CGFloat(iconsCount)-1)
        
        iconsCount = 3
        ADD_SPACER(to: hStackSocial, width: sepWidth/2)
        for i in 1...iconsCount {
            //if(i==2 || i==3) {
                let file = "footerSocial_\(i)"
                let imgView = UIImageView(image: UIImage(named: file))
                hStackSocial.addArrangedSubview(imgView)
                imgView.activateConstraints([
                    imgView.widthAnchor.constraint(equalToConstant: 35),
                    imgView.heightAnchor.constraint(equalToConstant: 35)
                ])
                
                let button = UIButton(type: .custom)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                hStackSocial.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: imgView.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: imgView.trailingAnchor),
                    button.topAnchor.constraint(equalTo: imgView.topAnchor),
                    button.bottomAnchor.constraint(equalTo: imgView.bottomAnchor)
                ])
                button.tag = i
                button.addTarget(self, action: #selector(socialButtonOnTap(_:)), for: .touchUpInside)
            //}
        }
        ADD_SPACER(to: hStackSocial, width: sepWidth/2)
        ADD_SPACER(to: VStack_form, height: 15)
        
        // ---- SOCIAL
            
        
        
        
        let HStack_question = HSTACK(into: VStack_form)
        
        ADD_SPACER(to: HStack_question)
        let questionLabel1 = UILabel()
        questionLabel1.font = ROBOTO(16)
        questionLabel1.text = "Don’t have an account? - "
        questionLabel1.textColor = UIColor(hex: 0xBBBDC0)
        HStack_question.addArrangedSubview(questionLabel1)
        
        let questionLabel2 = UILabel()
        questionLabel2.font = ROBOTO(16)
        questionLabel2.text = "Click here to sign up!"
        questionLabel2.textColor = UIColor(hex: 0xDA4933)
        questionLabel2.addUnderline()
        HStack_question.addArrangedSubview(questionLabel2)
        ADD_SPACER(to: HStack_question)
        
        let questionButton = UIButton(type: .custom)
        questionButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        HStack_question.addSubview(questionButton)
        questionButton.activateConstraints([
            questionButton.leadingAnchor.constraint(equalTo: questionLabel2.leadingAnchor),
            questionButton.trailingAnchor.constraint(equalTo: questionLabel2.trailingAnchor),
            questionButton.topAnchor.constraint(equalTo: questionLabel2.topAnchor),
            questionButton.bottomAnchor.constraint(equalTo: questionLabel2.bottomAnchor)
        ])
        questionButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: VStack_form, height: 16)
        */
        
        // --------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewOnTap(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
                
    }

}

// MARK: - UI
extension SignInView {

    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.backgroundColor
        self.contentView.backgroundColor = self.backgroundColor

        for v in self.VStack.arrangedSubviews {
            self.setColorToView(v)
        }

        for v in self.VStack.subviews {
            self.setColorToView(v)
        }
        
//        self.contentView.layer.borderWidth = 6
//        self.contentView.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x28282D).cgColor : UIColor(hex: 0xE2E3E3).cgColor
    }
    
    // ------------
    func setColorToView(_ view: UIView) {
//        switch(view.tag) {
//            case 100:
//                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE2E3E3) // lines
//
//            case 101:
//                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white // tabs
//
//            default:
//                NOTHING()
//        }
//
//        if(view is UIStackView) {
//            for v in (view as! UIStackView).arrangedSubviews {
//                self.setColorToView(v)
//            }
//        }
    }
}

// MARK: Form stuff
extension SignInView {

    func validateForm() -> Bool {
        if(VALIDATE_EMAIL(self.emailText.text()) && VALIDATE_PASS(self.passText.text())) {
            return true
        }
        return false
    }
    
}

// MARK: - Events
extension SignInView {
    
    @objc func tabButtonOnTap(_ sender: UIButton?) {
        self.delegate?.SignInViewOnTabTap()
    }
    
    @objc func contentViewOnTap(_ sender: UITapGestureRecognizer) {
        HIDE_KEYBOARD(view: self)
    }
    
    @objc func forgotPassButtonTap(_ sender: UIButton) {
        let vc = ResetPassViewController()
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func mainActionButtonTap(_ sender: UIButton) {
//        self.emailText.setText("federico@improvethenews.org")
//        self.passText.setText("federico123")
        
        if(self.emailText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your email")
        } else if(!VALIDATE_EMAIL(self.emailText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
        } else if(self.passText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your password")
        } else {
            self.delegate?.SignInViewShowLoading(state: true)

            let email = self.emailText.text()
            let password = self.passText.text()
            API.shared.signIn(email: email, password: password) { (success, serverMsg, gotCookies) in
                if(success) {
                    NOTIFY(Notification_reloadMainFeedOnShow)
                    WRITE(LocalKeys.user.AUTHENTICATED, value: "YES")
                    
                    if(gotCookies) {
                        self.finishSignIn()
                    } else {
                        self.getCookies()
                    }
                    
                } else {
                    var showYesNo = false
                    if(serverMsg.lowercased().contains("not verified")) {
                        showYesNo = true
                    }
                    
                    if(showYesNo) {
                        let _msg = serverMsg + "\n\n" + "Resend the verification email?"
                        CustomNavController.shared.ask(question: _msg) { (result) in
                            if(result) { self.resend_verificationEmail() }
                        }
                    } else {
                        CustomNavController.shared.infoAlert(message: serverMsg)
                    }
                    
                    DELAY(2.0) {
                        self.delegate?.SignInViewShowLoading(state: false)
                    }
                }
            }

        }
    }
    
    private func finishSignIn() {
        MAIN_THREAD {
            CustomNavController.shared.menu.updateLogout()
                    
            self.delegate?.SignInViewShowLoading(state: false)
            CustomNavController.shared.popViewController(animated: true) // go back to main feed
        }
    }
    
    private func getCookies() {
        print("Obteniendo cookies (sliderValues)")
        API.shared.getUserInfo { (success, serverMsg, user) in
            if let _user = user, success {
                MainFeedv3.parseSliderValues(_user.sliderValues)
            }
            self.finishSignIn()
        }
    }
    
    private func resend_verificationEmail() {
        self.delegate?.SignInViewShowLoading(state: true)
        
        API.shared.resendVerificationEmail(email: self.emailText.text()) { (success, serverMsg) in
            if(success) {
                let msg = "Email resent succesfully"
                CustomNavController.shared.infoAlert(message: msg)
            } else {
                CustomNavController.shared.infoAlert(message: serverMsg)
            }
            
            DELAY(2.0) {
                self.delegate?.SignInViewShowLoading(state: false)
            }
        }
        
    }
    
    @objc func socialButtonOnTap(_ sender: UIButton) {
        self.delegate?.SignInOnSocialButtonTap(index: sender.tag)
    }
    
}

// MARK: - FormTextView
extension SignInView: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        if(sender == self.emailText) {
            self.passText.focus()
        } else {
            HIDE_KEYBOARD(view: self)
        }
    }
    
}

// MARK: - Keyboard stuff
extension SignInView {

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
        
        if(n.name==UIResponder.keyboardWillShowNotification){
            self.scrollViewBottomConstraint.constant = 0 - H
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            self.scrollViewBottomConstraint.constant = 0
        }
        
        self.layoutIfNeeded()
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }

}


