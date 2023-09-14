//
//  iPadFooterCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadFooterCell: UITableViewCell {

    static let identifier = "iPadFooterCell"
    weak var viewController: UIViewController?
    
    var labels = [UILabel]()
    let subTitle = UILabel()
    let followLabel = UILabel()
    
    let line = UIView()
    let copyrightLabel = UILabel()
    let podcastLabel = UILabel()
    let bottomView = UIView()
    var podcastStack = UIStackView()
    

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        let margin = IPAD_ITEMS_SEP
        
        let hStack = HSTACK(into: self.contentView)
        hStack.spacing = margin
        hStack.distribution = .fillEqually
        hStack.backgroundColor = .clear //.yellow.withAlphaComponent(0.1)
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            hStack.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        let column1 = VSTACK(into: hStack)
//        column1.backgroundColor = .red.withAlphaComponent(0.1)
        
            ADD_SPACER(to: column1, height: 20)
            let hStackLogo = HSTACK(into: column1)
            
                let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
                hStackLogo.addArrangedSubview(logo)
                logo.activateConstraints([
                    logo.widthAnchor.constraint(equalToConstant: 475 * 0.23),
                    logo.heightAnchor.constraint(equalToConstant: 97 * 0.23)
                ])
                ADD_SPACER(to: hStackLogo)
            
            ADD_SPACER(to: column1, height: 10)
            self.subTitle.text = "The whole truth behind every major news story.\nAll angles covered."
            self.subTitle.numberOfLines = 2
            self.subTitle.font = ROBOTO(14)
            column1.addArrangedSubview(self.subTitle)
            
            ADD_SPACER(to: column1, height: 25)
            let shareItem = self.addItem("SHARE", to: column1,
                icon: "footerShareIcon", iconMargin: 50,
                action: #selector(self.onShareButtonTap(_:)))
            self.labels.append(shareItem)
            
            ADD_SPACER(to: column1, height: 18)
            let socialStack = HSTACK(into: column1, spacing: 8)
            socialStack.backgroundColor = .clear //.yellow
        
            self.followLabel.text = "FOLLOW US"
            self.followLabel.font = ROBOTO_BOLD(12)
            socialStack.addArrangedSubview(self.followLabel)
            
            ADD_SPACER(to: socialStack, width: 5)
            for i in 1...3 { //4 {
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
            
            
            
            
            ADD_SPACER(to: column1)
        
        
        let column2 = VSTACK(into: hStack)
//        column2.backgroundColor = .red.withAlphaComponent(0.1)
        
            ADD_SPACER(to: column2, height: 75)
            let sliders = self.addItem("HOW THE SLIDERS WORK", to: column2,
                icon: nil, iconMargin: nil,
                action: #selector(self.onHowWorksButtonTap(_:)))
            self.labels.append(sliders)
            
            ADD_SPACER(to: column2, height: 10)
            let faq = self.addItem("ABOUT", to: column2,
                icon: nil, iconMargin: nil,
                action: #selector(self.onFAQButtonTap(_:)))
            self.labels.append(faq)
            
            ADD_SPACER(to: column2, height: 10)
            let feedback = self.addItem("Feedback", to: column2,
                icon: nil, iconMargin: nil,
                action: #selector(self.onFeedbackButtonTap(_:)))
            self.labels.append(feedback)
            
            ADD_SPACER(to: column2, height: 10)
            let privacy = self.addItem("Privacy Policy", to: column2,
                icon: nil, iconMargin: nil,
                action: #selector(self.onPrivacyPolicyButtonTap(_:)))
            self.labels.append(privacy)
        
            ADD_SPACER(to: column2)
        
        self.contentView.addSubview(self.line)
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            self.line.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            self.line.heightAnchor.constraint(equalToConstant: 1.0),
            self.line.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 8)
        ])
        
        self.copyrightLabel.text = "© 2023 Improve The News Foundation, all Rights Reserved"
        self.copyrightLabel.numberOfLines = 2
        self.copyrightLabel.font = ROBOTO(12)
        self.contentView.addSubview(self.copyrightLabel)
        self.copyrightLabel.activateConstraints([
            self.copyrightLabel.topAnchor.constraint(equalTo: self.line.bottomAnchor, constant: 10),
            self.copyrightLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.copyrightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
        ])
        
        self.podcastLabel.text = "Verity Podcast"
        self.podcastLabel.font = ROBOTO(12)
        self.contentView.addSubview(self.podcastLabel)
        self.podcastLabel.activateConstraints([
            self.podcastLabel.topAnchor.constraint(equalTo: self.copyrightLabel.bottomAnchor, constant: 10),
            self.podcastLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18)
        ])
        
        self.podcastStack = HSTACK(into: self.contentView, spacing: 8)
        self.podcastStack.activateConstraints([
            self.podcastStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.podcastStack.topAnchor.constraint(equalTo: self.podcastLabel.bottomAnchor, constant: 16),
        ])
        
        for i in 1...4 {
            let img = UIImage(named: DisplayMode.imageName("podcast_\(i)"))?.withRenderingMode(.alwaysOriginal)
        
            let podcastButton = UIButton(type: .system)
            podcastButton.backgroundColor = .clear //.black
            podcastButton.setImage(img, for: .normal)
            self.podcastStack.addArrangedSubview(podcastButton)
            podcastButton.activateConstraints([
                podcastButton.widthAnchor.constraint(equalToConstant: 48),
                podcastButton.heightAnchor.constraint(equalToConstant: 48)
            ])
            podcastButton.tag = 20 + i
            podcastButton.addTarget(self, action: #selector(onPodcastButtonTap(_:)), for: .touchUpInside)
        }
        
        
        
        // -----
        self.bottomView.backgroundColor = .green
        self.contentView.addSubview(self.bottomView)
        self.bottomView.activateConstraints([
            self.bottomView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.bottomView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.bottomView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 34),
            self.bottomView.heightAnchor.constraint(equalToConstant: 34)
        ])
        self.contentView.sendSubviewToBack(self.bottomView)
        
        self.refreshDisplayMode()
    }
    
    static func getHeight() -> CGFloat {
        return 330 + 100
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xE8E9EA)
        self.bottomView.backgroundColor = self.contentView.backgroundColor
        self.subTitle.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1E242F)
        self.followLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1E242F)
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xC3C9CF)
        self.copyrightLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1E242F)
        self.podcastLabel.textColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0x1E242F)
        
        for L in self.labels {
            L.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1E242F)
        }
    }

}

extension iPadFooterCell {

    // MARK: - UI Utils
    func addItem(_ text: String, to: UIStackView,
        icon: String? = nil, iconMargin: CGFloat? = 0, action: Selector) -> UILabel {
        
    // label
        let label = UILabel()
        label.text = text.uppercased()
        label.font = ROBOTO_BOLD(12)
        to.addArrangedSubview(label)
        
    // icon
        if let _icon = icon {
            var _iconMargin: CGFloat = 0
            if(iconMargin != nil){ _iconMargin = iconMargin! }
        
            let iconImageView = UIImageView(image: UIImage(named: _icon))
            to.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: _iconMargin),
                iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 23),
                iconImageView.heightAnchor.constraint(equalToConstant: 23)
            ])
        }

    // button area
        let buttonArea = UIButton(type: .system)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        to.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5),
            buttonArea.topAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            buttonArea.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
        buttonArea.addTarget(self, action: action, for: .touchUpInside)
        
        return label
    }

    // MARK: - Event(s)
    @objc func onShareButtonTap(_ sender: UIButton) {
        if let _vc = self.viewController {
            SHARE_URL("http://www.improvethenews.org", from: _vc)
        }
    }
    
    @objc func onPodcastButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 20
        
        var url: String?
        switch(tag) {
            case 1:
                url = "https://podcasts.apple.com/us/podcast/improve-the-news/id1618971104?ign-itscg=30200&ign-itsct=podcast_box_player"
            case 2:
                url = "https://open.spotify.com/show/6f0N5HoyXABPBM8vS0iI8H"
            case 3:
                url = "https://music.amazon.com/podcasts/f5de9928-7979-4710-ab1a-13dc22007e70/improve-the-news"
            case 4:
                url = "https://www.youtube.com/playlist?list=PLDJZZqlKlvx4wm6206Vgq3s1dFPIP78p8"
  
            default:
                url = nil
        }
        
        
        if let _url = url {
            OPEN_URL(_url)
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
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
        
        DELAY(0.5) {
            let vc = PreferencesViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
            DELAY(0.3) {
                vc.scrollToSliders()
            }
        }
    }
    
    @objc func onFeedbackButtonTap(_ sender: UIButton) {
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
        DELAY(0.5) {
            let vc = FeedbackFormViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onPrivacyPolicyButtonTap(_ sender: UIButton) {
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
        DELAY(0.5) {
            let vc = PrivacyPolicyViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onFAQButtonTap(_ sender: UIButton) {
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
        DELAY(0.5) {
            let vc = FAQViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
}
