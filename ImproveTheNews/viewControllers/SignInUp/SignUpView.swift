//
//  SignUpView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/02/2023.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    func SignUpViewOnTabTap()
    func SignUpViewShowLoading(state: Bool)
    func SignUpOnSocialButtonTap(index: Int)
}


class SignUpView: UIView {

    weak var delegate: SignUpViewDelegate?

    let scrollView = UIScrollView()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    let contentView = UIView()
    var VStack: UIStackView!

    let emailText = FormTextView()
    let passText = FormTextView()
    let pass2Text = FormTextView()
    let newsLetterCheck = FormCheckView()
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
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IPAD_sideOffset()),
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
//        let HLine = UIView()
//        HLine.backgroundColor = .clear
//        self.VStack.addArrangedSubview(HLine)
//        HLine.activateConstraints([
//            HLine.heightAnchor.constraint(equalToConstant: 6)
//        ])
//        HLine.tag = 100
//
//        let hStack = HSTACK(into: VStack)
//        hStack.backgroundColor = .clear
//        hStack.activateConstraints([
//            hStack.heightAnchor.constraint(equalToConstant: 67)
//        ])
//        hStack.tag = 101
//
//        let tab1Label = UILabel()
//        tab1Label.text = "SIGN IN".capitalized
//        tab1Label.font = DM_SERIF_DISPLAY_fixed(16) //MERRIWEATHER_BOLD(16)
//        tab1Label.textAlignment = .center
//        tab1Label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        hStack.addArrangedSubview(tab1Label)
//        tab1Label.activateConstraints([
//            tab1Label.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE().width/2)-1)
//        ])
//
//        let vLine = UIView()
//        vLine.backgroundColor = .clear
//        hStack.addArrangedSubview(vLine)
//        vLine.activateConstraints([
//            vLine.widthAnchor.constraint(equalToConstant: 6)
//        ])
//        vLine.tag = 100
//
//        let tab2Label = UILabel()
//        tab2Label.text = "SIGN UP".capitalized
//        tab2Label.font = DM_SERIF_DISPLAY_fixed(16) //MERRIWEATHER_BOLD(16)
//        tab2Label.textAlignment = .center
//        tab2Label.textColor = UIColor(hex: 0xFF643C)
//        hStack.addArrangedSubview(tab2Label)
//
//        let tabButton = UIButton(type: .custom)
//        tabButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
//        hStack.addSubview(tabButton)
//        tabButton.activateConstraints([
//            tabButton.leadingAnchor.constraint(equalTo: tab1Label.leadingAnchor),
//            tabButton.trailingAnchor.constraint(equalTo: tab1Label.trailingAnchor),
//            tabButton.topAnchor.constraint(equalTo: tab1Label.topAnchor),
//            tabButton.bottomAnchor.constraint(equalTo: tab1Label.bottomAnchor)
//        ])
//        tabButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)
//
//        let HLine2 = UIView()
//        HLine2.backgroundColor = .clear
//        VStack.addSubview(HLine2)
//        HLine2.activateConstraints([
//            HLine2.leadingAnchor.constraint(equalTo: VStack.leadingAnchor, constant: 0),
//            HLine2.topAnchor.constraint(equalTo: VStack.topAnchor, constant: 67),
//            HLine2.heightAnchor.constraint(equalToConstant: 6),
//            HLine2.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width/2)
//        ])
//        HLine2.tag = 100
//        ADD_SPACER(to: self.VStack, height: 26)

        ADD_SPACER(to: self.VStack, height: IPHONE() ? 32 : 60)
        
        let hStackTabs = HSTACK(into: self.VStack)
        
            ADD_SPACER(to: hStackTabs, width: IPHONE() ? 16 : 120)
        let tabsBgView = UIView()
        tabsBgView.backgroundColor = .red
        tabsBgView.layer.cornerRadius = 20
        tabsBgView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
        hStackTabs.addArrangedSubview(tabsBgView)
        tabsBgView.activateConstraints([
            tabsBgView.heightAnchor.constraint(equalToConstant: 40)
        ])
            ADD_SPACER(to: hStackTabs, width: IPHONE() ? 16 : 120)
        
        let tabsHighlight = UIView()
        tabsHighlight.backgroundColor = DARK_MODE() ? .white  : UIColor(hex: 0x2D2D31)
        tabsHighlight.layer.cornerRadius = 20
        tabsBgView.addSubview(tabsHighlight)
        tabsHighlight.activateConstraints([
            tabsHighlight.trailingAnchor.constraint(equalTo: tabsBgView.trailingAnchor),
            tabsHighlight.topAnchor.constraint(equalTo: tabsBgView.topAnchor),
            tabsHighlight.heightAnchor.constraint(equalToConstant: 40),
            tabsHighlight.widthAnchor.constraint(equalTo: tabsBgView.widthAnchor, multiplier: 0.5)
        ])
        
        var W: CGFloat = SCREEN_SIZE().width - 32
        if(IPAD()){ W = SCREEN_SIZE().width - 240 }
        
        let tab1Label = UILabel()
        tab1Label.text = "Sign in"
        tab1Label.font = AILERON(16)
        tab1Label.textAlignment = .center
        tab1Label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        tabsHighlight.addSubview(tab1Label)
        tab1Label.activateConstraints([
            tab1Label.centerYAnchor.constraint(equalTo: tabsHighlight.centerYAnchor),
            tab1Label.centerXAnchor.constraint(equalTo: tabsBgView.centerXAnchor, constant: -(W/4))
        ])
    
        let tab2Label = UILabel()
        tab2Label.text = "Sign up"
        tab2Label.font = AILERON(16)
        tab2Label.textAlignment = .center
        tab2Label.textColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        tabsBgView.addSubview(tab2Label)
        tab2Label.activateConstraints([
            tab2Label.centerYAnchor.constraint(equalTo: tabsHighlight.centerYAnchor),
            tab2Label.centerXAnchor.constraint(equalTo: tabsHighlight.centerXAnchor)
        ])
    
        let tabButton = UIButton(type: .custom)
        tabButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        hStackTabs.addSubview(tabButton)
        tabButton.activateConstraints([
            tabButton.leadingAnchor.constraint(equalTo: tab1Label.leadingAnchor, constant: -20),
            tabButton.trailingAnchor.constraint(equalTo: tab1Label.trailingAnchor, constant: 20),
            tabButton.topAnchor.constraint(equalTo: tab1Label.topAnchor),
            tabButton.bottomAnchor.constraint(equalTo: tab1Label.bottomAnchor)
        ])
        tabButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)

        //---
        var extraHMargin: CGFloat = 0
        if(IPAD()){ extraHMargin += 200 }

        ADD_SPACER(to: self.VStack, height: 32)

        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)
        let VStack_form = VSTACK(into: HStack_form)
        VStack_form.backgroundColor = .clear //.green
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)

        let titleLabel = UILabel()
        titleLabel.text = "Sign up"
        titleLabel.font = DM_SERIF_DISPLAY(23)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 32)

//        let signUpNoteLabel = UILabel()
//        signUpNoteLabel.text = "Sign up for an Improve The News account"
//        signUpNoteLabel.numberOfLines = 0
//        signUpNoteLabel.font = ROBOTO(14)
//        signUpNoteLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        VStack_form.addArrangedSubview(signUpNoteLabel)
//        ADD_SPACER(to: VStack_form, height: 22)
        
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
        passLabel.text = "* Choose a password"
        passLabel.font = AILERON(16)
        passLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(passLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.passText.buildInto(vstack: VStack_form)
        self.passText.customize(keyboardType: .asciiCapable, returnType: .next,
            charactersLimit: 20, placeHolderText: "Your Password", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.passText.setPasswordMode(true)
        self.passText.delegate = self
        ADD_SPACER(to: VStack_form, height: 16)
        
        let pass2Label = UILabel()
        pass2Label.text = "* Confirm password"
        pass2Label.font = AILERON(16)
        pass2Label.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(pass2Label)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.pass2Text.buildInto(vstack: VStack_form)
        self.pass2Text.customize(keyboardType: .asciiCapable, returnType: .done,
            charactersLimit: 20, placeHolderText: "Your password", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.pass2Text.setPasswordMode(true)
        self.pass2Text.delegate = self
        ADD_SPACER(to: VStack_form, height: 24)
        
        let passNoteLabel = UILabel()
        passNoteLabel.textColor = titleLabel.textColor
        passNoteLabel.font = AILERON(16)
        passNoteLabel.numberOfLines = 0
        passNoteLabel.text = "* Password must contain minimum eight characters, at least one letter and one number."
        VStack_form.addArrangedSubview(passNoteLabel)
        ADD_SPACER(to: VStack_form, height: 22)
        
        self.newsLetterCheck.text = "Sign me up for the newsletter!"
        VStack_form.addArrangedSubview(self.newsLetterCheck)
        ADD_SPACER(to: VStack_form, height: 24)
        
        if(IPAD()){ ADD_SPACER(to: VStack_form, height: 32) }
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
        
        ADD_SPACER(to: VStack_form) // form bottom space
        
        let mainActionLabel = UILabel()
        mainActionLabel.text = "Sign up"
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
        socialLabel.textColor = UIColor(hex: 0x93A0B4)
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
            //if(i==2) {
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
        // ----
        
        let HStack_question = HSTACK(into: VStack_form)
        
        ADD_SPACER(to: HStack_question)
        let questionLabel1 = UILabel()
        questionLabel1.font = ROBOTO(16)
        questionLabel1.text = "Already have an account? - "
        questionLabel1.textColor = UIColor(hex: 0x93A0B4)
        HStack_question.addArrangedSubview(questionLabel1)
        
        let questionLabel2 = UILabel()
        questionLabel2.font = ROBOTO(16)
        questionLabel2.text = "Click here to sign in!"
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
        ADD_SPACER(to: VStack_form, height: 30)
        
        let HStackRect = HSTACK(into: VStack_form)
        HStackRect.backgroundColor = .clear //.yellow
        HStackRect.layer.borderWidth = 8
        HStackRect.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x2C3541).cgColor : UIColor(hex: 0xEAEBEC).cgColor
        ADD_SPACER(to: HStackRect, width: 24)
        let VStackRect = VSTACK(into: HStackRect)
        ADD_SPACER(to: HStackRect, width: 24)
        
        ADD_SPACER(to: VStackRect, height: 30)
        let rectTitle = UILabel()
        rectTitle.font = DM_SERIF_DISPLAY_fixed(18) //MERRIWEATHER_BOLD(18)
        rectTitle.numberOfLines = 0
        rectTitle.backgroundColor = .clear //.systemPink
        rectTitle.text = "Why you should sign up to Improve The News"
        rectTitle.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        VStackRect.addArrangedSubview(rectTitle)

        ADD_SPACER(to: VStackRect, height: 10)
        for i in 1...3 {
            ADD_SPACER(to: VStackRect, height: 16)
            
            let HStackItem = HSTACK(into: VStackRect)
            
            let VStackImage = VSTACK(into: HStackItem)
            let checkImage = UIImageView(image: UIImage(named: "slidersPanel.split.check"))
            VStackImage.addArrangedSubview(checkImage)
            checkImage.activateConstraints([
                checkImage.widthAnchor.constraint(equalToConstant: 18),
                checkImage.heightAnchor.constraint(equalToConstant: 14)
            ])
            ADD_SPACER(to: VStackImage)
            ADD_SPACER(to: HStackItem, width: 12)
            
            var text = ""
            switch(i) {
                case 1:
                    text = "Your news diet is shared across all your devices"
                case 2:
                    text = "One-click sharing to multiple social networks"
                default:
                    text = "You can hold news outlets accountable by raising flags about articles"
            }
            
            let itemLabel = UILabel()
            itemLabel.font = ROBOTO(16)
            itemLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            itemLabel.numberOfLines = 0
            itemLabel.text = text
            HStackItem.addArrangedSubview(itemLabel)
        }
        ADD_SPACER(to: VStackRect, height: 30)
        ADD_SPACER(to: VStack_form, height: 50)
        */
        
        // --------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewOnTap(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
                
    }

}

// MARK: - UI
extension SignUpView {

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
extension SignUpView {

    func validateForm() -> Bool {
        if(VALIDATE_EMAIL(self.emailText.text()) && VALIDATE_PASS(self.passText.text())) {
            return true
        }
        return false
    }
    
}

// MARK: - Events
extension SignUpView {
    
    @objc func tabButtonOnTap(_ sender: UIButton) {
        self.delegate?.SignUpViewOnTabTap()
    }
    
    @objc func contentViewOnTap(_ sender: UITapGestureRecognizer) {
        HIDE_KEYBOARD(view: self)
    }
    
    @objc func forgotPassButtonTap(_ sender: UIButton) {
        print("Forgot pass")
    }
    
    @objc func mainActionButtonTap(_ sender: UIButton) {
    
//        self.emailText.setText("federico@improvethenews.org")
//        self.passText.setText("federico123")
//        self.pass2Text.setText("federico123")

        if(self.emailText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your email")
        } else if(!VALIDATE_EMAIL(self.emailText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
        } else if(self.passText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your password")
        } else if(!VALIDATE_PASS(self.passText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid password")
        } else if(self.passText.text() != self.pass2Text.text()) {
            CustomNavController.shared.infoAlert(message: "The password and the confirmation must match")
        } else {
            self.delegate?.SignUpViewShowLoading(state: true)
            
            let email = self.emailText.text()
            let password = self.passText.text()
            API.shared.signUp(email: email, password: password, newsletter: self.newsLetterCheck.status) { (success, msg) in
                if(success) {
                    let msg = "Registration successful. You'll receive a validation email to complete the process"
                    CustomNavController.shared.infoAlert(message: msg)
                    UUID.shared.trace()
                } else {
                    CustomNavController.shared.infoAlert(message: msg)
                }
                
                DELAY(2.0) {
                    self.delegate?.SignUpViewShowLoading(state: false)
                }
            }
        }
    }
    
    @objc func socialButtonOnTap(_ sender: UIButton) {
        self.delegate?.SignUpOnSocialButtonTap(index: sender.tag)
    }
    
}

// MARK: - FormTextView
extension SignUpView: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        if(sender == self.emailText) {
            self.passText.focus()
        } else if(sender == self.passText) {
            self.pass2Text.focus()
        } else {
            HIDE_KEYBOARD(view: self)
        }
    }
    
}

// MARK: - Keyboard stuff
extension SignUpView {

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

func VALIDATE_PASS(_ text: String) -> Bool {
    // password must contain minimum 8 characters, at least one letter and one number
    
    var result = false
    if(text.count >= 8) {
        let _text = text.lowercased()
        let _letters = "abcdefghijklmnopqrstuvwxyz"
        let _numbers = "0123456789"
        
        var L = false
        var N = false
        for i in _text {
            let currentChar = String(i)
            if(_letters.contains(currentChar)) {
                L = true
            }
            if(_numbers.contains(currentChar)) {
                N = true
            }
        }
        
        if(L && N) {
            result = true
        }
    }
    
    return result
}

