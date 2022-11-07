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
        let UUID = "user_uuid"
        let JWT = "user_jwt"
    }
    
    class LocalKeys_misc { // misc
        let allBannerCodes = "misc_allBannerCodes"
        let bannerPrefix = "banner_"
    }
    
    class LocalKeys_sliders { // For class "SlidersPanel" && "MainFeed"
        let allKeys = ["slider_LR", "slider_PE", "slider_NU", "slider_DE", "slider_SL", "slider_RE"]
        let defaultValues = [50, 50, 70, 70, 70, 70]
        let split = "sliders_split"
        let panelState = "sliders_panelState"
    }
    
    class LocalKeys_preferences {
        let displayMode = "pref_displayMode"
        let layout = "pref_layout"
        
        let showStanceIcons = "pref_showStanceIcons"
        let showStancePopups = "pref_showStancePopups"
        let showStories = "pref_showStories"
    }
    
}


