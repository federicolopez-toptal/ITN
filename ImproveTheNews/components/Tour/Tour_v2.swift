//
//  Tour_v2.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 30/07/2024.
//

import Foundation
import UIKit


// iPhone
class Tour_v2 {

    let dialogView: DialogBubbleView
//    var dialogBubbleView = UIView()
//    var rectColorView = UIView()

    init() {
        if(IPHONE()) {
            self.dialogView = DialogBubbleView_iPhone()
        } else {
            self.dialogView = DialogBubbleView_iPad()
        }
        
        self.dialogView.customHide()
    }

    func buildInto(container: UIView) {
        self.dialogView.buildInto(container: container)
        //self.dialogView.customHide()
    }
    
    func gotoStep(_ step: Int) {
        self.dialogView.gotoStep(step)
        self.dialogView.customShow()
    }
    
    func start() {
        let popup = TourIntroPopupView()
        popup.pushFromBottom()
    }
    
    func rotate() {
        self.dialogView.rotate()
    }
    
    func cancel() {
        self.dialogView.customHide()
        
        UIView.animate(withDuration: 0.2) {
            CustomNavController.shared.darkView.alpha = 0.0
        } completion: { _ in
            CustomNavController.shared.darkView.hide()
        }
    }

}

// MARK: misc
extension Tour_v2 {
}
