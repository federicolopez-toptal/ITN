//
//  MainFeedArticle.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/09/2022.
//

import Foundation

struct MainFeedArticle {
    
    var source: String
    var time: String
    var title: String
    var url: String
    var imgUrl: String
                        //    var ampCode: String   // Url to use to embed article
                        //    var ampUrl: String
    var LR: Int
    var PE: Int
    var country: String
    var markups: [Markup]
    
    var isStory: Bool
    var storySources: [String]
    
    var used: Bool = false
    var videoFile: String?
    var isContext: Bool = false
    
    var summaryText: String = ""
    
    
    init (_ json: [Any]) {
        self.source = json[0] as! String
        self.time = json[1] as! String // "2 minutes ago"
        self.title = json[2] as! String
        self.url = FIX_URL(json[3] as! String)
        self.imgUrl = FIX_URL(json[4] as! String)
        
        self.LR = 1
        if let _LR = json[8] as? NSNumber {
            self.LR = _LR.intValue
        }
        
        self.PE = 1
        if let _PE = json[9] as? NSNumber {
            self.PE = _PE.intValue
        }
        
        self.country = json[10] as! String
                        //        self.ampCode = json[5] as! String
                        //        self.ampUrl = json[6] as! String
        
        self.markups = [Markup]()
        let _markupArray = json[7] as! [Any]
        for M in _markupArray {
            let newMarkup = Markup(M as! [Any])
            self.markups.append(newMarkup)
        }
        
        self.isStory = false
        self.storySources = [String]()
                
        if(json.count >= 13) {
            self.isStory = true
            if let _sources = json[12] as? [Any] {
                for S in _sources {
                    if(S is String) {
                        self.storySources.append(S as! String)
                    }
                }
            }
        }

        self.summaryText = ""
        if(json.count>=14) {
            if(json[13] is String) {
                self.summaryText = json[13] as! String
            }
        }

        if(json.count>=15) {
            if let _newText = json[14] as? String {
                if(self.summaryText == "") {
                    self.summaryText = _newText
                } else {
                    if( self.storySources.contains(self.summaryText) ) {
                        self.summaryText = _newText
                    }
                }
            }
        }





//        print(json.count)
//        if(json.count>=14) { // && self.summaryText == "") {
//            if(json[13] is String) {
//                self.summaryText = json[13] as! String
//            }
//        }
        
//        if(json.count>=15  && self.summaryText == "") {
//            if(json[14] is String) {
//                self.summaryText = json[14] as! String
//            }
//        }
//        if(json.count>=15) {
//            if let _newText = json[14] as? String {
//                if(self.summaryText == "") {
//                    self.summaryText = _newText
//                } else {
//                    if( self.storySources.contains(self.summaryText) ) {
//                        self.summaryText = _newText
//                    }
//                }
//            }
//        }
        
        self.used = false
    }
    
    init(jsonFromFigure jsonObj: [String: Any]) {
        self.source = ""
        self.title = CHECK(jsonObj["title"])
        self.url = ITN_URL() + CHECK(jsonObj["url"])
        self.imgUrl = CHECK(jsonObj["image"])
        self.LR = 1
        self.PE = 1
        self.country = ""
        self.markups = [Markup]()
        self.isStory = true
        self.used = false
        self.time = CHECK(jsonObj["time"])
        
        self.storySources = [String]()
        if let _mediaList = jsonObj["mediaList"] as? [String] {
            self.storySources = _mediaList
        }
    }
    
    init(url: String) {
        self.source = ""
        self.time = ""
        self.title = ""
        self.url = url
        self.imgUrl = ""
        self.LR = 1
        self.PE = 1
        self.country = ""
        self.markups = [Markup]()
        self.isStory = false
        self.storySources = [String]()
        self.used = false
    }
    
    init(story: MainFeedStory) {
        self.time = story.time
        self.title = story.title
        self.imgUrl = story.image_src
        self.videoFile = story.video
        
        self.source = ""
        self.url = ""
        self.LR = 1
        self.PE = 1
        self.country = ""
        self.markups = [Markup]()
        self.isStory = false
        self.storySources = [String]()
        self.used = false
        self.isContext = true
    }
    
    static let EMPTY_ARTICLE_TITLE = "*** EMPTY ARTICLE ***"
    static func createEmpty(defaultValue: Int) -> MainFeedArticle {
        var art = MainFeedArticle(url: "")
        art.title = MainFeedArticle.EMPTY_ARTICLE_TITLE
        art.LR = defaultValue
        art.PE = defaultValue
        
        return art
    }
    
    func isEmpty() -> Bool {
        if(self.title == MainFeedArticle.EMPTY_ARTICLE_TITLE) {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Custom init(s)
extension MainFeedArticle {
    
    init(article A: ArticleSearchResult) {
        self.source = A.mediaName
        self.time = A.timeAgo
        self.title = A.title
        self.url = A.url
        self.imgUrl = A.imgUrl
        self.LR = A.LR
        self.PE = A.PE
        self.country = A.country
        
        self.markups = [Markup]()
        self.isStory = false
        self.storySources = [String]()
        self.used = false
        
        if(A.media_id == -1) {
            self.country = "LINK"
        }
    }
    
    init(story A: StorySearchResult) {
        self.title = A.title
        self.imgUrl = A.image_url
        self.time = A.timeago
        self.storySources = A.medianames.components(separatedBy: ",")
        self.storySources.removeDuplicates()
        self.url = ITN_URL() + "/" + A.slug
        
        self.markups = [Markup]()
        self.isStory = true
        self.used = false
        self.videoFile = A.videoFile
        
        // ------ en duro (por ahora)
        self.country = "USA"
        self.source = "ITN"
        self.LR = 1
        self.PE = 2
    }
    
    init(story A: StoryArticle) {
        self.title = A.title
        self.imgUrl = A.image
        self.time = A.timeRelative
        self.storySources = []
        self.url = A.url
        
        self.markups = [Markup]()
        self.isStory = false
        self.used = false
        self.videoFile = nil
        
        self.country = A.media_country_code
        self.source = CLEAN_SOURCE(from: A.media_title)
        self.LR = A.LR
        self.PE = A.PE
    }
    
}

struct Markup {
    var title: String
    var url: String
    var type: String
    
    init(_ json: [Any]) {
        self.title = json[0] as! String
        self.url = json[2] as! String
        self.type = json[1] as! String
    }
}

