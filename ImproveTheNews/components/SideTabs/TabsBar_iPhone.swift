//
//  TabsBar_iPhone.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/06/2024.
//

import Foundation
import UIKit


class TabsBar_iPhone: TabsBar {
    
    static let HEIGHT: CGFloat = 80
    
    override func buildInto(_ containerView: UIView) {
        self.backgroundColor = .systemPink //.withAlphaComponent(0.25)
//        self.backgroundColor = CSS.shared.displayMode().main_bgColor

        containerView.addSubview(self)
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: IPHONE_bottomOffset() * -1)
        ])
    }
    
}

// ----------------------------------------------------------
//func SCREEN_SIZE_iPadSideTab() -> CGSize {
//    var result = UIScreen.main.bounds.size
//    if(IPAD()){ result.width -= TabsBar_iPad.WIDTH }
//    
//    return result
//}

func IPHONE_bottomOffset(multiplier: CGFloat = -1) -> CGFloat {
//    return -80
    
    var offset: CGFloat = 0
    if(IPHONE()) {
        offset = TabsBar_iPhone.HEIGHT
//        if let _bottom = SAFE_AREA()?.bottom {
//            offset += _bottom
//        }
        offset *= multiplier
    }
    return offset
}
