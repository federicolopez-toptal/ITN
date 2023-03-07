//
//  MainFeedv3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/12/2022.
//

import Foundation
import UIKit


// Main Feed for the new navigation
class MainFeedv3 {

    var topic = "news"
    var topics = [MainFeedTopic]()
    var banner: Banner? = nil
    var topicsCount = [String: Int]()   // For all counting (articles/stories) related
    
    var prevS: Int = 0
    var titles = [String]()
    
    
    func loadData(_ topic: String, callback: @escaping (Error?) -> ()) {
        self.banner = nil
        self.topic = topic
        
        let strUrl = self.buildUrl(topic: topic, A: 11, B: 11, S: 0)
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        self.prevS = 0
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
    
    func loadMoreData(topic T: String, callback: @escaping (Error?, Int?) -> ()) {
        var S_value = self.skipForTopic(T)
        
        //if(T != self.topic){ S_value += 1 }
        
//        if(S_value-self.prevS <= 2) {
//            callback(nil, 0)
//        } else {
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
                    callback(_error, nil)
                } else {
                    let mData = ADD_MAIN_NODE(to: data)
                    if let _json = JSON(fromData: mData) {
                        let articlesAdded = self.addArticlesTo(topic: T, json: _json)
                        
                        /*
                        print("articlesAdded:", articlesAdded)
                        
                        let diff = S_value - self.prevS
                        print("DIFF", diff)
                        if(diff <= 1) {
                            callback(nil, 0)
                        } else {
                            self.prevS = S_value
                            callback(nil, articlesAdded)
                        }
                        */
                        
                        if(articlesAdded < 5) {
                            callback(nil, 0)
                        } else {
                            self.prevS = S_value
                            callback(nil, articlesAdded)
                        }
                    } else {
                        let _error = CustomError.jsonParseError
                        callback(_error, nil)
                    }
                }
            }
            
            task.resume()
//        }
    }

}


// MARK: - Data related
extension MainFeedv3 {
    
    private func parse(_ json: [String: Any]) {
        
        let mainNode = json["data"] as! [Any]
        self.topics = [MainFeedTopic]()
        self.titles = [String]()
        
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
                    if(self.banner == nil) { self.banner = Banner(topicInfo) }
                }
            }
        }
    }
    
    private func addArticlesTo(topic T: String, json: [String: Any]) -> Int {
        
        var articlesAdded = 0
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
                        // non-repeated articles
//                        if let _title = (A as! [Any])[2] as? String {
//                            let found = self.topics[topicIndex].articles.first { $0.title == _title }
//                            print("Found", found)
//
//                            if(found == nil) { // not found
//                                let newArticle = MainFeedArticle(A as! [Any])
//                                self.topics[topicIndex].articles.append(newArticle)
//                                articlesAdded += 1
//                            }
//                        }

                        let newArticle = MainFeedArticle(A as! [Any])
                        self.topics[topicIndex].articles.append(newArticle)
                        articlesAdded += 1
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
        
        return articlesAdded
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
extension MainFeedv3 {
    
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
extension MainFeedv3 {

    private func buildUrl(topic: String, A: Int, B: Int, S: Int) -> String {
        /*
            DOCUMENTATION
                https://docs.google.com/document/d/1UTdmnjjLTR5UjkQ7UmP-xGlpFN7MkEImYK1Vq3w7RwE/edit
        
            API call example:
                https://www.improvemynews.com/appserver.php/?topic=news.A4.B4.S0
                &sliders=LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11
                &uid=3978511592857187948&v=I1.5.0&dev=iPhone_X
        */
        
        var _A = A
        var _B = B
        if(MUST_SPLIT()>0){
            _A = 12
            if(B>0) {
                _B = 12
            }
        }
        
        var result = API_BASE_URL() + "/appserver.php/?topic=" + topic
        result += ".A" + String(_A)
        result += ".B" + String(_B)
        result += ".S" + String(S)
        result += "&sliders=" + MainFeedv3.sliderValues()  //self.sliderValues()
        result += "&uid=" + UUID.shared.getValue()
        result += "&v=I" + Bundle.main.releaseVersionNumber!
        result += "&dev=" + UIDevice.current.modelName.replacingOccurrences(of: " ", with: "_")
        result += "&rnd=" + self.randomString()
        
        return result
    }
    
    // ----------------------------------------------
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
    
    static func sliderValues() -> String {
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
//        if(MUST_SPLIT()>0) {
//            result += "00"
//        } else {
//            if let _showStories = READ(LocalKeys.preferences.showStories) {
//                result += _showStories
//            } else {
//                result += "01" // default value: True
//            }
//        }
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


        result += "VM00VE35" //oB11"
        
        // Onboarding
        result += "oB"
        if let _onboarding = READ(LocalKeys.preferences.onBoardingState) {
            result += _onboarding
        } else {
            result += "10" // default value: Hidden + Step 0
        }
        
        // Banner(s)
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            let allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            for bCode in allBannerCodes {
                if let _bannerStatus = READ(LocalKeys.misc.bannerPrefix + bCode) {
                    result += bCode + _bannerStatus
                }
            }
        }
        result += "nL03"
        
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
