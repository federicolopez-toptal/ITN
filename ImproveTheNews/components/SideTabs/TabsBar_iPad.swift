//
//  TabsBar_iPad.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/06/2024.
//

import Foundation
import UIKit


class TabsBar_iPad: TabsBar {
    
    static let WIDTH: CGFloat = 92
    
    override func buildInto(_ containerView: UIView) {
//        self.backgroundColor = .systemPink //.withAlphaComponent(0.25)
        self.backgroundColor = CSS.shared.displayMode().main_bgColor

        containerView.addSubview(self)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            self.widthAnchor.constraint(equalToConstant: TabsBar_iPad.WIDTH)
        ])
    }
    
}
