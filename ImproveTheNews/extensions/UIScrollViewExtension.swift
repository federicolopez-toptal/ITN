//
//  UIScrollViewExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/07/2024.
//

import UIKit


extension UIScrollView {

    func scrollToZero() {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}
