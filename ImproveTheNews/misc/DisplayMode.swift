//
//  DisplayMode.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation

enum DisplayMode {
    case dark
    case bright
    
    static func current() -> DisplayMode {
        if let _mode = READ(LocalKeys.preferences.displayMode) {
            let mode = Int(_mode)!
            if(mode==0) { return .dark }
            else { return .bright }
        } else {
            return .dark // default value
        }
    }
    
    static func imageName(_ name: String) -> String {
        let mode = DisplayMode.current()
        var suffix = "dark"
        if(mode == .bright){ suffix = "bright" }
    
        return name + "." + suffix
    }
    
}

func DARK_MODE() -> Bool {
    return (DisplayMode.current() == .dark)
}

func BRIGHT_MODE() -> Bool {
    return (DisplayMode.current() == .bright)
}
