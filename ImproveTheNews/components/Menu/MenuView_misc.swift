//
//  MenuView_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import Foundation
import UIKit


enum MenuItem {
    case headlines
    case theme
        case themeDefault
        case themeLight
        case themeDark
    case tour
    case newsletter
    case preferences
    case profile
    
    case layout
    case more
    case logout
    case sliders
    case about
    case feedback
    case privacy
    case spacer
    case contactUs
    
    case publicFigures
    case controversies
    
    case newsletters2
    case podcast
    case videos
    
    case elections
}

// ------------
extension MenuView {
    
    func getText(forItem item: MenuItem) -> String {
        var result = ""
        
        switch(item) {
            case .theme:
//                result = "Light mode"
//                if(BRIGHT_MODE()){ result = "Dark mode" }
                result = "Theme"
                
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
                result = "more..."

            case .sliders:
                result = "How the\nsliders work"
                
            case .about:
                result = "About"
                
            case .feedback:
                result = "Feedback"
                
            case .privacy:
                result = "Privacy policy"
                
            case .profile:
                result = "My Account"
                
            case .logout:
                result = "Logout"
                
            case .themeDefault:
                result = "OS Default"
                
            case .themeLight:
                result = "Light"
                
            case .themeDark:
                result = "Dark"
                
            case .newsletter:
                result = "Newsletter Archive"
                
            case .publicFigures:
                result = "Public Figures"
                
            case .controversies:
                result = "Controversies"
                
            case .contactUs:
                result = "Contact Us"
        
            case .newsletters2:
                result = "Newsletters"
         
            case .podcast:
                result = "Listen"
         
            case .videos:
                result = "Videos"
         
            case .elections:
                result = "US Election Portal"
         
            default:
                result = ""
        }
        
        return result//.capitalized
    }
    
    func getIcon(forItem item: MenuItem) -> UIImage? {
        var icon = "menu.headlines"
        
        switch(item) {
            case .theme:
                icon = "theme"
//                icon = "gotoLight"
//                if(BRIGHT_MODE()){ icon = "gotoDark" }
                
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
                icon = ""
                //icon = "more2"
            
            case .sliders:
                icon = "sliders"
            
            case .about:
                icon = "about2"
                
            case .feedback:
                icon = "feedback"
            
            case .privacy:
                icon = "policy"
            
            case .profile:
                icon = "profile"
            
            case .publicFigures:
                icon = "profile.circle"
            
            case .logout:
                icon = "logout"
            
            case .themeDefault:
                icon = "theme"
                
            case .themeLight:
                icon = "light"
                
            case .themeDark:
                icon = "dark"
            
            case .newsletter:
                icon = "newsletter"
            
            case .controversies:
                icon = "feedback"
            
            case .contactUs:
                //icon = "faq"
                icon = "contact"
            
            case .newsletters2:
                icon = "newsletter2"
         
            case .podcast:
                icon = "podcast"
         
            case .videos:
                icon = "videos"
            
            case .elections:
                icon = "bandera"
            
            default:
                return nil
        }
        
        return UIImage(named: "menu." + icon)?.withRenderingMode(.alwaysTemplate)
    }
    
    
    
    func tapOnItem(_ item: MenuItem) {
        switch(item) {
            case .theme:
                //self.changeDisplayMode()
                self.changeThemeState()
                
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
                
            case .sliders, .about, .feedback, .privacy, .newsletter, .contactUs:
                self.showContent(item)
                
            case .profile:
                self.showProfile()
                
            case .logout:
                self.askForLogout()
                
            case .themeLight:
                self.changeDisplayMode(to: .bright)
            
            case .themeDark:
                self.changeDisplayMode(to: .dark)
            
            case .themeDefault:
                self.setOSTheme()
            
            case .publicFigures:
                self.showPublicFigures()
            
            case .controversies:
                self.showControversies()
            
            case .elections:
                self.showElections()
            
            case .videos:
                self.showVideos()
            
            case .podcast:
                self.showPodcast()
            
            default:
                NOTHING()
        }
    }
    
}
