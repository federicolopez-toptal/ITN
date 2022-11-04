//
//  UIViewExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/09/2022.
//

import Foundation
import UIKit

extension UIView {
 
    func hide() {
        self.isHidden = true
    }

    func show() {
        self.isHidden = false
    }
    
    func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

}
