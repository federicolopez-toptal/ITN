//
//  Utils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation
import UIKit


func WRITE(_ key: String, value: Any) {
//    print(">> WRITING", key, value)
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func READ(_ key: String) -> String? {
    if let _value = UserDefaults.standard.string(forKey: key) {
//        print("READING", key, _value)
        return _value
    } else {
//        print("READING", key, "nil")
        return nil
    }
}

func API_BASE_URL() -> String {
//    let dict = Bundle.main.infoDictionary!
//    return dict["API_BASE_URL"] as! String
//    return "https://www.improvemynews.com"
    return "https://www.improvethenews.org"
}

func DELAY(_ time: TimeInterval, callback: @escaping () ->() ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
        callback()
    })
}

func NOTHING() {
    // 🦗🦗🦗 ...
}

func OPEN_URL(_ url: String) {
    if let _url = URL(string: url) {
        UIApplication.shared.open(_url)
    }
}

func SHARE_URL(_ url: String, from vc: UIViewController) {
    let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    
    if(IPAD()) {
        ac.popoverPresentationController?.sourceView = vc.view
        ac.popoverPresentationController?.sourceRect = CGRect(x: SCREEN_SIZE().width/2,
            y: SCREEN_SIZE().height/2, width: 0, height: 0)
        ac.popoverPresentationController?.permittedArrowDirections = []
    }
    
    vc.present(ac, animated: true)
}

func MAIN_THREAD(_ closure: @escaping () -> () ) {
    DispatchQueue.main.async {
        closure()
    }
}

func VALIDATE_EMAIL(_ email:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func IPAD() -> Bool {
    let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    switch(idiom) {
        case .pad:
            return true
        default:
            return false
    }
}

func IPHONE() -> Bool {
    let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    switch(idiom) {
        case .phone:
            return true
        default:
            return false
    }
}

func CLEAN_SOURCE(from input: String) -> String {
    var result = input
    if let _cleanSource = input.components(separatedBy: " #").first {
        result = _cleanSource
    }
    return result
}

// ---------------------------------------------
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
    return PREF(key: LocalKeys.preferences.showStancePopups)
}
func PREFS_SHOW_STORIES() -> Bool {
    return PREF(key: LocalKeys.preferences.showStories)
}


let LOAD_MORE_LIMIT = 15
