//
//  AccountViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/05/2023.
//

import UIKit

class AccountViewController: BaseViewController {

    let navBar = NavBarView()

    let scrollView = UIScrollView()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    let contentView = UIView()
    var VStack: UIStackView!

    let firstNameText = FormTextView()
    let lastNameText = FormTextView()
    let userNameText = FormTextView()
    let emailText = FormTextView()
    
    var subscriptionType = 0
    let subscriptionStateLabel = UILabel()
    let subscribeButtonLabel = UILabel()
    let circle1 = UIImageView(image: UIImage(named: "slidersOrangeThumb")?.withRenderingMode(.alwaysTemplate))
    let circle2 = UIImageView(image: UIImage(named: "slidersOrangeThumb")?.withRenderingMode(.alwaysTemplate))
    
    let circleMark1 = UIImageView(image: UIImage(named: "slidersOrangeThumb")?.withRenderingMode(.alwaysTemplate))
    let circleMark2 = UIImageView(image: UIImage(named: "slidersOrangeThumb")?.withRenderingMode(.alwaysTemplate))
    
    // MARK: - End
    deinit {
        self.hideLoading()
        self.removeKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoading()
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("My Account")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            for (i, vc) in CustomNavController.shared.viewControllers.enumerated() {
                if(vc is SignInUpViewController) {
                    CustomNavController.shared.viewControllers.remove(at: i)
                    break
                }
            }
            
            self.loadUserData()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
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
        var extraHMargin: CGFloat = 0
        if(IPAD()){ extraHMargin += 120 }
    
        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)
        let VStack_form = VSTACK(into: HStack_form)
        VStack_form.tag = 50
        //VStack_form.backgroundColor = .green
        ADD_SPACER(to: HStack_form, width: 20+extraHMargin)

        ADD_SPACER(to: VStack_form, height: 32)

//        let blablaLabel = UILabel()
//        blablaLabel.numberOfLines = 0
//        blablaLabel.text = "Hi! You can manage your account settings below."
//        blablaLabel.font = ROBOTO(14)
//        blablaLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
//        VStack_form.addArrangedSubview(blablaLabel)
//        ADD_SPACER(to: VStack_form, height: 25)
    
        let titleLabel = UILabel()
        titleLabel.text = "My Account"
        titleLabel.font = DM_SERIF_DISPLAY_resize(23)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 24)
        
        // -------
        let firstNameLabel = UILabel()
        firstNameLabel.text = "First name"
        firstNameLabel.font = AILERON_resize(16)
        firstNameLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(firstNameLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.firstNameText.buildInto(vstack: VStack_form)
        self.firstNameText.customize(keyboardType: .asciiCapable, returnType: .next,
            charactersLimit: 30, placeHolderText: "First name", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.firstNameText.delegate = self
        ADD_SPACER(to: VStack_form, height: 16)
        // -------
        let lastNameLabel = UILabel()
        lastNameLabel.text = "Last name"
        lastNameLabel.font = AILERON_resize(16)
        lastNameLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(lastNameLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.lastNameText.buildInto(vstack: VStack_form)
        self.lastNameText.customize(keyboardType: .asciiCapable, returnType: .next,
            charactersLimit: 30, placeHolderText: "Last name", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.lastNameText.delegate = self
        ADD_SPACER(to: VStack_form, height: 20)
        // -------
        let userNameLabel = UILabel()
        userNameLabel.text = "Screen name"
        userNameLabel.font = AILERON_resize(16)
        userNameLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(userNameLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.userNameText.buildInto(vstack: VStack_form)
        self.userNameText.customize(keyboardType: .asciiCapable, returnType: .next,
            charactersLimit: 30, placeHolderText: "Screen name", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.userNameText.delegate = self
        ADD_SPACER(to: VStack_form, height: 20)
        // -------
        let EmailLabel = UILabel()
        EmailLabel.text = "Email address"
        EmailLabel.font = AILERON_resize(16)
        EmailLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(EmailLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.emailText.buildInto(vstack: VStack_form)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .next,
            charactersLimit: 30, placeHolderText: "Email address", textColor: DARK_MODE() ? UIColor(hex: 0x4C4E50) : UIColor(hex: 0xBBBDC0) )
        self.emailText.setEnabled(false)
        ADD_SPACER(to: VStack_form, height: 32)
        // -------
        let hStack_saveUserInfoButton = HSTACK(into: VStack_form)
        
        let saveUserInfoButton = UIButton(type: .custom)
        saveUserInfoButton.backgroundColor = UIColor(hex: 0x60C4D6)
        saveUserInfoButton.layer.cornerRadius = 4.0
        
        if(IPHONE()) {
            hStack_saveUserInfoButton.addArrangedSubview(saveUserInfoButton)
            saveUserInfoButton.activateConstraints([
                saveUserInfoButton.heightAnchor.constraint(equalToConstant: 52)
            ])
        } else {
            let buttonWidth: CGFloat = 300
            let spacerWidth: CGFloat = ( SCREEN_SIZE().width - 16 - 20 - (extraHMargin*2) - buttonWidth )/2
        
            ADD_SPACER(to: hStack_saveUserInfoButton, width: spacerWidth)
            hStack_saveUserInfoButton.addArrangedSubview(saveUserInfoButton)
            saveUserInfoButton.activateConstraints([
                saveUserInfoButton.heightAnchor.constraint(equalToConstant: 52),
                saveUserInfoButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
            ADD_SPACER(to: hStack_saveUserInfoButton, width: spacerWidth)
        }

        saveUserInfoButton.addTarget(self, action: #selector(saveUserInfoButtonTap(_:)), for: .touchUpInside)
        ADD_SPACER(to: VStack_form, height: 32)
        
        let saveUserInfoLabel = UILabel()
        saveUserInfoLabel.text = "Save"
        saveUserInfoLabel.textColor = UIColor(hex: 0x19191C)
        saveUserInfoLabel.font = AILERON_SEMIBOLD(16)
        VStack_form.addSubview(saveUserInfoLabel)
        saveUserInfoLabel.activateConstraints([
            saveUserInfoLabel.centerXAnchor.constraint(equalTo: saveUserInfoButton.centerXAnchor),
            saveUserInfoLabel.centerYAnchor.constraint(equalTo: saveUserInfoButton.centerYAnchor)
        ])
        // -------
        
        let line1 = UIView()
        line1.backgroundColor = .systemPink
        line1.activateConstraints([
            line1.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        line1.tag = 200+1
        VStack_form.addArrangedSubview(line1)
        //ADD_HDASHES(to: line1)
        ADD_SPACER(to: VStack_form, height: 24)
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "Verity Newsletter"
        titleLabel2.font = DM_SERIF_DISPLAY_resize(23)
        titleLabel2.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel2)
        ADD_SPACER(to: VStack_form, height: 24)
        
        let line1b = UIView()
        line1b.backgroundColor = .systemPink
        line1b.activateConstraints([
            line1b.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        line1b.tag = 200 + 2
        VStack_form.addArrangedSubview(line1b)
        //ADD_HDASHES(to: line1b)
        ADD_SPACER(to: VStack_form, height: 32)
        
        // ------
        let hStackSubscription = HSTACK(into: VStack_form)
        hStackSubscription.activateConstraints([
            hStackSubscription.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let vStackLogo = VSTACK(into: hStackSubscription)
        ADD_SPACER(to: vStackLogo, height: 2)
        
            let logoBgView = UIView()
            logoBgView.backgroundColor = DARK_MODE() ? .white : .black
            vStackLogo.addArrangedSubview(logoBgView)
            logoBgView.activateConstraints([
                logoBgView.widthAnchor.constraint(equalToConstant: 40),
                logoBgView.heightAnchor.constraint(equalToConstant: 40)
            ])
            logoBgView.layer.cornerRadius = 20
        
            let letterV = UIImageView(image: UIImage(named: "VLogo")?.withRenderingMode(.alwaysTemplate))
            letterV.tintColor = DARK_MODE() ? .black : .white
            logoBgView.addSubview(letterV)
            letterV.activateConstraints([
                letterV.widthAnchor.constraint(equalToConstant: 15),
                letterV.heightAnchor.constraint(equalToConstant: 19),
                letterV.centerXAnchor.constraint(equalTo: logoBgView.centerXAnchor),
                letterV.centerYAnchor.constraint(equalTo: logoBgView.centerYAnchor)
            ])
        
//        let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verityLogo")))
//        vStackLogo.addArrangedSubview(logo)
//        logo.activateConstraints([
//            logo.widthAnchor.constraint(equalToConstant: 40),
//            logo.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        logo.layer.cornerRadius = 20
        
        ADD_SPACER(to: vStackLogo, height: 2)
        ADD_SPACER(to: hStackSubscription, width: 10)
        
        self.subscriptionStateLabel.numberOfLines = 0
        self.subscriptionStateLabel.text = "Newsletter"
        self.subscriptionStateLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.subscriptionStateLabel.font = AILERON_resize(16)
        //self.subscriptionStateLabel.backgroundColor = .red.withAlphaComponent(0.25)
        hStackSubscription.addArrangedSubview(self.subscriptionStateLabel)
        ADD_SPACER(to: hStackSubscription)
        
        let subscribeButton = UIButton(type: .custom)
        subscribeButton.backgroundColor = UIColor(hex: 0x60C4D6)
        subscribeButton.layer.cornerRadius = 4.0
        hStackSubscription.addArrangedSubview(subscribeButton)
        subscribeButton.activateConstraints([
            subscribeButton.widthAnchor.constraint(equalToConstant: 125),
            subscribeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTap(_:)), for: .touchUpInside)
        
        self.subscribeButtonLabel.text = "..."
        self.subscribeButtonLabel.textColor = UIColor(hex: 0x19191C)
        self.subscribeButtonLabel.font = AILERON_SEMIBOLD(16)
        hStackSubscription.addSubview(self.subscribeButtonLabel)
        self.subscribeButtonLabel.activateConstraints([
            self.subscribeButtonLabel.centerXAnchor.constraint(equalTo: subscribeButton.centerXAnchor),
            self.subscribeButtonLabel.centerYAnchor.constraint(equalTo: subscribeButton.centerYAnchor)
        ])
        
        ADD_SPACER(to: VStack_form, height: 32)
        
//        ADD_SPACER(to: VStack_form, height: 30)
//        let newsletterFreqLabel = UILabel()
//        newsletterFreqLabel.text = "Newsletter frequency"
//        newsletterFreqLabel.font = AILERON_resize(16)
//        newsletterFreqLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
//        VStack_form.addArrangedSubview(newsletterFreqLabel)
//        ADD_SPACER(to: VStack_form, height: 32)
        
//        //---
//        let hStackSubscriptionStyle = HSTACK(into: VStack_form)
//        
//        hStackSubscriptionStyle.addArrangedSubview(circle1)
//        circle1.activateConstraints([
//            circle1.widthAnchor.constraint(equalToConstant: 20),
//            circle1.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        self.circle1.alpha = 0.3
//        self.circle1.tintColor = UIColor(hex: 0x60C4D6)
//        ADD_SPACER(to: hStackSubscriptionStyle, width: 8)
//        let dailyNewsletterLabel = UILabel()
//        dailyNewsletterLabel.text = "Daily"
//        dailyNewsletterLabel.font = AILERON_resize(16)
//        dailyNewsletterLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
//        hStackSubscriptionStyle.addArrangedSubview(dailyNewsletterLabel)
//        
//        let buttonCircle1 = UIButton(type: .custom)
//        buttonCircle1.backgroundColor = .clear //.green.withAlphaComponent(0.3)
//        hStackSubscriptionStyle.addSubview(buttonCircle1)
//        buttonCircle1.activateConstraints([
//            buttonCircle1.leadingAnchor.constraint(equalTo: circle1.leadingAnchor, constant: -10),
//            buttonCircle1.topAnchor.constraint(equalTo: circle1.topAnchor, constant: -10),
//            buttonCircle1.bottomAnchor.constraint(equalTo: circle1.bottomAnchor, constant: 10),
//            buttonCircle1.trailingAnchor.constraint(equalTo: dailyNewsletterLabel.trailingAnchor, constant: 10)
//        ])
//        buttonCircle1.tag = 1
//        buttonCircle1.addTarget(self, action: #selector(subscriptionTypeButtonTap(_:)), for: .touchUpInside)
//        
//            //---
//        ADD_SPACER(to: hStackSubscriptionStyle, width: 25)
//        hStackSubscriptionStyle.addArrangedSubview(circle2)
//        circle2.activateConstraints([
//            circle2.widthAnchor.constraint(equalToConstant: 20),
//            circle2.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        self.circle2.alpha = 0.3
//        self.circle2.tintColor = UIColor(hex: 0x60C4D6)
//        ADD_SPACER(to: hStackSubscriptionStyle, width: 8)
//        let weeklyNewsletterLabel = UILabel()
//        weeklyNewsletterLabel.text = "Weekly"
//        weeklyNewsletterLabel.font = AILERON_resize(16)
//        weeklyNewsletterLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
//        hStackSubscriptionStyle.addArrangedSubview(weeklyNewsletterLabel)
//        
//        let buttonCircle2 = UIButton(type: .custom)
//        buttonCircle2.backgroundColor = .clear //.green.withAlphaComponent(0.3)
//        hStackSubscriptionStyle.addSubview(buttonCircle2)
//        buttonCircle2.activateConstraints([
//            buttonCircle2.leadingAnchor.constraint(equalTo: circle2.leadingAnchor, constant: -10),
//            buttonCircle2.topAnchor.constraint(equalTo: circle2.topAnchor, constant: -10),
//            buttonCircle2.bottomAnchor.constraint(equalTo: circle2.bottomAnchor, constant: 10),
//            buttonCircle2.trailingAnchor.constraint(equalTo: weeklyNewsletterLabel.trailingAnchor, constant: 10)
//        ])
//        buttonCircle2.tag = 2
//        buttonCircle2.addTarget(self, action: #selector(subscriptionTypeButtonTap(_:)), for: .touchUpInside)
//        ADD_SPACER(to: hStackSubscriptionStyle)
//        ADD_SPACER(to: VStack_form, height: 32)
//        
//        hStackSubscriptionStyle.addSubview(self.circleMark1)
//        self.circleMark1.tintColor = .black.withAlphaComponent(0.5)
//        self.circleMark1.activateConstraints([
//            self.circleMark1.widthAnchor.constraint(equalToConstant: 12),
//            self.circleMark1.heightAnchor.constraint(equalToConstant: 12),
//            self.circleMark1.centerXAnchor.constraint(equalTo: self.circle1.centerXAnchor),
//            self.circleMark1.centerYAnchor.constraint(equalTo: self.circle2.centerYAnchor)
//        ])
//        self.circleMark1.hide()
//        
//        hStackSubscriptionStyle.addSubview(self.circleMark2)
//        self.circleMark2.tintColor = .black.withAlphaComponent(0.5)
//        self.circleMark2.activateConstraints([
//            self.circleMark2.widthAnchor.constraint(equalToConstant: 12),
//            self.circleMark2.heightAnchor.constraint(equalToConstant: 12),
//            self.circleMark2.centerXAnchor.constraint(equalTo: self.circle2.centerXAnchor),
//            self.circleMark2.centerYAnchor.constraint(equalTo: self.circle2.centerYAnchor)
//        ])
//        self.circleMark2.hide()
//        
//        //---
        let line2 = UIView()
        line2.backgroundColor = .systemPink //DARK_MODE() ? .white.withAlphaComponent(0.3) : .black.withAlphaComponent(0.3)
        line2.activateConstraints([
            line2.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        line2.tag = 200 + 3
        VStack_form.addArrangedSubview(line2)
        //ADD_HDASHES(to: line2)
        ADD_SPACER(to: VStack_form, height: 24)
//
//    //--- SOCIAL
//        let titleLabel_21 = UILabel()
//        titleLabel_21.text = "Connected social accounts"
//        titleLabel_21.font = DM_SERIF_DISPLAY_fixed(18) //MERRIWEATHER_BOLD(18)
//        titleLabel_21.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        VStack_form.addArrangedSubview(titleLabel_21)
//        ADD_SPACER(to: VStack_form, height: 20)
//        
//        // >> Linkedin
//        let hStackSocial1 = HSTACK(into: VStack_form)
//        let socialImgView1 = UIImageView(image: UIImage(named: "footerSocial_2"))
//        hStackSocial1.addArrangedSubview(socialImgView1)
//        socialImgView1.activateConstraints([
//            socialImgView1.widthAnchor.constraint(equalToConstant: 35),
//            socialImgView1.heightAnchor.constraint(equalToConstant: 35)
//        ])
//        ADD_SPACER(to: hStackSocial1, width: 15)
//        let socialNameLabel1 = UILabel()
//        socialNameLabel1.text = "Linkedin"
//        socialNameLabel1.font = ROBOTO(16)
//        socialNameLabel1.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        hStackSocial1.addArrangedSubview(socialNameLabel1)
//        ADD_SPACER(to: hStackSocial1)
//        
//        let socialButton1 = UIButton(type: .custom)
//        socialButton1.backgroundColor = .lightGray //UIColor(hex: 0xFF643C)
//        socialButton1.layer.cornerRadius = 4.0
//        hStackSocial1.addArrangedSubview(socialButton1)
//        socialButton1.activateConstraints([
//            socialButton1.widthAnchor.constraint(equalToConstant: 125),
//            socialButton1.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        socialButton1.tag = 100+1
//        socialButton1.addTarget(self, action: #selector(socialButtonTap(_:)), for: .touchUpInside)
//        
//        let socialButtonLabel1 = UILabel()
//        socialButtonLabel1.text = "..."
//        socialButtonLabel1.textColor = .white
//        socialButtonLabel1.font = ROBOTO_BOLD(13)
//        hStackSocial1.addSubview(socialButtonLabel1)
//        socialButtonLabel1.activateConstraints([
//            socialButtonLabel1.centerXAnchor.constraint(equalTo: socialButton1.centerXAnchor),
//            socialButtonLabel1.centerYAnchor.constraint(equalTo: socialButton1.centerYAnchor)
//        ])
//        socialButtonLabel1.tag = 200+1
//        ADD_SPACER(to: VStack_form, height: 30)
//        // Linkedin <<
//        // -------------------------------------
//        
//        // >> Twitter
//        let hStackSocial2 = HSTACK(into: VStack_form)
//        let socialImgView2 = UIImageView(image: UIImage(named: "footerSocial_1"))
//        hStackSocial2.addArrangedSubview(socialImgView2)
//        socialImgView2.activateConstraints([
//            socialImgView2.widthAnchor.constraint(equalToConstant: 35),
//            socialImgView2.heightAnchor.constraint(equalToConstant: 35)
//        ])
//        ADD_SPACER(to: hStackSocial2, width: 15)
//        let socialNameLabel2 = UILabel()
//        socialNameLabel2.text = "Twitter"
//        socialNameLabel2.font = ROBOTO(16)
//        socialNameLabel2.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        hStackSocial2.addArrangedSubview(socialNameLabel2)
//        ADD_SPACER(to: hStackSocial2)
//
//        let socialButton2 = UIButton(type: .custom)
//        socialButton2.backgroundColor = .lightGray //UIColor(hex: 0xFF643C)
//        socialButton2.layer.cornerRadius = 4.0
//        hStackSocial2.addArrangedSubview(socialButton2)
//        socialButton2.activateConstraints([
//            socialButton2.widthAnchor.constraint(equalToConstant: 125),
//            socialButton2.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        socialButton2.tag = 100+2
//        socialButton2.addTarget(self, action: #selector(socialButtonTap(_:)), for: .touchUpInside)
//
//        let socialButtonLabel2 = UILabel()
//        socialButtonLabel2.text = "..."
//        socialButtonLabel2.textColor = .white
//        socialButtonLabel2.font = ROBOTO_BOLD(13)
//        hStackSocial2.addSubview(socialButtonLabel2)
//        socialButtonLabel2.activateConstraints([
//            socialButtonLabel2.centerXAnchor.constraint(equalTo: socialButton2.centerXAnchor),
//            socialButtonLabel2.centerYAnchor.constraint(equalTo: socialButton2.centerYAnchor)
//        ])
//        socialButtonLabel2.tag = 200+2
//        ADD_SPACER(to: VStack_form, height: 30)
//        // Twitter <<
//        // -------------------------------------
//        
//        // >> Facebook
//        let hStackSocial3 = HSTACK(into: VStack_form)
//        let socialImgView3 = UIImageView(image: UIImage(named: "footerSocial_3"))
//        hStackSocial3.addArrangedSubview(socialImgView3)
//        socialImgView3.activateConstraints([
//            socialImgView3.widthAnchor.constraint(equalToConstant: 35),
//            socialImgView3.heightAnchor.constraint(equalToConstant: 35)
//        ])
//        ADD_SPACER(to: hStackSocial3, width: 15)
//        let socialNameLabel3 = UILabel()
//        socialNameLabel3.text = "Facebook"
//        socialNameLabel3.font = ROBOTO(16)
//        socialNameLabel3.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
//        hStackSocial3.addArrangedSubview(socialNameLabel3)
//        ADD_SPACER(to: hStackSocial3)
//
//        let socialButton3 = UIButton(type: .custom)
//        socialButton3.backgroundColor = .lightGray //UIColor(hex: 0xFF643C)
//        socialButton3.layer.cornerRadius = 4.0
//        hStackSocial3.addArrangedSubview(socialButton3)
//        socialButton3.activateConstraints([
//            socialButton3.widthAnchor.constraint(equalToConstant: 125),
//            socialButton3.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        socialButton3.tag = 100+3
//        socialButton3.addTarget(self, action: #selector(socialButtonTap(_:)), for: .touchUpInside)
//
//        let socialButtonLabel3 = UILabel()
//        socialButtonLabel3.text = "..."
//        socialButtonLabel3.textColor = .white
//        socialButtonLabel3.font = ROBOTO_BOLD(13)
//        hStackSocial3.addSubview(socialButtonLabel3)
//        socialButtonLabel3.activateConstraints([
//            socialButtonLabel3.centerXAnchor.constraint(equalTo: socialButton3.centerXAnchor),
//            socialButtonLabel3.centerYAnchor.constraint(equalTo: socialButton3.centerYAnchor)
//        ])
//        socialButtonLabel3.tag = 200+3
//        ADD_SPACER(to: VStack_form, height: 30)
//        // Facebook <<
//
//        let line21 = UIView()
//        line21.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.3) : .black.withAlphaComponent(0.3)
//        line21.activateConstraints([
//            line21.heightAnchor.constraint(equalToConstant: 0.75)
//        ])
//        VStack_form.addArrangedSubview(line21)
//        ADD_SPACER(to: VStack_form, height: 30)
//        
//    //---
        let titleLabel3 = UILabel()
        titleLabel3.text = "Sign Out"
        titleLabel3.font = DM_SERIF_DISPLAY_resize(23)
        titleLabel3.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel3)
        ADD_SPACER(to: VStack_form, height: 24)
        
        let line2b = UIView()
        line2b.backgroundColor = .systemPink //DARK_MODE() ? .white.withAlphaComponent(0.3) : .black.withAlphaComponent(0.3)
        line2b.activateConstraints([
            line2b.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        line2b.tag = 200 + 4
        VStack_form.addArrangedSubview(line2b)
        //ADD_HDASHES(to: line2b)
        ADD_SPACER(to: VStack_form, height: 32)

        let hStackSignOut = HSTACK(into: VStack_form)
        
        let signOutLabel = UILabel()
        signOutLabel.numberOfLines = 0
        signOutLabel.text = "Sign Out of your Verity Account"
        signOutLabel.font = AILERON_resize(16)
        signOutLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        hStackSignOut.addArrangedSubview(signOutLabel)
        
        ADD_SPACER(to: hStackSignOut)
        
        let signOutButton = UIButton(type: .custom)
        signOutButton.backgroundColor = UIColor(hex: 0x60C4D6)
        signOutButton.layer.cornerRadius = 4.0
        hStackSignOut.addArrangedSubview(signOutButton)
        signOutButton.activateConstraints([
            signOutButton.widthAnchor.constraint(equalToConstant: 125),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        signOutButton.addTarget(self, action: #selector(signOutButtonTap(_:)), for: .touchUpInside)
        
        let signOutButtonLabel = UILabel()
        signOutButtonLabel.text = "Sign Out"
        signOutButtonLabel.textColor = UIColor(hex: 0x19191C)
        signOutButtonLabel.font = AILERON_SEMIBOLD(16)
        hStackSignOut.addSubview(signOutButtonLabel)
        signOutButtonLabel.activateConstraints([
            signOutButtonLabel.centerXAnchor.constraint(equalTo: signOutButton.centerXAnchor),
            signOutButtonLabel.centerYAnchor.constraint(equalTo: signOutButton.centerYAnchor)
        ])
        
        ADD_SPACER(to: VStack_form, height: 32)
        
        
        //---
        let line3 = UIView()
        line3.backgroundColor = .systemPink //DARK_MODE() ? .white.withAlphaComponent(0.3) : .black.withAlphaComponent(0.3)
        line3.activateConstraints([
            line3.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        line3.tag = 200+5
        VStack_form.addArrangedSubview(line3)
        //ADD_HDASHES(to: line3)
        ADD_SPACER(to: VStack_form, height: 24)
        
        ///////////////////
        let titleLabel4 = UILabel()
        titleLabel4.text = "Close My Account"
        titleLabel4.font = DM_SERIF_DISPLAY_resize(23)
        titleLabel4.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel4)
        ADD_SPACER(to: VStack_form, height: 24)
        
            let line3b = UIView()
            line3b.backgroundColor = .systemPink //DARK_MODE() ? .white.withAlphaComponent(0.3) : .black.withAlphaComponent(0.3)
            line3b.activateConstraints([
                line3b.heightAnchor.constraint(equalToConstant: 0.75)
            ])
            line3b.tag = 200+6
            VStack_form.addArrangedSubview(line3b)
            //ADD_HDASHES(to: line3b)
            ADD_SPACER(to: VStack_form, height: 32)
        
        
        //let hStackDelete = HSTACK(into: VStack_form)
        
//        let deleteIcon = UIImageView(image: UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysTemplate))
//        deleteIcon.tintColor = UIColor(hex: 0xDA4933)
//        hStackDelete.addArrangedSubview(deleteIcon)
//        deleteIcon.activateConstraints([
//            deleteIcon.widthAnchor.constraint(equalToConstant: 44),
//            deleteIcon.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        ADD_SPACER(to: hStackDelete, width: 10)
        
        let deleteLabel = UILabel()
        deleteLabel.numberOfLines = 0
        deleteLabel.text = "Close my Account and disconnect any\nsocial accounts"
        deleteLabel.font = AILERON_resize(16)
        deleteLabel.setLineSpacing(lineSpacing: 6.0)
        deleteLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(deleteLabel)
        ADD_SPACER(to: VStack_form, height: 18)
        
        //ADD_SPACER(to: hStackDelete)
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.backgroundColor = UIColor(hex: 0x60C4D6)
        deleteButton.layer.cornerRadius = 4.0
        VStack_form.addArrangedSubview(deleteButton)
        deleteButton.activateConstraints([
            deleteButton.widthAnchor.constraint(equalToConstant: 125),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        deleteButton.addTarget(self, action: #selector(deleteButtonTap(_:)), for: .touchUpInside)
        
        let deleteButtonLabel = UILabel()
        deleteButtonLabel.text = "Close"
        deleteButtonLabel.textColor = UIColor(hex: 0x19191C)
        deleteButtonLabel.font = AILERON_SEMIBOLD(16)
        deleteButton.addSubview(deleteButtonLabel)
        deleteButtonLabel.activateConstraints([
            deleteButtonLabel.centerXAnchor.constraint(equalTo: deleteButton.centerXAnchor),
            deleteButtonLabel.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor)
        ])
        
        ADD_SPACER(to: VStack_form, height: 60)
        self.addHLines()
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.navBar.refreshDisplayMode()
        
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    func loadUserData() {
        self.showLoading()
        self.contentView.isUserInteractionEnabled = false
        API.shared.getUserInfo { (success, serverMsg, user) in
            self.hideLoading()
            
            //---
            MAIN_THREAD {
                self.contentView.isUserInteractionEnabled = true
            
                if let _user = user {
                    self.firstNameText.setText(_user.firstName)
                    self.lastNameText.setText(_user.lastName)
                    self.userNameText.setText(_user.userName)
                    self.emailText.setText(_user.email)
                    
                    self.subscriptionType = 0 //_user.subscriptionType
                    self.updateSubscriptionType()
                    
                    self.updateSocialNetworks(_user.socialnetworks)
                }
            }
            //---
        }
    }
    
    func updateSubscriptionType() {
        /*
            0: Not subscribed
            1: Daily
            2: Weekly
         */
    
//        let type = self.subscriptionType
//    
//        if(type==0) {
//            //self.subscriptionStateLabel.text = "Status:\nnot subscribed"
//            self.subscribeButtonLabel.text = "SUBSCRIBE".capitalized
//            self.circle1.alpha = 0.3
//            self.circle2.alpha = 0.3
//            self.circleMark1.hide()
//            self.circleMark2.hide()
//        } else {
//            //self.subscriptionStateLabel.text = "Status:\nsubscribed"
//            self.subscribeButtonLabel.text = "UNSUBSCRIBE".capitalized
//            self.circle1.alpha = 1.0
//            self.circle2.alpha = 1.0
//            
//            if(type==1) {
//                self.circleMark1.show()
//                self.circleMark2.hide()
//            } else {
//                self.circleMark1.hide()
//                self.circleMark2.show()
//            }
//        }

        self.subscribeButtonLabel.text = "Manage"
    }
    
    func updateSocialNetworks(_ socialnetworks: [String]) {
        // Linkedin (1)
        if(socialnetworks.contains("Linkedin")) {
            self.updateSocialButton(1, state: true)
        } else {
            self.updateSocialButton(1, state: false)
        }
        
        // Twitter (2)
        if(socialnetworks.contains("Twitter")) {
            self.updateSocialButton(2, state: true)
        } else {
            self.updateSocialButton(2, state: false)
        }
        
        // Fcebook (3)
        if(socialnetworks.contains("Facebook")) {
            self.updateSocialButton(3, state: true)
        } else {
            self.updateSocialButton(3, state: false)
        }
    }
    
    private func updateSocialButton(_ index: Int, state: Bool) {
        MAIN_THREAD {
            if let button = self.view.viewWithTag(100+index) as? UIButton {
                button.backgroundColor = state ? UIColor(hex: 0xDA4933) : .lightGray
            }
            
            if let label = self.view.viewWithTag(200+index) as? UILabel {
                label.text = state ? "DISCONNECT" : "CONNECT"
            }
        }
    }

}

extension AccountViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: - Keyboard stuff
extension AccountViewController {

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
        
        self.view.layoutIfNeeded()
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }

}

// MARK: - FormTextView
extension AccountViewController: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        if(sender == self.firstNameText) {
            self.lastNameText.focus()
        } else if(sender == self.lastNameText) {
            self.userNameText.focus()
        } else if(sender == self.userNameText) {
            HIDE_KEYBOARD(view: self.view)
        }
    }
    
}

// MARK: - Events
extension AccountViewController {

    @objc func saveUserInfoButtonTap(_ sender: UIButton) {
        self.showLoading()
        
        var userData = MyUser()
        userData.firstName = self.firstNameText.text()
        userData.lastName = self.lastNameText.text()
        userData.userName = self.userNameText.text()
        userData.email = self.emailText.text()
        
        API.shared.userInfoSave(user: userData) { (success, serverMsg) in
            var msg = serverMsg
            if(success) { msg = "User data successfully updated" }
            
            self.hideLoading()
            CustomNavController.shared.infoAlert(message: msg)
        }
    }
    
    @objc func subscribeButtonTap(_ sender: UIButton) {
        let vc = NewsletterSignUp()
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func subscribeButtonTap_old(_ sender: UIButton) { //!!!
        self.showLoading()
        self.contentView.isUserInteractionEnabled = false
        
        var state = false
        if(self.subscriptionType == 0){ state = true }
        
        API.shared.subscribeToNewsletter(email: self.emailText.text(), state) { (success, serverMsg) in
            MAIN_THREAD {
                self.contentView.isUserInteractionEnabled = true
                
                if(!success) {
                    CustomNavController.shared.infoAlert(message: serverMsg)
                } else {
                    if(!state) {
                        self.subscriptionType = 0
                    } else {
                        self.subscriptionType = 1
                    }
                    
                    self.updateSubscriptionType()
                    CustomNavController.shared.infoAlert(message: "Newsletter options successfully updated")
                }
            }
            
            self.hideLoading()
        }
    }
    
    @objc func subscriptionTypeButtonTap(_ sender: UIButton) {
        if(subscriptionType == 0) { return }
        
        if(sender.tag != subscriptionType) {
            self.showLoading()
            API.shared.changeSubscriptionTypeTo(type: sender.tag, email: self.emailText.text()) { (success, serverMSg) in
                MAIN_THREAD { //---
                    if(!success) {
                        CustomNavController.shared.infoAlert(message: serverMSg)
                    } else {
                        self.subscriptionType = sender.tag
                        CustomNavController.shared.infoAlert(message: "Newsletter options successfully updated")
                    }
                    
                    self.hideLoading()
                    self.updateSubscriptionType()
                } //---
            }
        }
    }
    
    @objc func signOutButtonTap(_ sender: UIButton) {
        let msg = "Are you sure you want to sign out\nfrom your account?"
        CustomNavController.shared.ask(question: msg) { (success) in
            if(success) {
                WRITE(LocalKeys.preferences.sourceFilters, value: "")
                WRITE(LocalKeys.user.AUTHENTICATED, value: "NO")
                CustomNavController.shared.menu.updateLogout()
            
                DELETE(key: LocalKeys.user.UUID)
                DELETE(key: LocalKeys.user.JWT)
            
                CustomNavController.shared.menu.resetAllSettings()
                NOTIFY(Notification_reloadMainFeedOnShow)
            
                if(Layout.current() == .textOnly) {
                    CustomNavController.shared.menu.changeLayout()
                }
                
                if(DisplayMode.current() == .bright) {
                    CustomNavController.shared.menu.changeDisplayMode()
                }
            
                CustomNavController.shared.popViewController(animated: true)
            }
        }
    }
    
    @objc func deleteButtonTap(_ sender: UIButton) { 
        let msg = "Are you sure you want to delete your account? This will remove all your data from our system. This action cannot be undone."
        
        CustomNavController.shared.ask(question: msg) { (success) in
            if(success) {
                self.showLoading()
                API.shared.deleteAccount { (success, serverMsg) in
                    MAIN_THREAD {
                        self.hideLoading()
                        if(!success) {
                            CustomNavController.shared.infoAlert(message: serverMsg)
                        } else {
                            WRITE(LocalKeys.preferences.sourceFilters, value: "")
                            WRITE(LocalKeys.user.AUTHENTICATED, value: "NO")
                            CustomNavController.shared.menu.updateLogout()
                            
                            DELETE(key: LocalKeys.user.UUID)
                            DELETE(key: LocalKeys.user.JWT)
                
                            CustomNavController.shared.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func socialButtonTap(_ sender: UIButton) {
        let index = sender.tag - 100
        
        if(sender.backgroundColor == UIColor(hex: 0xFF643C)) { // ON
            CustomNavController.shared.ask(question: "Disconnect this social network?") { (answer) in
                if(answer) {
                    if(index==1) { // Linkedin
                        self.showLoading()
                        LinkedIn_SDK.shared.disconnect { (succes) in
                            self.hideLoading()
                            if(succes) {
                                self.updateSocialButton(1, state: false)
                            }
                        }
                    } else if(index==2) { // Twitter
                        self.showLoading()
                        Twitter_SDK.shared.disconnect { (succes) in
                            self.hideLoading()
                            if(succes) {
                                self.updateSocialButton(2, state: false)
                            }
                        }
                    } else if(index==3) { // Facebook
                        self.showLoading()
                        Facebook_SDK.shared.disconnect { (succes) in
                            self.hideLoading()
                            if(succes) {
                                self.updateSocialButton(3, state: false)
                            }
                        }
                    }
                }
            }
        } else { // OFF
            if(index==1) { // Linkedin
                LinkedIn_SDK.shared.login(vc: self) { (success) in
                    self.hideLoading()
                    if(success) {
                        self.updateSocialButton(1, state: true)
                    }
                }
            } else if(index==2) { // Twitter
                Twitter_SDK.shared.login(vc: self) { (success) in
                    self.hideLoading()
                    if(success) {
                        self.updateSocialButton(2, state: true)
                    }
                }
            } else if(index==3) { // Facebook
                Facebook_SDK.shared.login(vc: self) { (success) in
                    self.hideLoading()
                    if(success) {
                        self.updateSocialButton(3, state: true)
                    }
                }
            }
        }
    }

}

extension AccountViewController {

    func addHLines() {
        for i in 1...6 {
            if let line = self.view.viewWithTag(200+i) {
                line.hide()
                
                let newLine = UIView()
                self.contentView.addSubview(newLine)
                newLine.activateConstraints([
                    newLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                    newLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                    newLine.topAnchor.constraint(equalTo: line.topAnchor),
                    newLine.heightAnchor.constraint(equalTo: line.heightAnchor),
                ])
                
                newLine.backgroundColor = CSS.shared.displayMode().main_bgColor
                ADD_HDASHES(to: newLine)
            }
        }
    }
    
    

}
