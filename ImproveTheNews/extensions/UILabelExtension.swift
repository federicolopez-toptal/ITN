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
    
    func calculateHeightFor(width: CGFloat) -> CGFloat {
            self.frame = CGRect(x: 0, y: 0, width: width, height: 10)
            self.sizeToFit()
            return self.frame.size.height
    }
    
    func calculateWidthFor(height: CGFloat) -> CGFloat {
        self.frame = CGRect(x: 0, y: 0, width: 10, height: height)
        self.sizeToFit()
        return self.frame.size.width
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func addUnderline() {
        let attributedString = NSMutableAttributedString.init(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        self.attributedText = attributedString
    }
    
    func setAsImageCreditWith(prefix: String) {
        let ogText = self.text!
        let ogFont = self.font!
    
        let attributedString = NSMutableAttributedString(string: ogText, attributes: [
            .font: ogFont,
            .foregroundColor: CSS.shared.orange
        ])
        
        let orangeAttributedString = NSMutableAttributedString(string: prefix, attributes: [
            .font: ogFont,
            .foregroundColor: CSS.shared.displayMode().sec_textColor //main_textColor
        ])
        
        let range = (attributedString.string.lowercased() as NSString).range(of: prefix.lowercased())
        attributedString.replaceCharacters(in: range, with: orangeAttributedString)
                
        self.attributedText = attributedString
    }
    
    func remarkSearchTerm(_ term: String, color: UIColor) {

        if(term.isEmpty) {
            self.textColor = color
            return
        }
        
        let ogText = self.text!
        let ogFont = self.font!

        let attributedString = NSMutableAttributedString(string: ogText, attributes: [
            .font: ogFont,
            .foregroundColor: color
        ])
        
        for i in 0...ogText.count-1 {
            if(i <= ogText.count-term.count) {
                if let _subStr = ogText.subString2(from: i, count: term.count-1) {
                if(_subStr.lowercased() == term.lowercased()) {
                    let orangeAttributedString = NSMutableAttributedString(string: _subStr, attributes: [
                        .font: ogFont,
                        .foregroundColor: CSS.shared.orange
                    ])
                    
                    let range = NSRange(location: i, length: term.count)
                    attributedString.replaceCharacters(in: range, with: orangeAttributedString)
                }}
            }
        }
    
//        let range = (attributedString.string.lowercased() as NSString).range(of: term.lowercased())
//        let newTerm = ogText.subString2(from: range.location, count: range.length-1)
//
//        if let _newTerm = newTerm {
//            let orangeAttributedString = NSMutableAttributedString(string: _newTerm, attributes: [
//                .font: ogFont,
//                .foregroundColor: CSS.shared.orange
//            ])
//            
//            attributedString.replaceCharacters(in: range, with: orangeAttributedString)
//        }
        
        self.attributedText = attributedString
    }
  
}

