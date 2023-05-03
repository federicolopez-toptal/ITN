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
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
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
        let HLine = UIView()
        HLine.backgroundColor = .red
        self.VStack.addArrangedSubview(HLine)
        HLine.activateConstraints([
            HLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        HLine.tag = 100

        let hStack = HSTACK(into: VStack)
        hStack.backgroundColor = .blue
        hStack.activateConstraints([
            hStack.heightAnchor.constraint(equalToConstant: 67)
        ])
        hStack.tag = 101

        let tab1Label = UILabel()
        tab1Label.text = "SIGN IN"
        tab1Label.font = ROBOTO_BOLD(14)
        tab1Label.textAlignment = .center
        tab1Label.textColor = UIColor(hex: 0xFF643C)
        hStack.addArrangedSubview(tab1Label)
        tab1Label.activateConstraints([
            tab1Label.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE().width/2)-1)
        ])

        let vLine = UIView()
        vLine.backgroundColor = .red
        hStack.addArrangedSubview(vLine)
        vLine.activateConstraints([
            vLine.widthAnchor.constraint(equalToConstant: 1)
        ])
        vLine.tag = 100

        let tab2Label = UILabel()
        tab2Label.text = "SIGN UP"
        tab2Label.font = ROBOTO_BOLD(14)
        tab2Label.textAlignment = .center
        tab2Label.textColor = UIColor(hex: 0x93A0B4)
        hStack.addArrangedSubview(tab2Label)

        let tabButton = UIButton(type: .custom)
        tabButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        hStack.addSubview(tabButton)
        tabButton.activateConstraints([
            tabButton.leadingAnchor.constraint(equalTo: tab2Label.leadingAnchor),
            tabButton.trailingAnchor.constraint(equalTo: tab2Label.trailingAnchor),
            tabButton.topAnchor.constraint(equalTo: tab2Label.topAnchor),
            tabButton.bottomAnchor.constraint(equalTo: tab2Label.bottomAnchor)
        ])
        tabButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)

        let HLine2 = UIView()
        HLine2.backgroundColor = .red
        VStack.addSubview(HLine2)
        HLine2.activateConstraints([
            HLine2.leadingAnchor.constraint(equalTo: VStack.leadingAnchor, constant: (SCREEN_SIZE().width/2)),
            HLine2.topAnchor.constraint(equalTo: VStack.topAnchor, constant: 67),
            HLine2.heightAnchor.constraint(equalToConstant: 1),
            HLine2.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width/2)
        ])
        HLine2.tag = 100
        ADD_SPACER(to: self.VStack, height: 26)

        var extraHMargin: CGFloat = 0
        if(IPAD()){ extraHMargin += 80 }

        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)
        let VStack_form = VSTACK(into: HStack_form)
        //VStack_form.backgroundColor = .green
        ADD_SPACER(to: HStack_form, width: 20+extraHMargin)

        let titleLabel = UILabel()
        titleLabel.text = "Sign in"
        titleLabel.font = MERRIWEATHER_BOLD(18)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 30)

        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = ROBOTO(14)
        emailLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        VStack_form.addArrangedSubview(emailLabel)
        ADD_SPACER(to: VStack_form, height: 12)
        
        self.emailText.buildInto(vstack: VStack_form)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .next,
            charactersLimit: 50, placeHolderText: "Your Email", textColor: DARK_MODE() ? .white : UIColor(hex: 0x1D242F) )
        self.emailText.delegate = self
        ADD_SPACER(to: VStack_form, height: 20)
        
        let passLabel = UILabel()
        passLabel.text = "Password"
        passLabel.font = ROBOTO(14)
        passLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        VStack_form.addArrangedSubview(passLabel)
        ADD_SPACER(to: VStack_form, height: 12)
        
        self.passText.buildInto(vstack: VStack_form)
        self.passText.customize(keyboardType: .asciiCapable, returnType: .done,
            charactersLimit: 20, placeHolderText: "Choose Password", textColor: DARK_MODE() ? .white : UIColor(hex: 0x1D242F))
        self.passText.setPasswordMode(true)
        self.passText.delegate = self
        ADD_SPACER(to: VStack_form, height: 14)
        
        let forgotPassLabel = UILabel()
        forgotPassLabel.textColor = UIColor(hex: 0xFF643C)
        forgotPassLabel.font = ROBOTO(15)
        forgotPassLabel.text = "Forgot password"
        forgotPassLabel.addUnderline()
        VStack_form.addArrangedSubview(forgotPassLabel)
        ADD_SPACER(to: VStack_form, height: 14)
        
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
        
        self.mainActionButton.backgroundColor = UIColor(hex: 0xFF643C)
        self.mainActionButton.layer.cornerRadius = 4.0
        VStack_form.addArrangedSubview(self.mainActionButton)
        mainActionButton.activateConstraints([
            self.mainActionButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        self.mainActionButton.addTarget(self, action: #selector(mainActionButtonTap(_:)), for: .touchUpInside)
        ADD_SPACER(to: VStack_form, height: 24)
        
        let mainActionLabel = UILabel()
        mainActionLabel.text = "SIGN IN"
        mainActionLabel.textColor = .white
        mainActionLabel.font = ROBOTO_BOLD(13)
        VStack_form.addSubview(mainActionLabel)
        mainActionLabel.activateConstraints([
            mainActionLabel.centerXAnchor.constraint(equalTo: self.mainActionButton.centerXAnchor),
            mainActionLabel.centerYAnchor.constraint(equalTo: self.mainActionButton.centerYAnchor)
        ])
        
        let HStack_question = HSTACK(into: VStack_form)
        
        ADD_SPACER(to: HStack_question)
        let questionLabel1 = UILabel()
        questionLabel1.font = ROBOTO(16)
        questionLabel1.text = "Don’t have an account? - "
        questionLabel1.textColor = UIColor(hex: 0x93A0B4)
        HStack_question.addArrangedSubview(questionLabel1)
        
        let questionLabel2 = UILabel()
        questionLabel2.font = ROBOTO(16)
        questionLabel2.text = "Click here to sign up!"
        questionLabel2.textColor = UIColor(hex: 0xFF643C)
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
        
        // --------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewOnTap(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
                
    }

}

// MARK: - UI
extension SignInView {

    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.scrollView.backgroundColor = self.backgroundColor
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : .white

        for v in self.VStack.arrangedSubviews {
            self.setColorToView(v)
        }

        for v in self.VStack.subviews {
            self.setColorToView(v)
        }
    }
    
    // ------------
    func setColorToView(_ view: UIView) {
        switch(view.tag) {
            case 100:
                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : UIColor(hex: 0xE2E3E3)

            case 101:
                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : .white

            default:
                NOTHING()
        }

        if(view is UIStackView) {
            for v in (view as! UIStackView).arrangedSubviews {
                self.setColorToView(v)
            }
        }
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
    
    @objc func tabButtonOnTap(_ sender: UIButton) {
        self.delegate?.SignInViewOnTabTap()
    }
    
    @objc func contentViewOnTap(_ sender: UITapGestureRecognizer) {
        HIDE_KEYBOARD(view: self)
    }
    
    @objc func forgotPassButtonTap(_ sender: UIButton) {
        FUTURE_IMPLEMENTATION("Show \"Forgot password\" form")
    }
    
    @objc func mainActionButtonTap(_ sender: UIButton) {
//        self.emailText.setText("gatolab@gmail.com")
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
            API.shared.signIn(email: email, password: password) { (success, serverMsg) in
                if(success) {
//                    let msg = "Login ok!"
//                    CustomNavController.shared.infoAlert(message: msg)
//
                    FUTURE_IMPLEMENTATION("Redirect to the ACCOUNT info screen")
                } else {
                    var showYesNo = false
                    if(serverMsg.lowercased().contains("not verified")) {
                        showYesNo = true
                    }
                    
                    if(showYesNo) {
                        let _msg = serverMsg + "\n\n" + "Resend the verification email?"
                        CustomNavController.shared.yesNoAlert(message: _msg) { (result) in
                            if(result) { self.resend_verificationEmail() }
                        }
                    } else {
                        CustomNavController.shared.infoAlert(message: serverMsg)
                    }
                }
                
                DELAY(2.0) {
                    self.delegate?.SignInViewShowLoading(state: false)
                }
            }

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


