//
//  serverErrorPopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/10/2023.
//

import UIKit

class serverErrorPopupView: PopupView {

    let msgLabel = UILabel()
    let actionLabel = UILabel()
    var notification = Notification.Name("_")

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.height = 350
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        
        self.backgroundColor = .systemPink
        navControllerView.addSubview(self)
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: navControllerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: navControllerView.trailingAnchor),
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
        
        let iconImageView = UIImageView(image: UIImage(named: DisplayMode.imageName("errorFace")))
        self.addSubview(iconImageView)
        iconImageView.activateConstraints([
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 55),
            iconImageView.widthAnchor.constraint(equalToConstant: 85),
            iconImageView.heightAnchor.constraint(equalToConstant: 85)
        ])
        
        self.msgLabel.numberOfLines = 0
        self.msgLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.msgLabel.font = DM_SERIF_DISPLAY(18)
        self.msgLabel.textAlignment = .center
        //self.msgLabel.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(self.msgLabel)
        self.msgLabel.activateConstraints([
            self.msgLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.msgLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.msgLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20)
        ])
        
        self.actionLabel.numberOfLines = 1
        self.actionLabel.textColor = UIColor(hex: 0xDA4933)
        self.actionLabel.font = AILERON_SEMIBOLD(14)
        self.actionLabel.text = "ACTION"
        self.actionLabel.textAlignment = .center
        self.addSubview(self.actionLabel)
        self.actionLabel.activateConstraints([
            self.actionLabel.topAnchor.constraint(equalTo: self.msgLabel.bottomAnchor, constant: 20),
            self.actionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        let actionButton = UIButton(type: .custom)
        //actionButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(actionButton)
        actionButton.activateConstraints([
            actionButton.leadingAnchor.constraint(equalTo: self.actionLabel.leadingAnchor, constant: -20),
            actionButton.trailingAnchor.constraint(equalTo: self.actionLabel.trailingAnchor, constant: 20),
            actionButton.topAnchor.constraint(equalTo: self.actionLabel.topAnchor, constant: -10),
            actionButton.bottomAnchor.constraint(equalTo: self.actionLabel.bottomAnchor, constant: 10)
        ])
        actionButton.addTarget(self, action: #selector(onActionButtonTap(_:)), for: .touchUpInside)
        
        // ------------------
        self.refreshDisplayMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    // ----------------
    func populate(text: String, actionText: String, notification: Notification.Name) {
        self.msgLabel.text = text
        self.actionLabel.text = actionText
        self.notification = notification
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    @objc func onActionButtonTap(_ sender: UIButton) {
        self.dismissMe()
        NOTIFY(self.notification)
    }

}
