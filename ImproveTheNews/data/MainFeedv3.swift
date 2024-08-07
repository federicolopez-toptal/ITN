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
    
    func loadMoreArticlesData(topic T: String, amount: Int, callback: @escaping (Error?, Int?) -> ()) {
        let S_value = self.skipForTopic(T)
        let strUrl = self.buildUrl(topic: T, A: amount, B: 0, C: 0, S: S_value)
            
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
                    let articlesAdded = self.addArticlesTo(topic: T, json: _json,
                        bannerClosed: true,
                        ignoreFirst: false)
                        
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
    }
    
    func loadArticlesData(_ topic: String, amount: Int, callback: @escaping (Error?) -> ()) {
        self.topic = topic
        let strUrl = self.buildUrl(topic: topic, A: amount, B: 1, C: 0, S: 0, defaultValues: false)
        
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        self.prevS = 0
        print("MAIN FEED from", request.url!.absoluteString)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
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
                            self.parse(_json)
                            callback(nil)
                        } else {
                            let _error = CustomError.jsonParseError
                            callback(_error)
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }

        task.resume()
    }
    
    
    func loadData(_ topic: String, defaultValues: Bool = false, callback: @escaping (Error?) -> ()) {
        self.banner = nil
        self.topic = topic
        
        var totalItems = NEWS_REQ_ITEMS_TOTAL
        var storiesCount = NEWS_REQ_STORIES_COUNT
        if(MUST_SPLIT() > 0) {
            totalItems = NEWS_REQ_SPLIT_ITEMS_TOTAL
            storiesCount = NEWS_REQ_SPLIT_STORIES_COUNT
        }
        
        let strUrl = self.buildUrl(topic: topic, A: totalItems,
                                                B: totalItems,
                                                C: storiesCount,
                                                S: 0,
                                                defaultValues: defaultValues)
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        self.prevS = 0
        print("MAIN FEED from", request.url!.absoluteString)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
//                let textFromFile = READ_LOCAL(resFile: "fakeJson_OK.txt")
//                let textFromFile = READ_LOCAL(resFile: "fakeJson_FAIL.txt")
//                let mData = ADD_MAIN_NODE(to: textFromFile.data(using: .utf8))

                let mData = ADD_MAIN_NODE(to: data)
                if let jsonString = String(data: mData, encoding: .utf8) {
                    if(jsonString.containsItemInArray(["Invalid topic requested"])) {
                        print("SERVER ERROR", "Invalid topic requested", "Oops")
                        
                        let _error = CustomError.jsonParseError
                        callback(_error)
                    } else {
                        if let _json = JSON(fromData: mData) {
                            self.parse(_json)
                            if(self.topic == "news") {
                                self.addIA()
                            }
                            if(self.topic == "ai") {
                                self.replaceFirstStoryIA()
                            }
                            
                            callback(nil)
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
    
    private func addIA() {
        let data: [Any] = [
            "ai", "ai", "AI", 0, "ai",
            0, 0, 0, []
        ]
        let iaTopic = MainFeedTopic(data, [])
        
        self.topics.insert(iaTopic, at: 1)
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
    
    private func checkFor(strings: [String]) -> Bool {
        var result = false
        
        return result
    }
    
    func loadMoreData(topic T: String, bannerClosed: Bool = false, callback: @escaping (Error?, Int?) -> ()) {
        
        var S_value = self.skipForTopic(T)
        //if(T == "news" && S_value==9) {
//        if(S_value==9) {
//            S_value += 1
//        }
        
        //if(MUST_SPLIT()==0){ S_value += 1 }
        
        var totalItems = NEWS_REQ_MORE_ITEMS_TOTAL
        var storiesCount = NEWS_REQ_MORE_STORIES_COUNT
        if(MUST_SPLIT() > 0) {
            totalItems = NEWS_REQ_SPLIT_MORE_ITEMS_TOTAL
            storiesCount = NEWS_REQ_SPLIT_MORE_STORIES_COUNT
        } else {
            if(S_value>0) {
                S_value += 1
    //            totalItems += 1
    //            storiesCount += 1
            }
        }
            
        let strUrl = self.buildUrl(topic: T, A: totalItems,
                                                B: 0,
                                                C: storiesCount,
                                                S: S_value)
            
//            let strUrl = self.buildUrl(topic: T, A: NEWS_REQ_MORE_ITEMS_TOTAL, B: 0,
//                                            C: NEWS_REQ_MORE_STORIES_COUNT, S: S_value )
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
                        var ignoreFirst = false
//                        if(S_value == 9) {
//                            ignoreFirst = true
//                        }
//                    
                        let articlesAdded = self.addArticlesTo(topic: T, json: _json, bannerClosed: bannerClosed, ignoreFirst: ignoreFirst)
                        
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
                    var newTopic = MainFeedTopic(topicInfo, articles)
                    //newTopic.splitReorderArticles_justInCase()
                    
                    self.topics.append(newTopic)
                } else {
                    if(self.banner == nil) { self.banner = Banner(topicInfo) }
                }
            }
        }
    }
    
    private func addArticlesTo(topic T: String, json: [String: Any], bannerClosed: Bool = false, ignoreFirst: Bool) -> Int {
        
        var count = 0
        var articlesAdded = 0
        let mainNode = json["data"] as! [Any]
        
        if(bannerClosed){ self.banner = nil }
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
                        if let _title = (A as! [Any])[2] as? String {
                            let found = self.topics[topicIndex].articles.first { $0.title == _title }
                            
                            if(found == nil) { // not found
//                                let newArticle = MainFeedArticle(A as! [Any])
//                                self.topics[topicIndex].articles.append(newArticle)
//                                articlesAdded += 1
                            } else {
                                print("Found repeated!", _title)
                            }
                        }

                        count += 1
                        var add = true
                        if(ignoreFirst && count==1) {
                            add = false
                        }
                        
                        if(add) {
                            let newArticle = MainFeedArticle(A as! [Any])
                            self.topics[topicIndex].articles.append(newArticle)
                            articlesAdded += 1
                        }

//                        let newArticle = MainFeedArticle(A as! [Any])
//                        if(!self.articleIsRepeated(newArticle, into: topicIndex)) {
//                            self.topics[topicIndex].articles.append(newArticle)
//                            articlesAdded += 1
//                        }
                        
                    }
                    
                    print("-----------------------------")
                    self.topics[topicIndex].splitReorderArticles_justInCase()

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
        
//        if(self.topic == "news") {
//            result.insert("IA", at: 1)
//        }
        
        return result
    }
    
    func topicNamesss() -> [String] {
        var result = [String]()
        for T in self.topics {
            result.append(T.name)
        }
        
        return result
    }
    
    func fixTopicsForNewSliders() {
        if(self.topics.count>0) {
            if(self.topics.first!.name == "news") {
                self.topics[0].capitalizedName = "All"
            }
        }
    }
    
       
}


// MARK: - Counting (Stories/Articles per Topic)
extension MainFeedv3 {
    
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
    
    private func skipForTopic(_ topic: String) -> Int {
        // Called from: here/loadMoreData (to know how much articles needs to be skipped)
        var skip = 0
        if let _value = self.topicsCount[topic] {
            skip = _value
        }
        
        return skip
    }
}


// MARK: - Utilities
extension MainFeedv3 {

    private func buildUrl(topic: String, A: Int, B: Int, C: Int, S: Int, defaultValues: Bool = false) -> String {
        /*
            DOCUMENTATION
                https://docs.google.com/document/d/1UTdmnjjLTR5UjkQ7UmP-xGlpFN7MkEImYK1Vq3w7RwE/edit
        
            API call example:
                https://www.improvemynews.com/appserver.php/?topic=news.A4.B4.S0
                &sliders=LR99PE23NU70DE70SL70RE70SS00LA00ST01VB00VC01VA00VM00VE35oB11
                &uid=3978511592857187948&v=I1.5.0&dev=iPhone_X
        */
        
//        var _A = A
//        var _B = B
//        if(MUST_SPLIT() > 0){
//            _A = 12
//            if(B>0) { _B = _A }
//        }
        
        var result = ITN_URL() + "/appserver.php/?topic=" + topic
        result += ".A" + String(A)
        result += ".B" + String(B)
        result += ".C" + String(C)
        //if(PREFS_SHOW_STORIES() && MUST_SPLIT()==0){ result += ".C" + String(C) }
        result += ".S" + String(S)
        
        if(defaultValues) {
            result += "&sliders=" + MainFeedv3.sliderDefaultValues()
        } else {
            result += "&sliders=" + MainFeedv3.sliderValues()
        }
//        result += "&sliders=" + MainFeedv3.sliderValues()
         
        result += "&uid=" + UUID.shared.getValue()
        result += "&v=I" + Bundle.main.releaseVersionNumber!
        result += "&dev=" + UIDevice.modelName.replacingOccurrences(of: " ", with: "_")
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
    
    static func sliderDefaultValues() -> String {
        // Sliders panel values (6 in total)
        var result = "LR50PE50NU70DE70SL70RE70"
        
        // Split + Sliders panel state
        result += "SS00"
        
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
//        result += "oB" //oB11"
//        if let _onboarding = READ(LocalKeys.preferences.onBoardingState) {
//            result += _onboarding
//        } else {
//            result += "10" // default value: Hidden + Step 0
//        }
        
        // Banner(s)
        if let _allBannerCodesString = READ(LocalKeys.misc.allBannerCodes) {
            let allBannerCodes = _allBannerCodesString.components(separatedBy: ",")
            
            for bCode in allBannerCodes {
                if let _bannerStatus = READ(LocalKeys.misc.bannerPrefix + bCode) {
                    result += bCode + _bannerStatus
                }
            }
        }

        //result += "yT02pC02"
        if(!result.contains("lO03")) {
            result += "lO03"
        }
        
        return result
    }
    
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

extension MainFeedv3 {

    static func parseSliderValues(_ values: String) {
        var allBanners = [String]()
        var allSources = [String]()
        let banners = ["yT", "pC", "nL", "lO"]
        
        var valueID = ""
        var valueNum = ""
        for singleChar in values {
            if(valueID.count==2) {
                valueNum += String(singleChar)
                if(valueNum.count==2) {
                    let wasSet = setSliderValue(valueID, valueNum)
                    if(banners.contains(valueID)) {
                        allBanners.append(valueID)
                    }
                    if(!wasSet) {
                        allSources.append(valueID)
                    }
                    
                    valueID = ""
                    valueNum = ""
                }
            } else {
                valueID += String(singleChar)
            }
        }
        
        let allBannersString = allBanners.joined(separator: ",")
        WRITE(LocalKeys.misc.allBannerCodes, value: allBannersString)
        
        let allSourcesString = allSources.joined(separator: ",")
        WRITE(LocalKeys.preferences.sourceFilters, value: allSourcesString)
        if let _sources = Sources.shared.all {
            for (i, S) in _sources.enumerated() {
                if(allSources.contains(S.code!)) {
                    Sources.shared.all![i].state = false
                } else {
                    Sources.shared.all![i].state = true
                }
            }
        }
        
        NOTIFY(Notification_reloadMainFeedOnShow)
    }
    
    static func setSliderValue(_ valueID: String, _ valueNum: String) -> Bool {
        let sliderCodes = ["LR", "PE", "NU", "DE", "SL", "RE"]
        let preferences = ["ST", "VD", "VB", "VC", "VA"]
        let banners = ["yT", "pC", "nL", "lO"]
        
        var result = true
        
        // Slider(s)
        if(sliderCodes.contains(valueID)) {
            WRITE("slider_" + valueID, value: valueNum)
        } else if(valueID=="SS") { // Split
            WRITE(LocalKeys.sliders.split, value: String(valueNum[0]))
            WRITE(LocalKeys.sliders.panelState, value: String(valueNum[1]))
        } else if(valueID=="LA") { // LAYOUT
            WRITE(LocalKeys.preferences.layout, value: String(valueNum[0]))
            WRITE(LocalKeys.preferences.displayMode, value: String(valueNum[1]))
        } else if(preferences.contains(valueID)) { // Preference(s)
            var key = ""
            switch(valueID) {
                case "ST":
                    key = LocalKeys.preferences.showStories
                case "VD":
                    key = LocalKeys.preferences.showSourceIcons
                case "VB":
                    key = LocalKeys.preferences.showStanceIcons
                case "VC":
                    key = LocalKeys.preferences.showStancePopups
                case "VA":
                    key = LocalKeys.preferences.showSourceFlags
                default:
                    NOTHING()
            }
            
            WRITE(key, value: valueNum)
        } else if(valueID=="oB") { // Onboarding
            WRITE(LocalKeys.preferences.onBoardingState, value: valueNum)
        } else if(banners.contains(valueID)) { // Banner(s)
            WRITE(LocalKeys.misc.bannerPrefix + valueID, value: valueNum)
        } else if(valueID=="VE") { // Version
            NOTHING()
        } else if(valueID=="VM") { // Mark up(s)
            NOTHING()
        } else { // Source filters
            result = false
        }
        
        return result
    }
    
    
    
}
