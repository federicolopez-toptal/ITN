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
    
    init(type: Int) {
        if(type==1) { // Daily
            self.date = "2024-02-21"
            self.title = "Deepfake regulation letter, Alabama embryo ruling and global cybergang disrupted"
            self.image_url = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/65d63d37cf01c_image.png"
            self.type = 1
        } else {
            self.date = "2024-03-10"
            self.title = "$460B funding package, Sweden NATO ascension and Biden State-of-the-Union"
            self.image_url = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/65ec6aef2415b_image.png"
            self.type = 2
        }
    }

}

