//
//  PopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/09/2022.
//

import UIKit

class PopupView: UIView {

    var height: CGFloat = 100
    var bottomConstraint: NSLayoutConstraint?

    deinit {
//        print("Popup removed") // testing
    }

    // MARK: - Show
    func pushFromBottom() {
        let darkView = CustomNavController.shared.darkView
        darkView.alpha = 0
        darkView.show()
        self.bottomConstraint?.constant = self.height
        
        UIView.animate(withDuration: 0.2) {
            darkView.alpha = 1.0
        } completion: { _ in
            darkView.isUserInteractionEnabled = true
            self.bottomConstraint?.constant = 0
            UIView.animate(withDuration: 0.4) {
                self.superview!.layoutIfNeeded()
            }
        }
        
    }

    // MARK: - Hide
    func dismissMe() {
        let darkView = CustomNavController.shared.darkView
    
        self.bottomConstraint?.constant = self.height
        UIView.animate(withDuration: 0.4) {
            self.superview!.layoutIfNeeded()
        }
    
        UIView.animate(withDuration: 0.2) {
            darkView.alpha = 0.0
        } completion: { _ in
            darkView.hide()
            DELAY(0.5) {
                self.removeFromSuperview()
            }
        }
    }

    @objc func refreshDisplayMode() {
        // To override
    }
}
 
