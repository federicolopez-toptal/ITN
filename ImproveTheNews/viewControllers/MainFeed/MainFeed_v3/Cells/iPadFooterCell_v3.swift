//
//  iPadFooterCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadFooterCell_v3: UITableViewCell {
    static let identifier = "iPadFooterCell_v3"
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        //top line
        let topLine = UIView()
        self.contentView.addSubview(topLine)
        topLine.activateConstraints([
            topLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        topLine.tag = 11
        
        let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
        self.contentView.addSubview(logo)
        logo.activateConstraints([
            logo.widthAnchor.constraint(equalToConstant: 121),
            logo.heightAnchor.constraint(equalToConstant: 25),
            logo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 45),
            logo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16*2)
        ])
        logo.tag = 44
        
        
        let vSep: CGFloat = 20
        
        let sliders = self.createItemWith(text: "How our sliders work", into: self.contentView, tag: 1)
        sliders.activateConstraints([
            sliders.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 44),
            sliders.leadingAnchor.constraint(equalTo: logo.leadingAnchor),
            sliders.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE().width-32)/2)
        ])
        
        let about = self.createItemWith(text: "About", into: self.contentView, tag: 2)
        about.activateConstraints([
            about.topAnchor.constraint(equalTo: sliders.bottomAnchor, constant: vSep),
            about.leadingAnchor.constraint(equalTo: logo.leadingAnchor)
        ])
        
        let feedback = self.createItemWith(text: "Feedback", into: self.contentView, tag: 3)
        feedback.activateConstraints([
            feedback.topAnchor.constraint(equalTo: about.bottomAnchor, constant: vSep),
            feedback.leadingAnchor.constraint(equalTo: logo.leadingAnchor)
        ])
        
        let privacy = self.createItemWith(text: "Privacy Policy", into: self.contentView, tag: 4)
        privacy.activateConstraints([
            //privacy.topAnchor.constraint(equalTo: newsletter.bottomAnchor, constant: vSep),
            privacy.topAnchor.constraint(equalTo: sliders.topAnchor),
            privacy.leadingAnchor.constraint(equalTo: sliders.leadingAnchor, constant: 200)
        ])
        
        
//        let feedback = self.createItemWith(text: "Feedback", into: self.contentView, tag: 3)
//        feedback.activateConstraints([
//            feedback.topAnchor.constraint(equalTo: sliders.topAnchor),
//            feedback.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SCREEN_SIZE().width/2)
//        ])
        
        let linkedin = self.createSocialButton("linkedin", into: self.contentView, tag: 3)
        linkedin.activateConstraints([
            linkedin.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            linkedin.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16*2)
        ])
        
        let facebook = self.createSocialButton("facebook", into: self.contentView, tag: 2)
        facebook.activateConstraints([
            facebook.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            facebook.trailingAnchor.constraint(equalTo: linkedin.leadingAnchor, constant: -12)
        ])

        let twitter = self.createSocialButton("twitter", into: self.contentView, tag: 1)
        twitter.activateConstraints([
            twitter.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            twitter.trailingAnchor.constraint(equalTo: facebook.leadingAnchor, constant: -12)
        ])
        
        // -------
        let ITNLogo = UIImageView(image: UIImage(named: DisplayMode.imageName("ITNF_logo")))
        self.contentView.addSubview(ITNLogo)
        ITNLogo.activateConstraints([
            ITNLogo.widthAnchor.constraint(equalToConstant: 108),
            ITNLogo.heightAnchor.constraint(equalToConstant: 32),
            ITNLogo.trailingAnchor.constraint(equalTo: linkedin.trailingAnchor),
            ITNLogo.bottomAnchor.constraint(equalTo: feedback.bottomAnchor),
        ])
        ITNLogo.tag = 88
        
//        let newsletter = self.createItemWith(text: "Newsletter Archive", into: self.contentView, tag: 5)
//        newsletter.activateConstraints([
//            newsletter.topAnchor.constraint(equalTo: sliders.topAnchor),
//            newsletter.leadingAnchor.constraint(equalTo: ITNLogo.leadingAnchor)
//        ])
        
        //bottom line
        let bottomLine = UIView()
        self.contentView.addSubview(bottomLine)
        bottomLine.activateConstraints([
            bottomLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.bottomAnchor.constraint(equalTo: feedback.bottomAnchor, constant: 36),
        ])
        bottomLine.tag = 12
        
        // Copyright
        let copyrightLabel = UILabel()
        copyrightLabel.textColor = CSS.shared.displayMode().sec_textColor
        copyrightLabel.text = "© 2025 Improve the News Foundation. All rights reserved."
        copyrightLabel.font = AILERON(15)
        self.contentView.addSubview(copyrightLabel)
        copyrightLabel.activateConstraints([
            copyrightLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 22),
            copyrightLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16*2)
        ])
        
        self.refreshDisplayMode()
    }
    
    func createSocialButton(_ social: String, into container: UIView, tag: Int) -> UIView {
        let imageView = UIImageView(image: UIImage(named: social))
        container.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        let buttonArea = UIButton(type: .system)
        container.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5),
            buttonArea.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            buttonArea.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
        ])
        buttonArea.tag = 30+tag
        buttonArea.addTarget(self, action: #selector(onSocialButtonTap(_:)), for: .touchUpInside)
        
        return imageView
    }
    
    func createItemWith(text: String, into container: UIView, tag: Int) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = CSS.shared.iPhoneFooter_font
        
        container.addSubview(label)
        
        let buttonArea = UIButton(type: .system)
        container.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5),
            buttonArea.topAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            buttonArea.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
        buttonArea.tag = 20+tag
        buttonArea.addTarget(self, action: #selector(onButtonAreaTap(_:)), for: .touchUpInside)
        
        return label
    }
    
    @objc func onButtonAreaTap(_ sender: UIButton) {
        let tag = sender.tag - 20
        
        switch(tag) {
            case 1:
                self.slidersButtonTap()
                
            case 2:
                self.aboutButtonTap()
                
            case 3:
                self.feedbackButtonTap()
                
            case 4:
                self.privacyPolicyButtonTap()
                
            case 5:
                self.newsletterArchiveOnTap()
                
            default:
                NOTHING()
        }
    }
    
    @objc func onSocialButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 30
        var url: String?
        
        switch(tag) {
            case 1:
                url = "https://mobile.twitter.com/improvethenews?s=20&t=oDcqiWUkosy7MIlZ4M8elA"
            case 2:
                url = "https://m.facebook.com/Improve-the-News-104135748200889"
            case 3:
                url = "https://www.linkedin.com/mwlite/company/improvethenews"
                
            default:
                NOTHING()
        }
        
        if let _url = url {
            OPEN_URL(_url)
        }
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        if let topLine = self.viewWithTag(11) {
            topLine.backgroundColor = CSS.shared.displayMode().main_bgColor
            self.addDashesTo(topLine)
        }
        if let bottomLine = self.viewWithTag(12) {
            bottomLine.backgroundColor = CSS.shared.displayMode().main_bgColor
            self.addDashesTo(bottomLine)
        }
        
        for V in self.contentView.subviews {
            if let _label = V as? UILabel {
                _label.textColor = CSS.shared.displayMode().sec_textColor
            }
        }
        
        let logo = self.contentView.viewWithTag(44) as! UIImageView
        logo.image = UIImage(named: DisplayMode.imageName("verity.logo"))
        
        let ITNLogo = self.contentView.viewWithTag(88) as! UIImageView
        ITNLogo.image = UIImage(named: DisplayMode.imageName("ITNF_logo"))

    }
    
}

extension iPadFooterCell_v3 {

    private func addDashesTo(_ view: UIView) {
        REMOVE_ALL_SUBVIEWS(from: view)
        
        var valX: CGFloat = 0
        var maxDim: CGFloat = SCREEN_SIZE().width
        if(SCREEN_SIZE().height > maxDim) { maxDim = SCREEN_SIZE().height }
        
        while(valX < maxDim) {
            let dashView = UIView()
            dashView.backgroundColor = CSS.shared.displayMode().line_color
            view.addSubview(dashView)
            dashView.activateConstraints([
                dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: valX),
                dashView.widthAnchor.constraint(equalToConstant: CSS.shared.dashedLine_width),
                dashView.topAnchor.constraint(equalTo: view.topAnchor),
                dashView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
            valX += (CSS.shared.dashedLine_width * 2)
        }
    }
    
    static func getHeight() -> CGFloat {
        return 410
    }
}

extension iPadFooterCell_v3 {

    func slidersButtonTap() {
        DELAY(0.5) {
            let vc = PreferencesViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
            DELAY(0.3) {
                vc.scrollToSliders()
            }
        }
    }
    
    func feedbackButtonTap() {
        DELAY(0.5) {
            let vc = FeedbackFormViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func privacyPolicyButtonTap() {
        DELAY(0.5) {
            let vc = PrivacyPolicyViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func aboutButtonTap() {
        DELAY(0.5) {
            let vc = FAQViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func newsletterArchiveOnTap() {
        OPEN_URL( ITN_URL() + "/newsletters" )
    }
    
}
