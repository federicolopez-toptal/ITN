//
//  FontUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/10/2022.
//

import Foundation
import UIKit



func MERRIWEATHER_BOLD(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Merriweather-Bold", size: size)
    } else {
        return UIFont(name: "Merriweather-Bold", size: size)!
    }
}

func MERRIWEATHER(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Merriweather", size: size)
    } else {
        return UIFont(name: "Merriweather", size: size)!
    }
}

func ROBOTO(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Roboto-Regular", size: size)
    } else {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
}

func ROBOTO_BOLD(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Roboto-Bold", size: size)
    } else {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
}

func AILERON(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Aileron-Regular", size: size)
    } else {
        return UIFont(name: "Aileron-Regular", size: size)!
    }
}

func AILERON_SEMIBOLD(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Aileron-SemiBold", size: size)
    } else {
        return UIFont(name: "Aileron-SemiBold", size: size)!
    }
}

func AILERON_BOLD(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "Aileron-Bold", size: size)
    } else {
        return UIFont(name: "Aileron-Bold", size: size)!
    }
}

func DM_SERIF_DISPLAY(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "DMSerifDisplay-Regular", size: size)
    } else {
        return UIFont(name: "DMSerifDisplay-Regular", size: size)!
    }
}

func DM_SERIF_DISPLAY_fixed(_ size: CGFloat = 10.0, resize: Bool = true) -> UIFont {
    if(resize) {
        return customFont(name: "DMSerifDisplay-Regular", size: size+3)
    } else {
        return UIFont(name: "DMSerifDisplay-Regular", size: size+3)!
    }
}

// ------------------------------------------------------------------------
func LIMIT_FONT(_ font: UIFont, with limitFont: UIFont) -> UIFont {
    if(font.pointSize > limitFont.pointSize) {
        return limitFont
    } else {
        return font
    }
}

// ------------------------------------------------------------------------
func maxSizeFor(fontName: String) -> CGFloat {
    var result: CGFloat = 999
    
    if(fontName.lowercased().contains("merriweather")) {
    } else if(fontName == "Roboto-Regular" || fontName == "Roboto-Bold") {
        result = 20
    } else if(fontName == "Aileron-Regular" || fontName == "Aileron-SemiBold" || fontName == "Aileron-Bold") {
        result = 28
    } else if(fontName == "DMSerifDisplay-Regular") {
        result = 50
    }
    
    return result
}

func customFont(name fontName: String, size fontSize: CGFloat) -> UIFont {
    let font = UIFont(name: fontName, size: fontSize)!
    let limitSize = maxSizeFor(fontName: fontName)
    
    var scaledFont = UIFontMetrics.default.scaledFont(for: font)
    print("FONT", fontName, "size:", scaledFont.pointSize)
    if(scaledFont.pointSize > limitSize) {
        scaledFont = UIFont(name: fontName, size: limitSize)!
    }
    
    return scaledFont
}
