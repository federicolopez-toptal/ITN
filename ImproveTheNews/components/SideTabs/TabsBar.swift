//
//  TabsBar.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/06/2024.
//

import Foundation
import UIKit

class TabsBar: UIView {

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func customInit() -> TabsBar {
        if(IPHONE()) {
            return TabsBar_iPhone()
        } else {
            return TabsBar_iPad()
        }
    }
    
    func buildInto(_ containerView: UIView) { // to override
    }
    
    func refreshDisplayMode() { // to override
    }
    
    func selectTab(_ index: Int, loadContent: Bool = false) { // to override
    }
    
    func currentTab() -> Int { // to override
        return -1
    }
    
    func getDim() -> CGFloat {
        var dim: CGFloat = 0
        
        if(IPHONE()) {
            dim = TabsBar_iPhone.HEIGHT
        } else {
            dim = TabsBar_iPad.HEIGHT
        }
        
        return dim
    }
    
}
