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
    
}

struct TopicPath {

    var name: String
    var capitalizedName: String
    
    init(_ json: [Any]) {
        self.name = json[0] as! String
        self.capitalizedName = json[1] as! String
    }
}
