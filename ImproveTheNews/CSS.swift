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
    var banner_bgColor: UIColor = .black
    
    var menuItem_color: UIColor = .black
    var topicSelector_textColor: UIColor = .black
    var line_color: UIColor = .black
    var header_textColor: UIColor = .black
    var moreButton_bgColor: UIColor = .black
    
    var panel_bgColor: UIColor = .black
    var tour_bgColor: UIColor = .black
    
    var imageView_bgColor: UIColor = .black
    var imageView_iconColor: UIColor = .black
    var loading_color: UIColor = .black
    
    var factLines_color: UIColor = .black
    
    var audioPlayer_bgColor: UIColor = .black
    var audioPlayer_sliderTrack_color: UIColor = .black
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
    let iPhoneStory_titleFont_small = DM_SERIF_DISPLAY(18)
    let iPhoneStory_textFont = AILERON(12)
    let iPhoneArticle_titleFont = AILERON(16)
    let iPhoneArticle_bigTitleFont = AILERON(18)
    let iPhoneArticle_textFont = AILERON(11)
    let iPhoneArticle_bigTextFont = AILERON(13)
    let iPhoneBanner_titleFont = DM_SERIF_DISPLAY(23)
    let iPhoneBanner_textFont = AILERON(16)
    let iPhoneMore_font = AILERON_SEMIBOLD(15)
    let iPhoneFooter_font = AILERON_SEMIBOLD(15)
        
    let menu_width: CGFloat = 280
    let menu_font = AILERON(15)
    let menu_versionFont = AILERON(14)
    
    let actionButton_bgColor = UIColor(hex: 0x60C4D6) //!!!
    let actionButton_textColor = UIColor(hex: 0x2D2D31) //!!!
    let actionButton_iPhone_font = AILERON_SEMIBOLD(15) //!!!
    
    let tour_backButton_font = AILERON_BOLD(16)
    let tour_textFont = AILERON(16)
    
    let iPhoneStoryContent_titleFont = DM_SERIF_DISPLAY(23)
    let iPhoneStoryContent_subTitleFont = DM_SERIF_DISPLAY(20)
    let iPhoneStoryContent_textFont = AILERON(16)
    
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
        self.darkMode.moreButton_bgColor = UIColor(hex: 0x2D2D31)
        self.darkMode.banner_bgColor = UIColor(hex: 0x2D2D31)
        self.darkMode.tour_bgColor = UIColor(hex: 0x2D2D31)
        self.darkMode.panel_bgColor = UIColor(hex: 0x2D2D31)
        self.darkMode.imageView_bgColor = UIColor(hex: 0x232326)
        self.darkMode.imageView_iconColor = UIColor(hex: 0x34343A)
        self.darkMode.loading_color = .white.withAlphaComponent(0.4)
        self.darkMode.factLines_color = UIColor(hex: 0x2D2D31)
        self.darkMode.audioPlayer_bgColor = UIColor(hex: 0x2D2D31)
        self.darkMode.audioPlayer_sliderTrack_color = UIColor(hex: 0x19191C)
        
        self.lightMode.main_bgColor = UIColor(hex: 0xF0F0F0)
        self.lightMode.main_textColor = UIColor(hex: 0x19191C)
        self.lightMode.sec_textColor = UIColor(hex: 0x19191C)
        self.lightMode.menuItem_color = UIColor(hex: 0x19191C)
        self.lightMode.topicSelector_textColor = UIColor(hex: 0x19191C)
        self.lightMode.line_color = UIColor(hex: 0x2D2D31)
        self.lightMode.header_textColor = UIColor(hex: 0x0A0A0C)
        self.lightMode.moreButton_bgColor = UIColor(hex: 0xBBBDC0)
        self.lightMode.banner_bgColor = UIColor(hex: 0xE3E3E3)
        self.lightMode.tour_bgColor = .white
        self.lightMode.panel_bgColor = .white
        self.lightMode.imageView_bgColor = UIColor(hex: 0xE3E3E3)
        self.lightMode.imageView_iconColor = UIColor(hex: 0xBBBDC0)
        self.lightMode.loading_color = .black.withAlphaComponent(0.4)
        self.lightMode.factLines_color = UIColor(hex: 0xD9D9D9)
        self.lightMode.audioPlayer_bgColor = .white
        self.lightMode.audioPlayer_sliderTrack_color = UIColor(hex: 0xE3E3E3)
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
