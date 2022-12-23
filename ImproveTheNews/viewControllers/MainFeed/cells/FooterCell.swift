//
//  FooterCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/10/2022.
//

import UIKit

class FooterCell: UICollectionViewCell {

    static let identifier = "FooterCell"
    weak var viewController: UIViewController?
    
    let logoImageView = UIImageView()
    let subTitle = UILabel()
    let line = UIView()
    let copyrightLabel = UILabel()
    let followLabel = UILabel()
    
    let ITEMS_FONT = ROBOTO_BOLD(12)
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // -----------------------------------
    private func buildContent() {
        self.contentView.backgroundColor = .white

        self.contentView.addSubview(self.logoImageView)
        self.logoImageView.activateConstraints([
            self.logoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.logoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 28),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 163),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        self.subTitle.text = "A non-profit news aggregator helping you break out of your filter bubble"
        self.subTitle.numberOfLines = 2
        self.subTitle.font = ROBOTO(14)
        self.contentView.addSubview(self.subTitle)
        self.subTitle.activateConstraints([
            self.subTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.subTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -55),
            self.subTitle.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 18)
        ])
        
    // ITEM(s)
        let shareLabel = self.addItem("SHARE", below: self.subTitle,
            separation: 18, icon: "footerShareIcon",
            action: #selector(self.onShareButtonTap(_:)))
            
        let howWorksLabel = self.addItem("HOW THE SLIDERS WORK", below: shareLabel,
            separation: 10, action: #selector(self.onHowWorksButtonTap(_:)))
        
//        let faqLabel = self.addItem("FAQ", below: howWorksLabel,
//            separation: 10, action: #selector(self.onFAQButtonTap(_:)))
        
        let feedbackLabel = self.addItem("FEEDBACK", below: howWorksLabel, //faqLabel,
            separation: 10, action: #selector(self.onFeedbackButtonTap(_:)))
            
        let privacyLabel = self.addItem("PRIVACY POLICY", below: feedbackLabel,
            separation: 10, action: #selector(self.onPrivacyPolicyButtonTap(_:)))
    // ---------------
    
        self.contentView.addSubview(self.line)
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.line.heightAnchor.constraint(equalToConstant: 1.0),
            self.line.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 20)
        ])
        
        self.copyrightLabel.text = "© 2022 Improve The News Foundation, all Rights Reserved"
        self.copyrightLabel.numberOfLines = 2
        self.copyrightLabel.font = ROBOTO(12)
        self.contentView.addSubview(self.copyrightLabel)
        self.copyrightLabel.activateConstraints([
            self.copyrightLabel.topAnchor.constraint(equalTo: self.line.bottomAnchor, constant: 18),
            self.copyrightLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.copyrightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
        ])
        
        let socialStack = HSTACK(into: self.contentView, spacing: 8)
        socialStack.backgroundColor = .clear //.yellow
        socialStack.activateConstraints([
            socialStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            socialStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
            socialStack.topAnchor.constraint(equalTo: self.copyrightLabel.bottomAnchor, constant: 18)
        ])
        
        self.followLabel.text = "FOLLOW US"
        self.followLabel.font = ROBOTO_BOLD(12)
        socialStack.addArrangedSubview(self.followLabel)
        
        ADD_SPACER(to: socialStack, width: 5)
        for i in 1...4 {
            let socialButton = UIButton(type: .system)
            socialButton.backgroundColor = .clear //.black
            socialButton.setImage(UIImage(named: "footerSocial_\(i)")?.withRenderingMode(.alwaysOriginal), for: .normal)
            socialStack.addArrangedSubview(socialButton)
            socialButton.activateConstraints([
                socialButton.widthAnchor.constraint(equalToConstant: 30),
                socialButton.heightAnchor.constraint(equalToConstant: 30)
            ])
            socialButton.tag = 10 + i
            socialButton.addTarget(self, action: #selector(onSocialButtonTap(_:)), for: .touchUpInside)
        }
        ADD_SPACER(to: socialStack)
    }
    
    func addItem(_ text: String, below: UIView, separation: CGFloat, icon: String? = nil, action: Selector) -> UILabel {
    // label
        let label = UILabel()
        label.text = text
        label.font = self.ITEMS_FONT
        self.contentView.addSubview(label)
        label.activateConstraints([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            label.topAnchor.constraint(equalTo: below.bottomAnchor, constant: separation)
        ])
        
    // icon
        if let _icon = icon {
            let iconImageView = UIImageView(image: UIImage(named: _icon))
            self.contentView.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
                iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 23),
                iconImageView.heightAnchor.constraint(equalToConstant: 23)
            ])
        }
    
    // button area
        let buttonArea = UIButton(type: .system)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.contentView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5),
            buttonArea.topAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            buttonArea.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
        buttonArea.addTarget(self, action: action, for: .touchUpInside)
        
        return label
    }
    
    func populate(with header: DP_footer) {
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202E) : UIColor(hex: 0xE8E9EA)
        self.logoImageView.image = UIImage(named: DisplayMode.imageName("navBar.logo"))
        self.subTitle.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x212E43) : UIColor(hex: 0xC3C9CF)
        self.copyrightLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.followLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        
        for view in self.contentView.subviews {
            if let label = view as? UILabel, (label.font == self.ITEMS_FONT) {
                label.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
            }
        }
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 360) //380
    }
}

// MARK: Events
extension FooterCell {
    
    @objc func onShareButtonTap(_ sender: UIButton) {
        if let _vc = self.viewController {
            SHARE_URL("http://www.improvethenews.org", from: _vc)
        }
    }
    
    @objc func onSocialButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 10
        
        var url: String?
        switch(tag) {
            case 1:
                url = "https://mobile.twitter.com/improvethenews?s=20&t=oDcqiWUkosy7MIlZ4M8elA"
            case 2:
                url = "https://www.linkedin.com/mwlite/company/improvethenews"
            case 3:
                url = "https://m.facebook.com/Improve-the-News-104135748200889"
            case 4:
                url = "https://www.reddit.com/r/improvethenews/"
  
            default:
                url = nil
        }
        
        
        if let _url = url {
            OPEN_URL(_url)
        }
    }
    
    @objc func onHowWorksButtonTap(_ sender: UIButton) {
        let vc = PreferencesViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.2) {
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
            vc.scrollToSliders()
        }
    }
    
    @objc func onFeedbackButtonTap(_ sender: UIButton) {
        let vc = FeedbackFormViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.2) {
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
        }
    }
    
    @objc func onPrivacyPolicyButtonTap(_ sender: UIButton) {
        let vc = PrivacyPolicyViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.2) {
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
        }
    }
    
    @objc func onFAQButtonTap(_ sender: UIButton) {
        let vc = FAQViewController()
        CustomNavController.shared.viewControllers = [vc]

        DELAY(0.2) {
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
        }
    }
    
}
