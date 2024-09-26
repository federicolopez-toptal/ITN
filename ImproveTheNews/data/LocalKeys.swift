//
//  LocalKeys.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/09/2022.
//

import Foundation

class LocalKeys { // Keys to store local values
    
    static var user = LocalKeys_user()
    static var misc = LocalKeys_misc()
    static var sliders = LocalKeys_sliders()
    static var preferences = LocalKeys_preferences()
    
    
    class LocalKeys_user { // For class "UUID"
        static let version = "3.10"
        
        var UUID: String {
            return "user_uuid_" + LocalKeys_user.version
        }
        var JWT: String {
            return "user_jwt_" + LocalKeys_user.version
        }
        var  AUTHENTICATED: String {
            return "user_authenticated_" + LocalKeys_user.version
        }
        
    }
    
    class LocalKeys_misc { // misc
        let allBannerCodes = "misc_allBannerCodes"
        let bannerPrefix = "banner_"
        let bannerDontShowAgain = "bannerDontShowAgain"
    }
    
    class LocalKeys_sliders { // For class "SlidersPanel" && "MainFeed"
        let allKeys = ["slider_LR", "slider_PE", "slider_NU", "slider_DE", "slider_SL", "slider_RE"]
        let defaultValues = [50, 50, 70, 70, 70, 70]
        let split = "sliders_split"
        let panelState = "sliders_panelState"
    }
    
    class LocalKeys_preferences {
        let menuDisplayMode = "pref_menuDisplayMode"
    
        let displayMode = "pref_displayMode"
        let layout = "pref_layout"
        let sourceFilters = "pref_sourceFilters_3"
        
        let onBoardingShow = "pref_onBoardingShow"
        let onBoardingState = "pref_onBoardingState"
        
        let showSourceFlags = "pref_showSourceFlags"
        let showSourceIcons = "pref_showSourceIcons"
        let showStanceIcons = "pref_showStanceIcons"
        let showStancePopups = "pref_showStancePopups"
        let showStories = "pref_showStories"
        let showTips = "pref_showTips_v3"
    }
    
}


