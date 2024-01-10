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
        if(DisplayMode.menuCurrent() == 1) {
            if(DARK_MODE_iOS()){ return .dark }
            else{ return .bright }
        } else {
            if let _mode = READ(LocalKeys.preferences.displayMode) {
                let mode = Int(_mode)!
                if(mode==0) { return .dark }
                else { return .bright }
            } else {
                return .dark // default value
            }
        }
    }
    
    static func menuCurrent() -> Int {
        var result = 2 // Default: DARK
            
        if let _value = READ(LocalKeys.preferences.menuDisplayMode) {
            result = Int(_value)!
        } else {
            var dMode: DisplayMode = .dark
        
            if let _mode = READ(LocalKeys.preferences.displayMode) {
                let mode = Int(_mode)!
                if(mode==0) { dMode = .dark }
                else { dMode = .bright }
            } else {
                dMode = .dark // default value
            }

            if(dMode == .bright) {
                result = 2
            } else {
                result = 3
            }

            WRITE(LocalKeys.preferences.menuDisplayMode, value: result)
        }
        
        return result
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
