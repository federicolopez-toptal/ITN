//
//  UINavigationControllerExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation
import UIKit


extension UINavigationController {

    func customPopViewController() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }

    func customPushViewController(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
}
