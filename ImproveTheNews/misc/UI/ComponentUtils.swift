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

func REMOVE_ALL_CONSTRAINTS(from view: UIView) {
//    for C in view.constraints {
//        view.removeConstraint(C)
//    }
//    
    view.constraints.forEach({ view.removeConstraint($0) })
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
    MAIN_THREAD {
        view.endEditing(true)
    }
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

func VLINE(into container: UIView) -> (UIView) {
    let line = UIView()
    line.backgroundColor = CSS.shared.displayMode().line_color
    container.addSubview(line)
    line.activateConstraints([
        line.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        line.widthAnchor.constraint(equalToConstant: 1)
    ])
    
    return line
}

func ADD_HDASHES(to view: UIView) {
    REMOVE_ALL_SUBVIEWS(from: view)
    
    var valX: CGFloat = 0
    var maxDim: CGFloat = SCREEN_SIZE().width
    if(SCREEN_SIZE().height > maxDim) { maxDim = SCREEN_SIZE().height }
    
    view.backgroundColor = CSS.shared.displayMode().main_bgColor
    view.clipsToBounds = true
    
    while(valX < maxDim) {
        let dashView = UIView()
        dashView.backgroundColor = CSS.shared.displayMode().line_color
        view.addSubview(dashView)
        dashView.activateConstraints([
            dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: valX),
            dashView.widthAnchor.constraint(equalToConstant: CSS.shared.dashedLine_width),
            dashView.topAnchor.constraint(equalTo: view.topAnchor),
            dashView.heightAnchor.constraint(equalToConstant: 1)
        ])
    
        valX += (CSS.shared.dashedLine_width * 2)
    }
}

func ADD_VDASHES(to view: UIView, height: CGFloat = 300) {
    view.backgroundColor = CSS.shared.displayMode().main_bgColor
    view.clipsToBounds = true
    REMOVE_ALL_SUBVIEWS(from: view)
    
    var valY: CGFloat = 0
    
    while(valY < height) {
        let dashView = UIView()
        dashView.backgroundColor = CSS.shared.displayMode().line_color
        view.addSubview(dashView)
        
        var diff: CGFloat = 0
        let dashBottom = valY + CSS.shared.dashedLine_width
        if(dashBottom > height) {
            diff = dashBottom - height
        }
        if(diff > 0) {
            dashView.backgroundColor = CSS.shared.displayMode().main_bgColor
        }
        
        dashView.activateConstraints([
            dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dashView.widthAnchor.constraint(equalToConstant: 1),
            dashView.topAnchor.constraint(equalTo: view.topAnchor, constant: valY),
            dashView.heightAnchor.constraint(equalToConstant: CSS.shared.dashedLine_width)
        ])

        valY += (CSS.shared.dashedLine_width * 2)
    }
}
