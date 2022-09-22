//
//  NoInternetPopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/09/2022.
//

import UIKit

// https://www.figma.com/file/2trQtjl1kAFZOspiVF3RNp/Card%2C-Feed-%26-Navigation?node-id=3682%3A130779
class NoInternetPopupView: PopupView {

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.height = 350
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        
        self.backgroundColor = .systemPink
        navControllerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: navControllerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: navControllerView.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("popup.close")))
        self.addSubview(closeIcon)
        closeIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let closeIconButton = UIButton(type: .system)
        closeIconButton.backgroundColor = .clear
        self.addSubview(closeIconButton)
        closeIconButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        self.refreshDisplayMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }

}
