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
    let shareLabel = UILabel()
    let line = UIView()
    let copyrightLabel = UILabel()
    let followLabel = UILabel()
    
    
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
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.logoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.logoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 28),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 163),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        self.subTitle.text = "A non-profit news aggregator helping you break out of your filter bubble"
        self.subTitle.numberOfLines = 2
        self.subTitle.font = ROBOTO(14)
        self.contentView.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.subTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.subTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -55),
            self.subTitle.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 18)
        ])
        
        self.shareLabel.text = "SHARE"
        self.shareLabel.font = ROBOTO_BOLD(12)
        self.contentView.addSubview(self.shareLabel)
        self.shareLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.shareLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.shareLabel.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 18)
        ])
        
        let shareIcon = UIImageView(image: UIImage(named: "footerShareIcon"))
        self.contentView.addSubview(shareIcon)
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareIcon.leadingAnchor.constraint(equalTo: self.shareLabel.trailingAnchor, constant: 8),
            shareIcon.centerYAnchor.constraint(equalTo: self.shareLabel.centerYAnchor),
            shareIcon.widthAnchor.constraint(equalToConstant: 23),
            shareIcon.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        let shareButton = UIButton(type: .system)
        shareButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.contentView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: self.shareLabel.leadingAnchor, constant: -5),
            shareButton.topAnchor.constraint(equalTo: shareIcon.topAnchor, constant: -5),
            shareButton.trailingAnchor.constraint(equalTo: shareIcon.trailingAnchor, constant: 5),
            shareButton.bottomAnchor.constraint(equalTo: shareIcon.bottomAnchor, constant: 5)
        ])
        shareButton.addTarget(self, action: #selector(onShareButtonTap(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(self.line)
        self.line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.line.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.line.heightAnchor.constraint(equalToConstant: 1.0),
            self.line.topAnchor.constraint(equalTo: self.shareLabel.bottomAnchor, constant: 20)
        ])
        
        self.copyrightLabel.text = "© 2022 Improve The News Foundation, all Rights Reserved"
        self.copyrightLabel.numberOfLines = 2
        self.copyrightLabel.font = ROBOTO(12)
        self.contentView.addSubview(self.copyrightLabel)
        self.copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.copyrightLabel.topAnchor.constraint(equalTo: self.line.bottomAnchor, constant: 18),
            self.copyrightLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            self.copyrightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
        ])
        
        let socialStack = HSTACK(into: self.contentView, spacing: 8)
        socialStack.backgroundColor = .clear //.yellow
        socialStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
            socialButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                socialButton.widthAnchor.constraint(equalToConstant: 30),
                socialButton.heightAnchor.constraint(equalToConstant: 30)
            ])
            socialButton.tag = 10 + i
            socialButton.addTarget(self, action: #selector(onSocialButtonTap(_:)), for: .touchUpInside)
        }
        ADD_SPACER(to: socialStack)
    }
    
    func populate(with header: DP_footer) {
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202E) : UIColor(hex: 0xE8E9EA)
        self.logoImageView.image = UIImage(named: DisplayMode.imageName("navBar.logo"))
        self.subTitle.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        self.shareLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x212E43) : UIColor(hex: 0xC3C9CF)
        self.copyrightLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.followLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
//        let H: CGFloat = 25 + MoreCell.buttonHeight + 25
        return CGSize(width: width, height: 300)
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
    
}
