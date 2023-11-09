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
