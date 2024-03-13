//
//  NewsLetterStory.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/03/2024.
//

import Foundation

class NewsLetterStory {
    
    var date: String
    var title: String
    var image_url: String
    var type: Int
    
    init (_ json: [String: Any]) {
        self.date = CHECK(json["pubdate"])
        self.title = CHECK(json["newsletter_title"])
        self.image_url = CHECK(json["image_url"])
        self.type = json["type"] as! Int
    }

}

