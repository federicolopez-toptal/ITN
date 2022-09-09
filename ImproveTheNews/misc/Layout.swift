//
//  Layout.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import Foundation

enum Layout {
    case denseIntense
    case textOnly
    case bigBeautiful
    
    static func current() -> Layout {
        if let _layout = READ(LocalKeys.preferences.layout) {
            let layout = Int(_layout)!
            
            if(layout == 0){ return .denseIntense }
            else if(layout == 1){ return .textOnly }
            else { return .bigBeautiful }
        } else {
            return .denseIntense // default value
        }
    }
}
