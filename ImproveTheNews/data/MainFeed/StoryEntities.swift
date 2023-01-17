//
//  StoryEntities.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/01/2023.
//

import Foundation


struct StoryArticle {

    var id: String = "1"
    var title: String = ""
    var url: String = ""
    var image: String = ""
    var timeRelative: String = ""
    var time: Int = 0
    var media_title: String = ""
    var media_country_code: String = ""
    
    init(_ json: [String: Any]) {
        self.id = getSTRING(json["id"], defaultValue: "1")
        self.title = getSTRING(json["title"], defaultValue: "")
        self.url = getSTRING(json["url"])
        self.image = getSTRING(json["image"])
        self.timeRelative = getSTRING(json["timeRelative"])
        
        if let _time = json["time"] as? Int {
            self.time = _time
        }
        
        if let _mediaObj = json["media"] as? [String: Any] {
            self.media_title = getSTRING(_mediaObj["title"])
            self.media_country_code = getSTRING(_mediaObj["country_code"])
        }
        
    }
}


struct Spin {

    var title: String = ""
    var description: String = ""
    
    var timeStamp: String = ""
    var subTitle: String = ""
    var url: String = ""
    var image: String = ""
    var LR: Int = 1
    var CP: Int = 1
    var time: Int = 0
    var timeRelative: String = ""
    var media_title: String = ""
    var media_name: String = ""
    var media_label: String = ""
    var media_country_code: String = ""

    init(_ json: [String: Any]) {
        self.title = getSTRING(json["title"])
        self.description = getSTRING(json["description"])
        self.timeStamp = getSTRING(json["timestamp"])
                
        if let _spinsArray = json["spins"] as? [[String: Any]] {
            if(_spinsArray.count>0) {
                let first = _spinsArray[0]
                
                self.subTitle = getSTRING(first["title"])
                self.url = getSTRING(first["url"])
                self.image = getSTRING(first["image"])
                
                if let _time = first["time"] as? Int {
                    self.time = _time
                }
                
                if let _LR = first["LR"] as? Int {
                    self.LR = _LR
                }
                
                if let _CP = first["CP"] as? Int {
                    self.CP = _CP
                }
                
                self.timeRelative = getSTRING(first["timeRelative"])
                if let mediaObj = first["media"] as? [String: Any] {
                    self.media_title = getSTRING(mediaObj["title"])
                    self.media_name = getSTRING(mediaObj["name"])
                    self.media_label = getSTRING(mediaObj["label"])
                    self.media_country_code = getSTRING(mediaObj["country_code"])
                }
            }
        }
    }
}




struct Fact {

    var title: String = ""           // text
    var source_title: String = ""    // source name
    var source_url: String = ""      // source url
    
    var sourceIndex: Int = -1        // Utility, to link fact with a grouped source
    
    init(_ json: [String: Any]) {
        self.title = getSTRING(json["title"])

        if let _sourceArray = json["source"] as? [[String: Any]] {
            if(_sourceArray.count>0) {
                let first = _sourceArray[0]
                
                self.source_title = getSTRING(first["title"])
                self.source_url = getSTRING(first["url"])
            }
        }
    }
}





