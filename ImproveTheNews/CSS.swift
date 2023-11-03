//
//  CSS.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/10/2023.
//

import Foundation
import UIKit


// -----------------
class CSS_displayMode {
    var main_bgColor: UIColor = .black
    var main_textColor: UIColor = .black
    var sec_textColor: UIColor = .black
    
    var menuItem_color: UIColor = .black
    var topicSelector_textColor: UIColor = .black
    var line_color: UIColor = .black
    var header_textColor: UIColor = .black
}

// -----------------
class CSS {
    static let shared = CSS()
    
    let darkMode = CSS_displayMode()
    let lightMode = CSS_displayMode()

    // MARK: Customizables --------------------
    let navBar_height: CGFloat = 101
    let navBar_icon_size: CGFloat = 32
    let navBar_icon_posY: CGFloat = 52
    let navBar_icon_sepX: CGFloat = 10
    let iPhoneTitleBar_font = DM_SERIF_DISPLAY(24)
    
    let topicSelector_height: CGFloat = 56
    let topicSelector_font = AILERON_SEMIBOLD(14)
    
    let iPhoneHeader_vMargins: CGFloat = 20
    let iPhoneHeader_font = DM_SERIF_DISPLAY(24)
        
    let iPhoneStory_titleFont = DM_SERIF_DISPLAY(23)
    let iPhoneStory_textFont = AILERON(12)
    let iPhoneArticle_titleFont = AILERON(16)
    let iPhoneArticle_textFont = AILERON(11)
    let iPhoneFooter_font = AILERON_SEMIBOLD(15)
        
    let menu_width: CGFloat = 280
    let menu_font = AILERON(15)
    let menu_versionFont = AILERON(14)
    
    // ----------
    let iPhoneSide_padding: CGFloat = 16
    let dashedLine_width: CGFloat = 5
    let orange = UIColor(hex: 0xDA4933)
    
    
    
    init() {
        self.darkMode.main_bgColor = UIColor(hex: 0x19191C)
        self.darkMode.main_textColor = .white
        self.darkMode.sec_textColor = UIColor(hex: 0xBBBDC0)
        self.darkMode.menuItem_color = UIColor(hex: 0xBBBDC0)
        self.darkMode.topicSelector_textColor = UIColor(hex: 0xBBBDC0)
        self.darkMode.line_color = UIColor(hex: 0x4C4E50)
        self.darkMode.header_textColor = UIColor(hex: 0xBBBDC0)
        
        self.lightMode.main_bgColor = .white
        self.lightMode.main_textColor = UIColor(hex: 0x19191C)
        self.lightMode.sec_textColor = UIColor(hex: 0x19191C)
        self.lightMode.menuItem_color = UIColor(hex: 0x19191C)
        self.lightMode.topicSelector_textColor = UIColor(hex: 0x19191C)
        self.lightMode.line_color = UIColor(hex: 0x2D2D31)
        self.lightMode.header_textColor = UIColor(hex: 0x0A0A0C)
    }
}

extension CSS {
    // MARK: misc
    func displayMode() -> CSS_displayMode {
        if(DARK_MODE()) {
            return self.darkMode
        } else {
            return self.lightMode
        }
    }
}
