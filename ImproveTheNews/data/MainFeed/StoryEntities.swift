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
    
    var LR: Int = 1
    var PE: Int = 1
    
    var tag: Int = -1
    
    init(_ json: [String: Any]) {        
        self.id = getSTRING(json["id"], defaultValue: "1")
        self.title = getSTRING(json["title"], defaultValue: "")
        self.url = FIX_URL( getSTRING(json["url"]) )
        self.image = FIX_URL( getSTRING(json["image"]) )
        if(self.image.isEmpty){
            self.image = FIX_URL( getSTRING(json["image_url"]) )
        }
        
        self.timeRelative = getSTRING(json["timeRelative"])
        
        if let _time = json["time"] as? Int {
            self.time = _time
        }
        
        if let _mediaObj = json["media"] as? [String: Any] {
            self.media_title = getSTRING(_mediaObj["title"])
            self.media_country_code = getSTRING(_mediaObj["country_code"])
        }
        
        if let _LR = json["LR"] as? Int {
            self.LR = _LR
        }
        self.LR = self.LR.clamp(lower: 1, upper: 5)
        
        if let _PE = json["PE"] as? Int {
            self.PE = _PE
        }
        self.PE = self.PE.clamp(lower: 1, upper: 5)
        
    }
}


struct Spin {

    var title: String = ""
    var description: String = ""
    
    var timeStamp: String = ""
    var subTitle: String = ""
    var url: String = ""
    var image: String = ""
    var LR: Int = 0
    var CP: Int = 0
    var time: Int = 0
    var timeRelative: String = ""
    var media_title: String = ""
    var media_name: String = ""
    var media_label: String = ""
    var media_country_code: String = ""

    var multipleSources: [SourceForGraph] = []

    init(_ json: [String: Any]) {
        self.title = getSTRING(json["title"])
        self.description = getSTRING(json["description"])
        self.timeStamp = getSTRING(json["timestamp"])
                
        if let _spinsArray = json["spins"] as? [[String: Any]] {
            self.multipleSources = []
            for spinNode in _spinsArray {
                let newSP = SourceForGraph(json: spinNode)
                self.multipleSources.append(newSP)
            }
            
            if(_spinsArray.count>0) {
                let first = _spinsArray[0]
                
                self.subTitle = getSTRING(first["title"])
                self.url = FIX_URL( getSTRING(first["url"]) )
                self.image = FIX_URL( getSTRING(first["image"]) )
                
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
    
    var sources = [SourceForGraph]()
    
    
    // -----------------------------------
    init(_ json: [String: Any]) {
        self.title = getSTRING(json["title"])

        if let _sourceArray = json["source"] as? [[String: Any]] {
            if(_sourceArray.count>0) {
                let first = _sourceArray[0]
                self.source_title = getSTRING(first["title"])
                self.source_url = FIX_URL( getSTRING(first["url"]) )
                
                for S in _sourceArray {
                    self.sources.append( SourceForGraph(json: S) )
                }
            }
        }
    }
}

struct SourceForGraph {
    var id: String = ""
    var name: String = ""
    var LR: Int = -1
    var CP: Int = -1
    var url: String = ""
    
    init(json: [String: Any]) {

        if let _media = json["media"] as? [String: Any] {
            self.id = CHECK(_media["label"])
            self.name = CHECK(_media["name"])
            
            if(self.name.isEmpty) {
                self.name = CHECK(_media["title"])
            }
        }
        
        self.LR = CHECK_NUM(json["LR"])
        self.CP = CHECK_NUM(json["CP"])
        
        self.url = CHECK(json["url"])
    }
    
    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        
        self.LR = 1
        self.CP = 1
        self.url = url
    }
    
    func trace() {
        print("SourceForGraph -------------")
        print("id", self.id, "name", self.name)
        print("LR", self.LR, "CP", self.CP)
    }
}





