//
//  UIUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/09/2022.
//

import Foundation
import UIKit


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

func DARK_MODE() -> Bool {
    return (DisplayMode.current() == .dark)
}

func BRIGHT_MODE() -> Bool {
    return (DisplayMode.current() == .bright)
}
