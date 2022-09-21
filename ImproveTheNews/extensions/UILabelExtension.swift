//
//  UILabelExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation
import UIKit

extension UILabel {
  
    func addCharacterSpacing(kernValue: Double = 1.15) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue,
            range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
    
    func reduceFontSizeIfNeededDownTo(scaleFactor: CGFloat) {
        var clampedScale = scaleFactor.clamp(lower: 0.2, upper: 1.0)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = clampedScale
    }
  
}
