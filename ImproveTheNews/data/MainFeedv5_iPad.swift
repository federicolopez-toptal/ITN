//
//  MainFeedv5_iPad.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/12/2022.
//

import Foundation
import UIKit

// MARK: Definition(s)
class MainFeedv5_iPad {
    
    var topic = "news"          // Current topic
    var count_ST = 0
    var count_AR = 0
    
    /* --- */
        var topics = [MainFeedTopic]()      // All info
        var topicsCount = [String: Int]()
        var banner: Banner? = nil   // Banner (if apply)
    /* --- */
    
}
 
// MARK: Load data
extension MainFeedv5_iPad {
    
    // main LOAD DATA
    func loadData(_ topic: String, callback: @escaping (Error?) -> ()) {
        self.banner = nil
        self.topic = topic
        
        self.count_ST = 0
        self.count_AR = 0
        
        var strUrl = self.buildUrl(topic: topic, A: 6, B: 6, C: 6, SA: 0, SS: 0)
        if(topic == "ai") {
            strUrl = self.buildUrl(topic: topic, A: 4, B: 0, C: 2, SA: 0, SS: 1)
        }
        
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        print("MAIN FEED from", request.url!.absoluteString)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("Reques TIME OUT!")
                callback(error)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let jsonString = String(data: mData, encoding: .utf8) {
                    if(jsonString.containsItemInArray(["Invalid topic requested"])) {
                        print("SERVER ERROR", "Invalid topic requested", "Oops")
                        
                        let _error = CustomError.jsonParseError
                        callback(_error)
                    } else {                    
                        if let _json = JSON(fromData: mData) {
                            if let _ = _json["data"] as? [Any] {
                                ///
                                if(topic == "ai") {
                                    self.parse(_json, mainTopicItemsLimit: 4)
                                } else {
                                    self.parse(_json, mainTopicItemsLimit: 6)
                                }
                                
                                if(self.topic == "news") {
                                    self.addIA()
                                    //self.add_US_Election()
                                }
                                if(self.topic == "ai") {
                                    self.addFirstStoryIA()
                                    //self.replaceFirstStoryIA()
                                }
                                
                                callback(nil)
                                ///
                            } else {
                                let _error = CustomError.jsonParseError
                                callback(_error)
                            }
                        } else {
                            let _error = CustomError.jsonParseError
                            callback(_error)
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
                ///
            }
        }

        task.resume()
    }
    
    // load MORE data
    func loadMoreData(topic T: String, bannerClosed: Bool = false, callback: @escaping (Error?, Int?) -> ()) {
        if(topic == "ai") {
            self.count_ST += 1
            self.count_AR += 1
        }
        let strUrl = self.buildUrl(topic: T, A: 8, B: 0, C: 8, SA: self.count_AR, SS: self.count_ST)
        
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        print("LOAD MORE \(T) from", request.url!.absoluteString)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    let articlesAdded = self.addArticlesTo(topic: T, json: _json, bannerClosed: bannerClosed)
                    callback(nil, articlesAdded)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil)
                }
            }
        }
        
        task.resume()
    }
    
}

// MARK: Utils
extension MainFeedv5_iPad {
    
    private func buildUrl(topic: String, A: Int, B: Int, C: Int, SA: Int, SS: Int) -> String {

        var result = ITN_URL() + "/php/util/get-news.php?topic=" + topic
//        var result = "https://www.improvemynews.com/php/util/get-news.php?topic=" + topic
        
        result += "&A=" + String(A)     // main topic/items count
        result += "&B=" + String(B)     // subtopics/items count
        result += "&C=" + String(C)     // stories count
        result += "&SA=" + String(SA)   // articles skip
        result += "&SS=" + String(SS)   // stories skip
        result += "&slidercookies=" + MainFeedv3.sliderValues()

        return result
    }
    
}




// MARK: - Data related
extension MainFeedv5_iPad {
    
    private func parse(_ json: [String: Any], mainTopicItemsLimit: Int) {
        
        let mainNode = json["data"] as! [Any]
        self.topics = [MainFeedTopic]()
        
        for (i, obj) in mainNode.enumerated() {
            let _obj = obj as! [Any]
            if(_obj.count>1) {
                // Topics
                var topicInfo = [Any]()
                
                if let _topicInfo = _obj[0] as? NSDictionary {
                    let allKeys = (_topicInfo.allKeys as! [String]).sorted()
                    for key in allKeys {
                        topicInfo.append(_topicInfo[key]!)
                    }
                } else {
                    topicInfo = _obj[0] as! [Any]
                }

                var isBanner = false
                if( (topicInfo[0] as! String) == "INFO"){ isBanner = true }
                    
                if(!isBanner) {
                    var articles = _obj[1] as! [Any]
                    if(i==1) {
                        while(articles.count>mainTopicItemsLimit) { // api fix
                            articles.removeLast()
                        }
                    }
                    let newTopic = MainFeedTopic(topicInfo, articles)
                    
                    if(newTopic.name == self.topic) {
                        for item in newTopic.articles {
                            if(!item.isStory) {
                                self.count_AR += 1
                            } else {
                                self.count_ST += 1
                            }
                        }
                    }
                    
                    self.topics.append(newTopic)
                } else {
                    if(self.banner == nil) { self.banner = Banner(topicInfo) }
                }
            }
        }
    }
    
    private func addArticlesTo(topic T: String, json: [String: Any], bannerClosed: Bool = false, ignoreFirst: Bool = false) -> Int {
        var articlesAdded = 0
        let mainNode = json["data"] as! [Any]
        
        if(bannerClosed){ self.banner = nil }
        for obj in mainNode {
            let _obj = obj as! [Any]
            if(_obj.count>1) {
                // Topics
                var topicInfo = [Any]()
                
                if let _topicInfo = _obj[0] as? NSDictionary {
                    let allKeys = (_topicInfo.allKeys as! [String]).sorted()
                    for key in allKeys {
                        topicInfo.append(_topicInfo[key]!)
                    }
                } else {
                    topicInfo = _obj[0] as! [Any]
                }
                
                var isBanner = false
                if( (topicInfo[0] as! String) == "INFO"){ isBanner = true }
                    
                if(!isBanner) {
                    let topicIndex = self.indexForTopic(T)
                    let articles = _obj[1] as! [Any]
                    
                    for A in articles {
                        var _A = [Any]()
//                        
                        if(A is [Any]) {
                            _A = A as! [Any]
                        } else {
                            if let _topicInfo = A as? NSDictionary {
                                for i in 0...20 {
                                let key = String(i)
                                    if(_topicInfo[key] != nil) {
                                        _A.append( _topicInfo[key]! )
                                    }
                                }
                            }
                        }
                        
                        let newArticle = MainFeedArticle(_A)
//                        if(!self.articleIsRepeated(newArticle, into: topicIndex)) {
                            self.topics[topicIndex].articles.append(newArticle)
                            
                            if(!newArticle.isStory) {
                                self.count_AR += 1
                            } else {
                                self.count_ST += 1
                            }
                            articlesAdded += 1
//                        }
                        
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
    
    // misc utils
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
    
    private func articleIsRepeated(_ article: MainFeedArticle, into topicIndex: Int) -> Bool {
        var result = false
        
        let T = self.topics[topicIndex]
        let title = article.title
        
        for A in T.articles {
            if(A.title == title) {
                result = true
                break
            }
        }
    
        return result
    }
    
    func topicNames() -> [String] { // For "TopicSelectorView"
        var result = [String]()
        for T in self.topics {
            result.append(T.capitalizedName)
        }
        
        return result
    }
      
}


// MARK: - Counting (Stories/Articles per Topic)
extension MainFeedv5_iPad {
    
    func resetCounting() {
        // Called from: MainFeed.../populateDataProvider (beginning)
        self.topicsCount = [String: Int]()
    }

    func addCountTo(topic: String) {
        // Called from: MainFeed.../populateDataProvider (when a story/article is added to dataProvider)
        var count = 0
        if let _count = self.topicsCount[topic] {
            count = _count
        }
        count += 1
        
        self.topicsCount[topic] = count
    }
}


// MARK: - Utilities
extension MainFeedv5_iPad {

    
    
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
            pC  podCast banner
            yT  YouTube banner
            nL  newsLetter form
            lO  ABC banner - IGNORE!
            
                01  Banner shown, no user interaction
                02  User tapped on "close"
                03  User check "Don't show again", then tap on "close"
                04  User interaction (tap on banner, opened video)
                
        Example:
        >> LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11yT04
        >> LR50PE50NU70DE70SL70RE70SS00LA00ST01VB01VC01VA01VM00VE35oB21lO03
    */
    
    static func sliderValues() -> String { // Default values
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
//        result += "ST"
//        if let _showStories = READ(LocalKeys.preferences.showStories) {
//            result += _showStories
//        } else {
//            result += "01" // default value: True
//        }
        result += "ST01"

        // More Preferences: Show source icons
        result += "VD"
        if let _showSourceIcons = READ(LocalKeys.preferences.showSourceIcons) {
            result += _showSourceIcons
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
        if let _showFlags = READ(LocalKeys.preferences.showSourceFlags) {
            result += _showFlags
        } else {
            result += "01" // default value: True
        }
        //result += "VA00"
        
        
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


        result += "VM00VE35"
        
        // Onboarding
        result += "oB" //oB11"
        if let _onboarding = READ(LocalKeys.preferences.onBoardingState) {
            result += _onboarding
        } else {
            result += "10" // default value: Hidden + Step 0
        }
        
        // Banner(s)
//        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
//            let allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
//            
//            for bCode in allBannerCodes {
//                if let _bannerStatus = READ(LocalKeys.misc.bannerPrefix + bCode) {
//                    result += bCode + _bannerStatus
//                }
//            }
//        }
        
        result += "yT02pC02nL02"
        if(!result.contains("lO03")) {
            result += "lO03"
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

// MARK: - IA extra topic
extension MainFeedv5_iPad {

    private func addIA() {
        let data: [Any] = [
            "ai", "ai", "AI", 0, "ai",
            0, 0, 0, []
        ]
        let iaTopic = MainFeedTopic(data, [])
        
        self.topics.insert(iaTopic, at: 1)
    }
    
    private func add_US_Election() {
        let data: [Any] = [
            "us-election-2024", "us-election-2024", "US Election", 0, "us-election-2024",
            0, 0, 0, []
        ]
        let newTopic = MainFeedTopic(data, [])
        self.topics.insert(newTopic, at: 3)
    }
    
    private func addFirstStoryIA() {
        if(self.topics.first?.name == "ai") {
            var newStory = MainFeedArticle(url: "")
            newStory.title = "What is Artificial Intelligence?"
            newStory.imgUrl = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/65b7a1da0d52e_image.png"
            newStory.isContext = true
            newStory.isStory = true
            newStory.storySources = []
            newStory.time = "" //DATE_TO_TIMEAGO("2023-03-19 00:01:00")
            newStory.url = ITN_URL() + "/story/2023/artificial-intelligence"
            newStory.summaryText = "WHAT IS AI? Artificial intelligence, AI, is simply non-biological intelligence. Intelligence is often defined as the ability to accomplish goals. Early AI systems, like the one that first beat humans at chess, had skills programmed by humans, while today's best AI instead learns its own skills from large amounts of data."
            
            self.topics[0].articles.insert(newStory, at: 0)
        }
    }
    
    private func replaceFirstStoryIA() {
        if(self.topics.first?.name == "ai") {
                
            var i = -1
            for (_i, AR) in self.topics[0].articles.enumerated() {
                if(AR.isStory) {
                    i = _i
                    break
                }
            }
            if(i == -1) { return }
            
            self.topics[0].articles[i].title = "What is Artificial Intelligence?"
            self.topics[0].articles[i].imgUrl = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/65b7a1da0d52e_image.png"
            self.topics[0].articles[i].isContext = true
            self.topics[0].articles[i].isStory = true
            self.topics[0].articles[i].storySources = []
            self.topics[0].articles[i].time = "" //DATE_TO_TIMEAGO("2023-03-19 00:01:00")
            self.topics[0].articles[i].url = ITN_URL() + "/story/2023/artificial-intelligence"
        }
    }
    
}



 /*
 https://www.improvemynews.com/php/util/get-news.php?topic=news&page=2&slider=LR50PE50NU70DE70SL70RE70lO00yT00aL00mL00nL00SS10IN00ST01AP01&per_page=9&A=2&B=4&S=0&C=4&slidercookies=LR50PE50NU70DE70SL70RE70lO00yT00aL00mL00nL00SS10IN00ST01AP01
  */
