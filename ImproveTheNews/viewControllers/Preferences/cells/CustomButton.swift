//
//  CustomButton.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/05/2024.
//

import Foundation
import UIKit

class CustomButton: UIButton {

    let highlightView = UIView()

    func setColor(normal: UIColor) {
        self.clipsToBounds = true
        self.backgroundColor = normal
        
        self.highlightView.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(self.highlightView)
        self.highlightView.activateConstraints([
            self.highlightView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.highlightView.topAnchor.constraint(equalTo: self.topAnchor),
            self.highlightView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.highlightView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.highlightView.hide()
        
        self.addTarget(self, action: #selector(highlightButton(_:)), for: .touchDown)
    }
    
    func setEnabled(_ value: Bool) {
        self.alpha = value ? 1 : 0.5
        self.isEnabled = value
    }
    
    @objc func highlightButton(_ sender: UIButton?) {
        self.highlightView.show()
        self.highlightView.alpha = 1
        
        UIView.animate(withDuration: 0.2, delay: 0.15) {
            self.highlightView.alpha = 0
        } completion: { _ in
            self.highlightView.hide()
        }
    }

}
