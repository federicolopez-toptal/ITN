//
//  DialogBubbleView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 30/07/2024.
//

import Foundation
import UIKit

class DialogBubbleView: UIView {
    
    let triangleView = UIImageView()
    var currentStep = 0
    var firstTime = true
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customHide() {
        self.hide()
        self.triangleView.hide()
    }
    
    func customShow() {
        self.show()
        self.triangleView.show()
    }
    
    //MARK: To override
    func buildInto(container: UIView) {
        // ...
    }
    
    func gotoStep(_ step: Int) {
        // ...
    }
    
    func rotate() {
        self.firstTime = true
        self.gotoStep(self.currentStep)
    }
}

extension DialogBubbleView {

    func getContent(_ index: Int) -> String {
        switch(index) {
            case 1:
                return "Here you'll find the stories authored by our Verity editorial team"
            case 2:
                return "Our Controversies compare the claims made by key public figures on a wide range of issues in today's media."
            case 3:
                return "The Public Figures section lets you discover more about individuals who often make the headlines."
            case 4:
                return "Our News Slider lets you filter news sources by aspects of bias. Choose a topic, and adjust the sliders to explore reporting from across the spectrum."
                
            default:
                return ""
        }
    }

}
