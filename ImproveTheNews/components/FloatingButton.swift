//
//  FloatingButton.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation
import UIKit

class FloatingButton: UIView {

    private weak var panel: SlidersPanel?
    var bottomConstraint: NSLayoutConstraint?

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView, panel: SlidersPanel) {
        self.panel = panel

        let size: CGFloat = 80
        self.backgroundColor = .clear //.yellow
        container.addSubview(self)
        self.activateConstraints([
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size)
        ])
        
        
        
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: panel.topAnchor,
            constant: -21+IPHONE_bottomOffset())
        
        self.bottomConstraint?.isActive = true
        
        let image = UIImageView(image: UIImage(named: "floatingButton"))
        self.addSubview(image)
        image.activateConstraints([
            image.heightAnchor.constraint(equalToConstant: size-16),
            image.widthAnchor.constraint(equalToConstant: size-16),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        self.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 64),
            button.widthAnchor.constraint(equalToConstant: 64),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(floatingButtonOnTap(_:)), for: .touchUpInside)
    }
    
    @objc func floatingButtonOnTap(_ sender: UIButton?) {
        self.panel?.floatingButtonOnTap()
    }

}

