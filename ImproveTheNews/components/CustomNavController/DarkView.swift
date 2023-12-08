//
//  DarkView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/09/2022.
//

import UIKit

class DarkView: UIView {

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
        self.backgroundColor = .black
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        self.isUserInteractionEnabled = false
        
        self.hide()
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C).withAlphaComponent(0.4) : UIColor(hex: 0x19191C).withAlphaComponent(0.2)
        
        //self.backgroundColor = .red.withAlphaComponent(0.5)
    }

}
