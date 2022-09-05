//
//  LocalKeys.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/09/2022.
//

import Foundation

class LocalKeys { // Keys to store local values
    
    class LocalKeys_user { // For class UUID
        let UUID = "user_uuid"
        let JWT = "user_jwt"
    }
    
    class LocalKeys_sliders {
        let allKeys = ["slider_LR", "slider_PE", "slider_NU", "slider_DE", "slider_SL", "slider_RE"]
        let defaultValues = [50, 50, 70, 70, 70, 70]
        let split = "sliders_split"
        let panelState = "sliders_panelState"
    }
    
    static var user = LocalKeys_user()
    static var sliders = LocalKeys_sliders()
    
}


