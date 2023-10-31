//
//  DeviceUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/10/2023.
//

import Foundation
import UIKit


func IPHONE() -> Bool {
    let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    switch(idiom) {
        case .phone:
            return true
        default:
            return false
    }
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

func ORIENTATION_PORTRAIT() -> Bool {
    if(UIDevice.current.orientation.isPortrait) {
        return true
    }
    return false
}

func ORIENTATION_LANDSCAPE() -> Bool {
    if(UIDevice.current.orientation.isLandscape) {
        return true
    }
    return false
}

