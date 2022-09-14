//
//  UIUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/09/2022.
//

import Foundation
import UIKit


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

func HSTACK(into: UIStackView) -> UIStackView {
    let result = UIStackView()
    result.axis = .horizontal
    into.addArrangedSubview(result)
    
    return result
}

func VSTACK(into: UIStackView) -> UIStackView {
    let result = UIStackView()
    result.axis = .vertical
    into.addArrangedSubview(result)
    
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
