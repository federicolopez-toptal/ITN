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
    
    // Fixed data for dev purposes...
    init(type: Int) {
        if(type==1) { // Daily
            self.date = "2024-05-06"
            self.title = ""
            self.image_url = ""
            self.type = 1
        } else { // Weekly
            self.date = "2024-03-10"
            self.title = "Russian elections, approved Rafah offensive and Trump-Biden rematch"
            self.image_url = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/65f541d1c8c4c_image.png"
            self.type = 2
        }
    }

}

