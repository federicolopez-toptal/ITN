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
    
    
    init (_ json: [Any]) {
        self.source = json[0] as! String
        self.time = json[1] as! String // "2 minutes ago"
        self.title = json[2] as! String
//        print(">> TITLE", self.title)
        
        self.url = json[3] as! String
        self.imgUrl = json[4] as! String
//        self.ampCode = json[5] as! String
//        self.ampUrl = json[6] as! String
        self.LR = (json[8] as! NSNumber).intValue
        self.PE = (json[9] as! NSNumber).intValue
        self.country = json[10] as! String
        
        self.markups = [Markup]()
        let _markupArray = json[7] as! [Any]
        for M in _markupArray {
            let newMarkup = Markup(M as! [Any])
            self.markups.append(newMarkup)
        }
        
        self.isStory = false
        self.storySources = [String]()
        
        if(json.count == 13) {
            self.isStory = true
            if let _sources = json[12] as? [Any] {
                for S in _sources {
                    if(S is String) {
                        self.storySources.append(S as! String)
                    }
                }
            }
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

