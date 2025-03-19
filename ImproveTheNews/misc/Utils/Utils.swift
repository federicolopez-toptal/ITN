//
//  Utils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation
import UIKit


let LOAD_MORE_LIMIT = 12

// MARK: URLs related
func FIX_URL(_ url: String) -> String {
    return url.replacingOccurrences(of: "http://", with: "https://")
}

func YOUTUBE_GET_THUMB_IMG(id: String) -> String {
    return "https://img.youtube.com/vi/" + id + "/0.jpg"
}

func URL_SESSION(timeout: TimeInterval = 30) -> URLSession {
    let cfg = URLSessionConfiguration.default
    cfg.timeoutIntervalForRequest = timeout
    let session = URLSession(configuration: cfg)
    
    return session
}

// MARK: Some actions
func OPEN_URL(_ url: String) {
    if let _url = URL(string: url) {
        UIApplication.shared.open(_url)
    }
}

func SHARE_ON_TWITTER(text: String) { // LSApplicationQueriesSchemes must include "twitter"
//    var url = "twitter://post?message=" + text
//        
//    if(UIApplication.shared.canOpenURL(URL(string: url)!)) {
//        OPEN_URL(url)
//    } else {
//        url = "https://twitter.com/intent/post?text=" + text.urlEncodedString()
//        OPEN_URL(url)
//    }
    
    let url = "https://twitter.com/intent/post?text=" + text //.urlEncodedString()
    OPEN_URL(url)
}

func SHARE_ON_TWITTER(url: String, text: String) {
    //let url = "https://twitter.com/intent/post?text=" + text.urlEncodedString() + "%20" + url
    
    let url = "https://x.com/intent/post?url=" + url.urlEncodedString() + "&text=" + text
    OPEN_URL(url)
}

func SHARE_ON_TWITTER_2(url: String, text: String) {
    let url = "https://x.com/intent/post?url=" + url + "&text=" + text
    OPEN_URL(url)
}

func SHARE_ON_FACEBOOK(url: String, text: String) {
    let url = "https://www.facebook.com/sharer/sharer.php?u=\(url)&quote=\(text.urlEncodedString())"
    OPEN_URL(url)
}

func SHARE_ON_LINKEDIN(url: String, text: String) {
    let url = "https://www.linkedin.com/shareArticle?url=\(url)&title=\(text.urlEncodedString())"    
    OPEN_URL(url)
}

func SHARE_ON_REDDIT(url: String, text: String) {
    let url = "https://www.reddit.com/submit?url=" + url.urlEncodedString() + "&title=" + text + "&type=TEXT"
    OPEN_URL(url)
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

// MARK: misc
func DELAY(_ time: TimeInterval, callback: @escaping () ->() ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
        callback()
    })
}

func NOTHING() {
    // 🦗🦗🦗 ...
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


// MARK: String related
func CLEAN_SOURCE(from input: String) -> String {
    var result = input
    if let _cleanSource = input.components(separatedBy: " #").first {
        result = _cleanSource
    }
    return result
}

func FIX_TIME(_ time: String) -> String {
    var result = time
    
    // Example: "209 hours ago"
    let parts = time.components(separatedBy: " ")
    if let num = Int(parts[0]) {
        let type = parts[1].lowercased()

        switch(type) {
            case "hours":
                if(num>23) {
                    let days = Int(num/24)
                    result = String(days) + " day"
                    if(days>1){ result += "s" }
                    result += " ago"
                    
                    if(days>29) {
                        result = FIX_TIME(result)
                    }
                }
            case "days":
                if(num>29) {
                    let months = Int(num/30)
                    result = String(months) + " month"
                    if(months>1){ result += "s" }
                    result += " ago"
                }
        
            default:
                NOTHING()
        }
        
        if(num==1) {
            result = result.replacingOccurrences(of: "seconds", with: "second")
            result = result.replacingOccurrences(of: "minutes", with: "minute")
            result = result.replacingOccurrences(of: "hours", with: "hour")
            result = result.replacingOccurrences(of: "days", with: "day")
            result = result.replacingOccurrences(of: "weeks", with: "week")
            result = result.replacingOccurrences(of: "months", with: "month")
            result = result.replacingOccurrences(of: "years", with: "year")
        }
    } else {
        result = time
    }
    
//    print("output:", result)
//    print("-----------------------")
    
    return result
}

func SHORT_TIME(input: String) -> String {
    var result = input.uppercased().replacingOccurrences(of: " AGO", with: "")
    result = result.replacingOccurrences(of: "HOURS", with: "HRS")
    result = result.replacingOccurrences(of: "HOUR", with: "HR")
    result = result.replacingOccurrences(of: "MINUTES", with: "MINS")
    result = result.replacingOccurrences(of: "MINUTE", with: "MIN")
    result = result.replacingOccurrences(of: "SECONDS", with: "SECS")
    result = result.replacingOccurrences(of: "SECOND", with: "SEC")
    
    return result
}

func DATE_TO_TIMEAGO(_ date: String) -> String {
    var result = date
    
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if let _inputDate = formatter.date(from: date) {
        //Example: 39347427.55886698
        let secs = Date().timeIntervalSince(_inputDate) //Seconds
        let mins = secs/60
        let hours = mins/60
        let days = hours/24
        let months = days/30
        let years = months/12
        
        var type = ""
        var num = 0
        
        if(Int(years) > 0) {
            num = Int(years)
            type = "year"
        } else if(Int(months) > 0) {
            num = Int(months)
            type = "month"
        } else if(Int(days) > 0) {
            num = Int(days)
            type = "day"
        } else if(Int(hours) > 0) {
            num = Int(hours)
            type = "hour"
        } else if(Int(mins) > 0) {
            num = Int(mins)
            type = "minute"
        } else if(Int(secs) > 0) {
            num = Int(secs)
            type = "second"
        }
        
        result = String(num) + " " + type
        if(num>1){ result += "s" }
        result += " ago"
    }
    
    return result
}

func DATE_ZERO_HOUR(input: Date) -> Date {
    return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: input)!
}

// MARK: - OS theme related
func DISPLAY_MODE_iOS() -> DisplayMode {
    let style = UIViewController().traitCollection.userInterfaceStyle
    if(style == .dark) {
        return .dark
    } else {
        return .bright
    }
}

func DARK_MODE_iOS() -> Bool {
    return (DISPLAY_MODE_iOS() == .dark)
}

func LIGHT_MODE_iOS() -> Bool {
    return BRIGHT_MODE_iOS()
}

func BRIGHT_MODE_iOS() -> Bool {
    return (DISPLAY_MODE_iOS() == .bright)
}


// ---------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------
func INTERPOLATE(minA: CGFloat, maxA: CGFloat, value: CGFloat, minB: CGFloat, maxB: CGFloat) -> CGFloat {
    // "value" exists between "minA" and "maxA". Interpolate it between "minB" and "maxB"
    return minB + (maxB - minB) * (value - minA) / (maxA - minA)
}
//REFERENCE: https://stackoverflow.com/questions/42817020/how-to-interpolate-from-number-in-one-range-to-a-corresponding-value-in-another
