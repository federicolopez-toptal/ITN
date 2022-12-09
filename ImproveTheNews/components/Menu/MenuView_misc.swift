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
                
            default:
                result = ""
        }
        
        return result.uppercased()
    }
    
    func getIcon(forItem item: MenuITem) -> UIImage {
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
                
            default:
                icon = ""
        }
        
        return UIImage(named: "menu." + icon)!
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
                
            default:
                NOTHING()
        }
    }
    
}
