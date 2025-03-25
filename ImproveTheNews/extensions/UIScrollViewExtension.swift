//
//  UIScrollViewExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/07/2024.
//

import UIKit


extension UIScrollView {

    func scrollToZero(animated A: Bool = true) {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: A)
    }

}
