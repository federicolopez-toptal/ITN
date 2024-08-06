//
//  SourceCheck.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/08/2024.
//

import UIKit

class SourceCheck: UIView {

    let dot = UIView()
    var dotLeadingConstraint: NSLayoutConstraint?
    
    var state: Bool = true

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: 74),
            self.heightAnchor.constraint(equalToConstant: 32),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        self.layer.cornerRadius = 32/2
        
        self.addSubview(self.dot)
        self.dot.activateConstraints([
            self.dot.widthAnchor.constraint(equalToConstant: 24),
            self.dot.heightAnchor.constraint(equalToConstant: 24),
            self.dot.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.dot.layer.cornerRadius = 24/2
        self.dotLeadingConstraint = self.dot.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45) // 5 to 45
        self.dotLeadingConstraint?.isActive = true
        self.dot.backgroundColor = CSS.shared.orange
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : .white
        self.updateDotColor()
    }
    
    // ----------------------------------------------------
    func setState(_ value: Bool) {
        self.state = value
        self.updateDotColor()
        
        if(value) {
            self.dotLeadingConstraint?.constant = 45
        } else {
            self.dotLeadingConstraint?.constant = 5
        }
//        UIView.animate(withDuration: 0.3) {
//            self.layoutIfNeeded()
//        }
    }
    
    func updateDotColor() {
        var color = UIColor(hex: 0xda4933)
        if(!self.state) { color = UIColor(hex: 0xbbbdc0) }
        
        self.dot.backgroundColor = color
    }

}
