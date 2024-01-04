//
//  EmailNotVerifiedPopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/01/2024.
//

import Foundation
import UIKit

class EmailNotVerifiedPopupView: PopupView {

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.height = 475
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        
        navControllerView.addSubview(self)
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: navControllerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: navControllerView.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY(23)
        titleLabel.text = "Email not verified"
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        self.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27)
        ])

        let descrLabel = UILabel()
        descrLabel.numberOfLines = 0
        descrLabel.text = """
        Email not verified. Please verify your email by clicking the ‘verify email’ link in the email that was sent on the account registration.
        
        Please check your spam folder.
        
        If the verification email did not arrive, resend it using the button below.
        """
        descrLabel.font = AILERON(16)
        descrLabel.textColor = titleLabel.textColor
        descrLabel.setLineSpacing(lineSpacing: 6.0)
        self.addSubview(descrLabel)
        descrLabel.activateConstraints([
            descrLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            descrLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            descrLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 19)
        ])
        
        //---
        let goLabel = UILabel()
        goLabel.text = "Resend"
        goLabel.textAlignment = .center
        goLabel.font = AILERON_SEMIBOLD(15)
        goLabel.backgroundColor = UIColor(hex: 0x60C4D6)
        goLabel.textColor = UIColor(hex: 0x19191C)
        self.addSubview(goLabel)
        goLabel.activateConstraints([
            goLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            goLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            goLabel.heightAnchor.constraint(equalToConstant: 40),
            goLabel.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 32)
        ])
        goLabel.layer.cornerRadius = 6
        goLabel.layer.masksToBounds = true
        
        let goButton = UIButton(type: .custom)
        goButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(goButton)
        goButton.activateConstraints([
            goButton.leadingAnchor.constraint(equalTo: goLabel.leadingAnchor),
            goButton.trailingAnchor.constraint(equalTo: goLabel.trailingAnchor),
            goButton.topAnchor.constraint(equalTo: goLabel.topAnchor),
            goButton.bottomAnchor.constraint(equalTo: goLabel.bottomAnchor)
        ])
        goButton.addTarget(self, action: #selector(onGoButtonTap(_:)), for: .touchUpInside)
        
        //---
        let cancelLabel = UILabel()
        cancelLabel.text = "Close"
        cancelLabel.textAlignment = .center
        cancelLabel.font = AILERON_SEMIBOLD(15)
        cancelLabel.backgroundColor = DARK_MODE() ? .white : UIColor(hex: 0xE3E3E3)
        cancelLabel.textColor = UIColor(hex: 0x19191C)
        self.addSubview(cancelLabel)
        cancelLabel.activateConstraints([
            cancelLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            cancelLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            cancelLabel.heightAnchor.constraint(equalToConstant: 40),
            cancelLabel.topAnchor.constraint(equalTo: goLabel.bottomAnchor, constant: 24)
        ])
        cancelLabel.layer.cornerRadius = 6
        cancelLabel.layer.masksToBounds = true
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(cancelButton)
        cancelButton.activateConstraints([
            cancelButton.leadingAnchor.constraint(equalTo: cancelLabel.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: cancelLabel.trailingAnchor),
            cancelButton.topAnchor.constraint(equalTo: cancelLabel.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: cancelLabel.bottomAnchor)
        ])
        cancelButton.addTarget(self, action: #selector(onCancelButtonTap(_:)), for: .touchUpInside)
        
        self.refreshDisplayMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : .white
    }
    
    @objc func onCancelButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    @objc func onGoButtonTap(_ sender: UIButton) {
        if let vc = CustomNavController.shared.viewControllers.last as? SignInUpViewController {
            vc.signIn.resend_verificationEmail()
            self.dismissMe()
        }
    }

}
