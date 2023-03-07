//
//  MainFeedTopic.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/09/2022.
//

import Foundation


struct MainFeedTopic {
    
    var name: String
    var nonCapitalizedName: String
    var capitalizedName: String
    var subtopicsCount: Int
    var sliderCode: String
//    var baselinePopularity: Float
//    var chosenLocalPopularity: Float
//    var globalPopularity: Float
    var hierarchy: [TopicPath]
    var articles: [MainFeedArticle]
    
    
    init (_ json: [Any], _ articles: [Any]) {
        self.name = json[0] as! String
        self.nonCapitalizedName = json[1] as! String
        self.capitalizedName = json[2] as! String
        self.subtopicsCount = json[3] as! Int
        self.sliderCode = json[4] as! String
//        self.baselinePopularity = (json[5] as! NSNumber).floatValue
//        self.chosenLocalPopularity = (json[6] as! NSNumber).floatValue
//        self.globalPopularity = (json[7] as! NSNumber).floatValue
        
        self.hierarchy = [TopicPath]()
        let _path = json[8] as! [Any]
        for P in _path {
            let newTopicPath = TopicPath(P as! [Any])
            self.hierarchy.append(newTopicPath)
        }
        
        self.articles = [MainFeedArticle]()
        for A in articles {
            let newArticle = MainFeedArticle(A as! [Any])
            self.articles.append(newArticle)
        }
    }
    
    func hasAvailableArticles() -> Bool {
        var result = false
        if let _ = self.articles.first(where: { $0.used == false }) {
            result = true
        }
        
        return result
    }
    
    func stillHasStories() -> Bool {
        var result = false
        if let _ = self.articles.first(where: { $0.used == false && $0.isStory == true }) {
            result = true
        }
        
        return result
    }
    
    func singleArticlesAvailable() -> Int {
        var count = 0
        self.articles.forEach {
            if($0.used==false && $0.isStory==false) {
                count += 1
            }
        }
        
        return count
    }
    
    mutating func nextAvailableArticle(isStory storyFlag: Bool) -> MainFeedArticle? {
        var result: MainFeedArticle? = nil
        
        for (i, A) in self.articles.enumerated() {
            if(A.used==false && A.isStory==storyFlag) {
                self.articles[i].used = true
                result = A
                break
            }
        }
        
        if(result==nil) { // ignore "storyFlag"
            for (i, A) in self.articles.enumerated() {
                if(A.used==false) {
                    self.articles[i].used = true
                    result = A
                    break
                }
            }
        }
        
        return result
    }
    
    // ----------------
    mutating func has_2_articles() -> Bool {
        var result = false
        var count = 0
        var index = -1
        for (i, A) in self.articles.enumerated() {
            if(A.used == false && A.isStory==false) {
                index = i
                count += 1
                if(count==2) {
                    result = true
                    break
                }
            }
        }
        
        if(count==1 && index > -1) {
            self.articles[index].used = true
        }
        
        return result
    }
    
}

struct TopicPath {

    var name: String
    var capitalizedName: String
    
    init(_ json: [Any]) {
        self.name = json[0] as! String
        self.capitalizedName = json[1] as! String
    }
}
