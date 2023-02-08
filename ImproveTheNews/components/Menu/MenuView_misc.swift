//
//  MenuView_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import Foundation
import UIKit


enum MenuITem {
    case displayMode
    case headlines
    case layout
    case preferences
    case tour
    case more
    
    case sliders
    case faq
    case feedback
    case privacy
}

// ------------
extension MenuView {
    
    func getText(forItem item: MenuITem) -> String {
        var result = ""
        
        switch(item) {
            case .displayMode:
                result = "Light mode"
                if(BRIGHT_MODE()){ result = "Dark mode" }
                
            case .headlines:
                result = "Headlines"
                
            case .layout:
                result = "Text & Images"
                if(TEXT_IMAGES()){ result = "Text-Only" }
                
            case .preferences:
                result = "Preferences"
                
            case .tour:
                result = "Tour"
                
            case .more: // ▼ ▲
                result = "More..."

            case .sliders:
                result = "How the sliders work"
                
            case .faq:
                result = "FAQ"
                
            case .feedback:
                result = "Feedback"
                
            case .privacy:
                result = "Privacy policy"
                
            default:
                result = ""
        }
        
        return result.uppercased()
    }
    
    func getIcon(forItem item: MenuITem) -> UIImage? {
        var icon = "menu.headlines"
        
        switch(item) {
            case .displayMode:
                icon = "gotoLight"
                if(BRIGHT_MODE()){ icon = "gotoDark" }
                
            case .headlines:
                icon = "headlines"
                
            case .layout:
                icon = "text-images"
                if(TEXT_IMAGES()){ icon = "text-only" }
                
            case .preferences:
                icon = "preferences"
                
            case .tour:
                icon = "tour"
            
            case .more:
                icon = "more2"
            
            case .sliders:
                icon = "sliders"
            
            case .faq:
                icon = "faq"
                
            case .feedback:
                icon = "feedback"
            
            case .privacy:
                icon = "policy"
            
//            default:
//                icon = ""
        }
        
        return UIImage(named: "menu." + icon)
    }
    
    
    
    func tapOnItem(_ item: MenuITem) {
        switch(item) {
            case .displayMode:
                self.changeDisplayMode()
                
            case .headlines:
                self.gotoHeadlines()
                
            case .layout:
                self.changeLayout()
                
            case .preferences:
                self.presentPreferences()
                
            case .tour:
                self.startTour()
                
            case .more:
                self.showMore()
                
            case .sliders, .faq, .feedback, .privacy:
                self.showContent(item)
                
            default:
                NOTHING()
        }
    }
    
}
