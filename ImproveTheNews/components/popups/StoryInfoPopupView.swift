//
//  StoryInfoPopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/05/2024.
//

import UIKit

class StoryInfoPopupView: PopupView {

    let titleLabel = UILabel()
    var descriptionLabel: HyperlinkLabel!

    // MARK: - Init(s)
    init(title: String, description: String, linkedTexts: [String], links: [String], height: CGFloat) {
        super.init(frame: CGRect.zero)
        
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
        let titleHStack = HSTACK(into: self, spacing: 7)
        titleHStack.backgroundColor = .clear //.systemPink
        titleHStack.activateConstraints([
            titleHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            titleHStack.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(21)
        self.titleLabel.text = title
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        self.descriptionLabel = HyperlinkLabel.parrafo2(text: description, linkTexts: linkedTexts,
                                                        urls: links, onTap: self.onLinkTap(_:))
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.activateConstraints([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        self.refreshDisplayMode()
        closeIconButton.superview?.bringSubviewToFront(closeIconButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    func populate(title: String, description: String, linkedTexts: [String], links: [String]) {
        self.titleLabel.text = title
        
        self.descriptionLabel = HyperlinkLabel.parrafo2(text: description, linkTexts: linkedTexts,
                                                        urls: links, onTap: self.onLinkTap(_:))
    }
    
    func onLinkTap(_ url: URL) {
        OPEN_URL(url.absoluteString)
    }

}
