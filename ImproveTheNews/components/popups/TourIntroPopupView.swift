//
//  TourIntroPopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/12/2023.
//

import Foundation
import UIKit

class TourIntroPopupView: PopupView {

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.height = 330
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        
        var W: CGFloat = SCREEN_SIZE().width
        if(IPAD()) {
            W = 550
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        navControllerView.addSubview(self)
        self.activateConstraints([
            self.centerXAnchor.constraint(equalTo: navControllerView.centerXAnchor),
            self.widthAnchor.constraint(equalToConstant: W),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        let vLogoImage = UIImage(named: "VLogo")?.withRenderingMode(.alwaysTemplate)
        let vLogo = UIImageView(image: vLogoImage)
        vLogo.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x2D2D31)
        self.addSubview(vLogo)
        vLogo.activateConstraints([
            vLogo.widthAnchor.constraint(equalToConstant: 32 * 1.25),
            vLogo.heightAnchor.constraint(equalToConstant: 38 * 1.25),
            vLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
        ])
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Verity"
        welcomeLabel.font = DM_SERIF_DISPLAY(23)
        welcomeLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x2D2D31)
        self.addSubview(welcomeLabel)
        welcomeLabel.activateConstraints([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: vLogo.bottomAnchor, constant: 24)
        ])
        
        let subTextLabel = UILabel()
        subTextLabel.numberOfLines = 0
        subTextLabel.text = "It looks like you're new here,\nwould you like a tour?"
        subTextLabel.font = AILERON(16)
        subTextLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x2D2D31)
        subTextLabel.setLineSpacing(lineSpacing: 6.0)
        subTextLabel.textAlignment = .center
        self.addSubview(subTextLabel)
        subTextLabel.activateConstraints([
            subTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subTextLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24)
        ])
        
        let buttonsContainer = UIView()
        buttonsContainer.backgroundColor = .clear //.green
        self.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.heightAnchor.constraint(equalToConstant: 40),
            buttonsContainer.widthAnchor.constraint(equalToConstant: 121 + 121 + 16),
            buttonsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: subTextLabel.bottomAnchor, constant: 30)
        ])
        
        let cancelLabel = UILabel()
        cancelLabel.text = "No thanks"
        cancelLabel.textAlignment = .center
        cancelLabel.font = AILERON_SEMIBOLD(15)
        cancelLabel.backgroundColor = DARK_MODE() ? .white : UIColor(hex: 0xE3E3E3)
        cancelLabel.textColor = UIColor(hex: 0x19191C)
        buttonsContainer.addSubview(cancelLabel)
        cancelLabel.activateConstraints([
            cancelLabel.widthAnchor.constraint(equalToConstant: 121),
            cancelLabel.heightAnchor.constraint(equalToConstant: 40),
            cancelLabel.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            cancelLabel.topAnchor.constraint(equalTo: buttonsContainer.topAnchor)
        ])
        cancelLabel.layer.cornerRadius = 6
        cancelLabel.layer.masksToBounds = true
        
        let goLabel = UILabel()
        goLabel.text = "Show me"
        goLabel.textAlignment = .center
        goLabel.font = AILERON_SEMIBOLD(15)
        goLabel.backgroundColor = UIColor(hex: 0x60C4D6)
        goLabel.textColor = UIColor(hex: 0x19191C)
        buttonsContainer.addSubview(goLabel)
        goLabel.activateConstraints([
            goLabel.widthAnchor.constraint(equalToConstant: 121),
            goLabel.heightAnchor.constraint(equalToConstant: 40),
            goLabel.leadingAnchor.constraint(equalTo: cancelLabel.trailingAnchor, constant: 16),
            goLabel.topAnchor.constraint(equalTo: buttonsContainer.topAnchor)
        ])
        goLabel.layer.cornerRadius = 6
        goLabel.layer.masksToBounds = true
        
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
        CustomNavController.shared.tour?.showStep(2)
        
        self.bottomConstraint?.constant = self.height
        UIView.animate(withDuration: 0.4) {
            self.superview!.layoutIfNeeded()
        }
    }

}