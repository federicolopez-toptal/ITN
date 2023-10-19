//
//  UI_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/09/2022.
//

import Foundation
import UIKit


func Y_TOP_NOTCH_FIX(_ value: CGFloat) -> CGFloat {
        // Notch devices, safe area bottom = 48
        // older devices, safe are bottom = 20
        if(SAFE_AREA()!.top == 20) {
            return value - 28
        }
        return value
    }

func SAFE_AREA() -> UIEdgeInsets? {
    let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    return window?.safeAreaInsets
}

func REMOVE_ALL_SUBVIEWS(from view: UIView) {
    view.subviews.forEach({ $0.removeFromSuperview() })
}

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

func DARK_MODE() -> Bool {
    return (DisplayMode.current() == .dark)
}

func BRIGHT_MODE() -> Bool {
    return (DisplayMode.current() == .bright)
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

func SCREEN_SIZE() -> CGSize {
    let result = UIScreen.main.bounds.size
    return result
}

func TEXT_IMAGES() -> Bool {
    return (Layout.current() == .textImages)
}

func TEXT_ONLY() -> Bool {
    return (Layout.current() == .textOnly)
}

func HIDE_KEYBOARD(view: UIView) {
    view.endEditing(true)
}

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

func ORIENTATION_PORTRAIT() -> Bool {
    if(UIDevice.current.orientation.isPortrait) {
        return true
    }
    return false
}

func ORIENTATION_LANDSCAPE() -> Bool {
    if(UIDevice.current.orientation.isLandscape) {
        return true
    }
    return false
}

func ADD_BOTTOM_LINE(to view: UIView, color: UIColor = .black.withAlphaComponent(0.5)) {
    let bottomLine = UIView()
    bottomLine.backgroundColor = color
    view.addSubview(bottomLine)
    bottomLine.activateConstraints([
        bottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        bottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        bottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
    ])
}

func SERVER_ERROR_POPUP(text: String) {
    let popup = serverErrorPopupView()
    popup.populate(text: text, actionText: "TRY AGAIN?", notification: Notification_tryAgainButtonTap)
    popup.pushFromBottom()
}
