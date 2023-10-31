//
//  DataUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/02/2023.
//

import Foundation
import UIKit


// MARK: - misc
func MUST_SPLIT() -> Int {
    if let _value = READ(LocalKeys.sliders.split) {
        return Int(_value)!
    } else {
        return 0
    }
}

func USER_AUTHENTICATED() -> Bool {
    if(READ(LocalKeys.user.AUTHENTICATED)=="YES") {
        return true
    } else {
        return false
    }
}


// MARK: - Preferences
func PREF(key: String) -> Bool {
    if( READ(key) == "01" ) {
        return true
    } else {
        return false
    }
}

func PREFS_SHOW_SOURCE_ICONS() -> Bool {
    return PREF(key: LocalKeys.preferences.showSourceIcons)
}
func PREFS_SHOW_STANCE_ICONS() -> Bool {
    return PREF(key: LocalKeys.preferences.showStanceIcons)
}
func PREFS_SHOW_STANCE_POPUPS() -> Bool {
    return true
    //return PREF(key: LocalKeys.preferences.showStancePopups)
}
func PREFS_SHOW_STORIES() -> Bool {
    return PREF(key: LocalKeys.preferences.showStories)
}
func PREFS_SHOW_FLAGS() -> Bool {
    return PREF(key: LocalKeys.preferences.showSourceFlags)
}


// MARK: Basics
func WRITE(_ key: String, value: Any) {
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func READ(_ key: String) -> String? {
    if let _value = UserDefaults.standard.string(forKey: key) {
        return _value
    } else {
        return nil
    }
}
