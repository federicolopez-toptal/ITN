//
//  ComponentUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/10/2023.
//

import Foundation
import UIKit




// MARK: UIView related
func REMOVE_ALL_SUBVIEWS(from view: UIView) {
    view.subviews.forEach({ $0.removeFromSuperview() })
}

func ADD_SHADOW(to view: UIView, offset: CGSize = CGSize(width: 5, height: 5)) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.self.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = offset
    view.layer.shadowRadius = 3
    view.layer.shouldRasterize = true
    view.layer.rasterizationScale = UIScreen.main.scale
}

// MARK: misc
func HIDE_KEYBOARD(view: UIView) {
    view.endEditing(true)
}

// MARK: UIStackView related
func ADD_SPACER(to: UIStackView, backgroundColor: UIColor = .clear, width: CGFloat? = nil, height: CGFloat? = nil) {
    let spacer = UIView()
    spacer.tag = -1
    spacer.backgroundColor = backgroundColor
    to.addArrangedSubview(spacer)
    spacer.translatesAutoresizingMaskIntoConstraints = false
        
    if let _width = width {
        spacer.widthAnchor.constraint(equalToConstant: _width).isActive = true
    }
    
    if let _height = height {
        spacer.heightAnchor.constraint(equalToConstant: _height).isActive = true
    }
}

func STACK(axis: NSLayoutConstraint.Axis, into container: UIView, spacing: CGFloat = 0) -> UIStackView {
    let result = UIStackView()
    result.axis = axis
    result.spacing = spacing
    
    if let _containerStack = container as? UIStackView {
        _containerStack.addArrangedSubview(result)
    } else {
        container.addSubview(result)
    }
    
    return result
}

func HSTACK(into container: UIView, spacing: CGFloat = 0) -> UIStackView {
    let result = STACK(axis: .horizontal, into: container, spacing: spacing)
    return result
}

func VSTACK(into container: UIView, spacing: CGFloat = 0) -> UIStackView {
    let result = STACK(axis: .vertical, into: container, spacing: spacing)
    return result
}

// MARK: Alerts
func ALERT(vc: UIViewController, title: String? = nil, message: String, onCompletion: @escaping ()->() ) {
    MAIN_THREAD {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            onCompletion()
        }
        
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
}

func ALERT_YESNO(vc: UIViewController, title: String? = nil, message: String, onCompletion: @escaping (Bool)->() ) {
    MAIN_THREAD {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            onCompletion(true)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { action in
            onCompletion(false)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        vc.present(alert, animated: true)
    }
}

func FUTURE_IMPLEMENTATION(_ text: String) {
    CustomNavController.shared.infoAlert(message: "Future implementation: " + text)
}

func SERVER_ERROR_POPUP(text: String) {
    let popup = serverErrorPopupView()
    popup.populate(text: text, actionText: "TRY AGAIN?", notification: Notification_tryAgainButtonTap)
    popup.pushFromBottom()
}