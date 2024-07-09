//
//  SharePopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/07/2024.
//

import UIKit

class SharePopupView: PopupView {

    let titleLabel = UILabel()
    let subTextLabel = UILabel()
    
    private var url: String = ""
    private var shareText: String = ""

    // MARK: - Init(s)
    init(text: String, height: CGFloat, url: String, shareText: String) {
        super.init(frame: CGRect.zero)
        
        self.url = url
        self.shareText = shareText
        
        self.height = height
        if let _bottom = SAFE_AREA()?.bottom, (_bottom == 0) {
            self.height -= 34
        }
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        self.backgroundColor = .systemPink
        
        var W: CGFloat = SCREEN_SIZE().width
        if(IPAD()) {
            W = 550
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        navControllerView.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: W),
            self.centerXAnchor.constraint(equalTo: navControllerView.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("popup.close")))
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let closeIconButton = UIButton(type: .system)
        closeIconButton.backgroundColor = .clear
        self.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        // ------------------
        self.titleLabel.font = DM_SERIF_DISPLAY(21)
        self.titleLabel.text = "Share"
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        self.subTextLabel.font = AILERON(16)
        self.subTextLabel.numberOfLines = 0
        self.subTextLabel.text = text
        self.subTextLabel.textColor = self.titleLabel.textColor
        self.addSubview(self.subTextLabel)
        self.subTextLabel.activateConstraints([
            self.subTextLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            self.subTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.subTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        // ------------------
        var offsetX: CGFloat = 0
        for i in 1...4 {
            let iconImageView = UIImageView(image: UIImage(named: "social_\(i)"))
            //iconImageView.backgroundColor = .black
            self.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.topAnchor.constraint(equalTo: self.subTextLabel.bottomAnchor, constant: 16),
                iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16+offsetX),
                iconImageView.widthAnchor.constraint(equalToConstant: 36),
                iconImageView.heightAnchor.constraint(equalToConstant: 36)
            ])
            offsetX += 36 + 12
            
            let button = UIButton(type: .custom)
            button.tag = i
            button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            self.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
                button.topAnchor.constraint(equalTo: iconImageView.topAnchor),
                button.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(socialButtonOnTap(_:)), for: .touchUpInside)
        }
        
        // ------------------
        self.refreshDisplayMode()
        closeIconButton.superview?.bringSubviewToFront(closeIconButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    @objc func socialButtonOnTap(_ sender: UIButton?) {
        let tag = sender!.tag
        
        switch(tag) {
            case 1: // Facebook
                SHARE_ON_FACEBOOK(url: self.url, text: self.shareText)
            
            case 2: // Twitter/X
                SHARE_ON_TWITTER(url: self.url, text: self.shareText)
            
            case 3: // LinkedIn
                SHARE_ON_LINKEDIN(url: self.url, text: self.shareText)
            
            case 4: // Reddit
                SHARE_ON_REDDIT(url: self.url, text: self.shareText)
            
            default:
                NOTHING()
        }
        
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.subTextLabel.textColor = self.titleLabel.textColor
    }

}
