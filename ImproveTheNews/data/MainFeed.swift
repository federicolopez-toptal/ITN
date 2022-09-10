//
//  MainFeed.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation
import UIKit


class MainFeed {
    
    var topic = "news"
    var A_articlesPerTopic = 4
    var B_articlesPerSubtopic = 4
    var S_articlesToSkipPerTopic = 0
    
    var topics = [MainFeedTopic]()
    
    func loadData(callback: @escaping (Error?) -> ()) {
        var request = URLRequest(url: URL(string: self.buildUrl())!)
        request.httpMethod = "GET"
        
        print("MAIN FEED from", request.url!.absoluteString)
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    self.parse(_json)
                    callback(nil)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }
        
        task.resume()
    }
    
    private func buildUrl() -> String {
    
        /*
            DOCUMENTATION
                https://docs.google.com/document/d/1UTdmnjjLTR5UjkQ7UmP-xGlpFN7MkEImYK1Vq3w7RwE/edit
        
            API call example:
                https://www.improvemynews.com/appserver.php/?topic=news.A4.B4.S0
                &sliders=LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11
                &uid=3978511592857187948&v=I1.5.0&dev=iPhone_X
        */
    
        var result = API_BASE_URL() + "/appserver.php/?topic=" + self.topic
        result += ".A" + String(A_articlesPerTopic)
        result += ".B" + String(B_articlesPerSubtopic)
        result += ".S" + String(S_articlesToSkipPerTopic)
        result += "&sliders=" + self.sliderValues()
        result += "&uid=" + UUID.shared.getValue()
        result += "&v=I" + Bundle.main.releaseVersionNumber!
        result += "&dev=" + UIDevice.current.modelName.replacingOccurrences(of: " ", with: "_")
        
        return result
    }
    
    private func parse(_ json: [String: Any]) {
        
        let mainNode = json["data"] as! [Any]
        self.topics = [MainFeedTopic]()
        
        for obj in mainNode {
            let _obj = obj as! [Any]
            if(_obj.count>1) {
                // Topics
                let topicInfo = _obj[0] as! [Any]
                
                var isBanner = false
                if( (topicInfo[0] as! String) == "INFO"){ isBanner = true }
                    
                if(!isBanner) {
                    let articles = _obj[1] as! [Any]
                    let newTopic = MainFeedTopic(topicInfo, articles)
                    self.topics.append(newTopic)
                } else {
                    // Banner(s)
                }
            }
        }
        
    }
    
    func topicNames() -> [String] {
        var result = [String]()
        for T in self.topics {
            result.append(T.capitalizedName)
        }
        
        return result
    }
    
}

// MARK: - Slider value(s)
extension MainFeed {

    /*
        Example:
        >> LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11yT04
    
        Sliders panel values (00 to 99)
            LR  Left-Right
            PE  Pro-Establishment
            NU  Nuance (from writing style)
            DE  Depth (Breezy/Detailed)
            SL  Shelft-Life
            RE  Recency
            
        SS  Slider status
            1st digit
                0   No split
                1   LR split
                2   PE split
                
            2nd digit
                0   sliders panel closed
                1   sliders panel showing 2 rows
                2   sliders panel showing all 6 rows
                
        LA  Layout selection
            1st digit
                0   Dense & Intense
                1   Text only
                2   Big & Beautiful
            
            2nd digit
                0   Dark mode
                1   Bright mode
                
        MORE PREFERENCES
            ST  Show stories
                00 no
                01 yes
                
            VA Show newspaper flags
                00 yes
                01 no
                
            VB  Show newspaper stance icons
                00  yes
                01  no
                
            VC  Show newspaper info popup
                00 yes
                01 no
                
            VM  Show markups
                00  yes
                01  no
                
        VE VERSION code
            1st digit
                2   website
                3   iOS
                4   android
                
            2nd digit
                minor version number
                example: From version "1.5.0" -> 5
                
        oB  ONBOARDING status
            1st digit
                1   hidden
                2   shown
                
            2nd digit
                current step (0...6)
                10 if never cancelled
                
        BANNER(s)
            yT  YouTube banner
                01  Banner shown, no user interaction
                02  User tapped on "close"
                03  User check "Don't show again", then tap on "close"
                04  User interaction (tap on banner, opened video)
                
        Example:
        >> LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11yT04
    */

    private func sliderValues() -> String {
        var result = ""
        
        // Sliders panel values (6 in total)
        let sliderCodes = ["LR", "PE", "NU", "DE", "SL", "RE"]
        for (i, code) in sliderCodes.enumerated() {
            var value = LocalKeys.sliders.defaultValues[i]
            if let _value = READ(LocalKeys.sliders.allKeys[i]) {
                value = Int(_value)!
            }
            
            result += code + String(format: "%02d", value)
        }
        
        // Split + Sliders panel state
        result += "SS"
        if let _split = READ(LocalKeys.sliders.split) {
            result += _split
        } else {
            result += "0"   // default value: No split
        }
        if let _panelState = READ(LocalKeys.sliders.panelState) {
            result += _panelState
        } else {
            result += "0" // default value: Panel closed
        }
        
        // Layout
        result += "LA"
        if let _layout = READ(LocalKeys.preferences.layout) {
            result += _layout
        } else {
            result += "0" // default value: Dense & Intense
        }
        // Display mode
        if let _displayMode = READ(LocalKeys.preferences.displayMode) {
            result += _displayMode
        } else {
            result += "0" // default value: Dark mode
        }
        
        result += "ST01VB00VC01VA00VM00VE35oB11"
        return result
    }

}





