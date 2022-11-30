//
//  MainFeedv2.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 29/11/2022.
//

import Foundation
import UIKit



// Main Feed for the new navigation
class MainFeedv2 {

    var topic = "news"
    
    var topics = [MainFeedTopic]()
    var banners = [Banner]()
    
    var topicsCount = [String: Int]()   // For all counting (articles/stories) related
    
    
    
    func loadData(_ topic: String, callback: @escaping (Error?) -> ()) {
        self.topic = topic
        
        let strUrl = self.buildUrl(topic: topic, A: 11, B: 11, S: 0)
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        print("MAIN FEED from", request.url!.absoluteString)
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
            }
            
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
    
    func loadMoreData(topic T: String, callback: @escaping (Error?) -> ()) {
        
        var S_value = self.skipForTopic(T)
        if(T != self.topic){ S_value += 1 }
        
        let strUrl = self.buildUrl(topic: T, A: 11, B: 0, S: S_value )
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
                
        print("LOAD MORE \(T) from", request.url!.absoluteString)
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    self.addArticlesTo(topic: T, json: _json)
                    callback(nil)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }
        
        task.resume()
    }

}


// MARK: - Data related
extension MainFeedv2 {
    
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
                    let banner = Banner(topicInfo)
                    self.banners.append(banner)
                }
            }
        }
    }
    
    private func addArticlesTo(topic T: String, json: [String: Any]) {
        
        let mainNode = json["data"] as! [Any]
        
        for obj in mainNode {
            let _obj = obj as! [Any]
            if(_obj.count>1) {
                
                // Topics
                let topicInfo = _obj[0] as! [Any]
                
                var isBanner = false
                if( (topicInfo[0] as! String) == "INFO"){ isBanner = true }
                    
                if(!isBanner) {
                    let topicIndex = self.indexForTopic(T)
                    let articles = _obj[1] as! [Any]
                    for A in articles {
                        let newArticle = MainFeedArticle(A as! [Any])
                        self.topics[topicIndex].articles.append(newArticle)
                    }

                    break
                }
            }
        }
        
        // set all articles/stories as UNUSED
        for (t, T) in self.topics.enumerated() {
            for (a, _) in T.articles.enumerated() {
                self.topics[t].articles[a].used = false
            }
        }
    }
    
    private func indexForTopic(_ topic: String) -> Int {
        var result = -1
        
        for (i, T) in self.topics.enumerated() {
            if(T.name == topic) {
                result = i
                break
            }
        }
        
        return result
    }
    
    // To populate components/TopicSelectorView
    func topicNames() -> [String] {
        var result = [String]()
        for T in self.topics {
            result.append(T.capitalizedName)
        }
        
        return result
    }
    
       
}


// MARK: - Counting (Stories/Articles per Topic)
extension MainFeedv2 {
    
    func resetCounting() {
        // Called from MainFeed_dataProvider/populateDataProvider
        self.topicsCount = [String: Int]()
    }

    func addCountTo(topic: String) {
        // Called from MainFeed_dataProvider/(addArticleToDataProvider || addStoryToDataProvider)
        var count = 0
        if let _count = self.topicsCount[topic] {
            count = _count
        }
        count += 1
        
        self.topicsCount[topic] = count
    }
    
    private func skipForTopic(_ topic: String) -> Int {
        var skip = 0
        if let _value = self.topicsCount[topic] {
            skip = _value
        }
        
        return skip
    }
}


// MARK: - Utilities
extension MainFeedv2 {

    private func buildUrl(topic: String, A: Int, B: Int, S: Int) -> String {
        /*
            DOCUMENTATION
                https://docs.google.com/document/d/1UTdmnjjLTR5UjkQ7UmP-xGlpFN7MkEImYK1Vq3w7RwE/edit
        
            API call example:
                https://www.improvemynews.com/appserver.php/?topic=news.A4.B4.S0
                &sliders=LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11
                &uid=3978511592857187948&v=I1.5.0&dev=iPhone_X
        */
        
        var result = API_BASE_URL() + "/appserver.php/?topic=" + topic
        result += ".A" + String(A)
        result += ".B" + String(B)
        result += ".S" + String(S)
        result += "&sliders=" + self.sliderValues()
        result += "&uid=" + UUID.shared.getValue()
        result += "&v=I" + Bundle.main.releaseVersionNumber!
        result += "&dev=" + UIDevice.current.modelName.replacingOccurrences(of: " ", with: "_")
        result += "&rnd=" + self.randomString()
        
        return result
    }
    
    // ----------------------------------------------
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
        
        // More Preferences: Show stories
        result += "ST"
        if let _showStories = READ(LocalKeys.preferences.showStories) {
            result += _showStories
        } else {
            result += "01" // default value: True
        }
        // More Preferences: Show stance icons
        result += "VB"
        if let _showStanceIcons = READ(LocalKeys.preferences.showStanceIcons) {
            result += _showStanceIcons
        } else {
            result += "01" // default value: True
        }
        // More Preferences: Show stance info popup
        result += "VC"
        if let _showStancePopups = READ(LocalKeys.preferences.showStancePopups) {
            result += _showStancePopups
        } else {
            result += "01" // default value: True
        }
        // More Preferences: Show newspaper flags
        result += "VA"
        if let _showFlags = READ(LocalKeys.preferences.showSourceIcons) {
            result += _showFlags
        } else {
            result += "01" // default value: True
        }

        // Source Filters
        if let _sourceFilters = READ(LocalKeys.preferences.sourceFilters) {
            if(_sourceFilters.count > 1) {
                if(_sourceFilters.getCharAt(index: 0)==",") {
                    if let filters = _sourceFilters.subString(from: 1, count: _sourceFilters.count-1) {
                        result += filters.replacingOccurrences(of: ",", with: "00") + "00"
                    }
                } else {
                    result += _sourceFilters.replacingOccurrences(of: ",", with: "00") + "00"
                }
            }
        }


        result += "VM00VE35oB11"
        
        
        // Banner(s)
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            let allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            for bCode in allBannerCodes {
                if let _bannerStatus = READ(LocalKeys.misc.bannerPrefix + bCode) {
                    result += bCode + _bannerStatus
                }
            }
        }
        
        return result
    }
    
    private func randomString() -> String {
        var result = ""
        let validCharacters = "abcdefghijklmnopqrstuvwxyz0123456789"
        for _ in 1...15 {
            let i = Int.random(in: 0...validCharacters.count-1)
            let rnd = validCharacters.getCharAt(index: i)!
            result += rnd
        }
        
        return result
    }
}
