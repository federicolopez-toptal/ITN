//
//  Layout.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import Foundation

enum Layout {
    case textImages
    case textOnly
    
    static func current() -> Layout {
        if let _layout = READ(LocalKeys.preferences.layout) {
            let layout = Int(_layout)!
            
            if(layout == 0){ return .textImages }
            else { return .textOnly }
        } else {
            return .textImages // default value
        }
    }
}
