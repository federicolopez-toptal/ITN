//
//  MainFeedStory.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import Foundation

struct MainFeedStory {
    
    var id = "1"
    var title = "Title not available"
    var image_src: String = ""
    var image_credit_title: String = ""
    var image_credit_url: String = ""
    var image_description: String = ""
    var time: String = ""
    var created: String = ""
    var splitType: String = ""
    
    var facts = [Fact]()
    var spins = [Spin]()
    var articles = [StoryArticle]()
    var goDeeper = [StorySearchResult]()
    var controversies = [ControversyListItem]()
    var figures = [PublicFigureListItem]()
    
    var audio: AudioFile?
    var video: String = ""
    
    init (_ json: [String: Any]) {
    // main fields
        var mainNode: [String: Any] = [:]
        if let _mainNode = json["storyData"] as? [String: Any] {
            mainNode = _mainNode
        } else {
            return
        }
        //let mainNode = json["storyData"] as! [String: Any]
        
        self.id = getSTRING(mainNode["id"], defaultValue: "1")
        self.title = getSTRING(mainNode["title"], defaultValue: "Title not available")
        self.time = getSTRING(mainNode["time"])
        
        if let _imageObj = mainNode["image"] as? [String: Any] {
            self.image_src = FIX_URL( getSTRING(_imageObj["src"]) )
            self.image_description = getSTRING(_imageObj["desc"])
            if let _imageCreditObj = _imageObj["credit"] as? [String: String] {
                self.image_credit_title = getSTRING(_imageCreditObj["title"])
                self.image_credit_url = getSTRING(_imageCreditObj["url"])
            }
        }
    
        // Public Figures
        self.figures = [PublicFigureListItem]()
        if let _figures = mainNode["figures"] as? [[String: Any]] {
            for F in _figures {
                let figureObject = PublicFigureListItem(jsonObj: F)
                self.figures.append(figureObject)
            }
        }
    
    
    // Audio
//        let aUrl = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/ITNPod07JUN2023_8176.mp3"
//        let aTitle = "Iran Reportedly Presents its First Hypersonic Ballistic Missile"
//        self.audio = AudioFile(file: aUrl, duration: 194, created: "Jun 06 23", title: aTitle)
    
        let _file = getSTRING(mainNode["audiofile"])
        let _duration = getSTRING(mainNode["duration"])
        let _created = getSTRING(mainNode["created"])
        let _title = getSTRING(mainNode["title"], defaultValue: "Title not available")
    
        self.created = _created
    
        if(!_file.isEmpty && !_duration.isEmpty && !_created.isEmpty && !_title.isEmpty) {
            self.audio = AudioFile(file: _file, duration: Int(_duration)!, created: _created, title: _title)
        }
        
        self.video = getSTRING(mainNode["videofile"])
        

    // Facts
        let factsNode = removeNULL(from: json["facts"])
        self.facts = [Fact]()
        for F in factsNode {
            let newFact = Fact(F)
            if(!newFact.source_title.isEmpty && !newFact.source_url.isEmpty) { // Only facts with a source
                self.facts.append(newFact)
            }
        }
        
    // Spins
        let spinsNode = removeNULL(from: json["spinSection"])
        self.spins = [Spin]()
        for S in spinsNode {
            let newSpin = Spin(S)
            self.spins.append(newSpin)
        }
        
    // Articles
        let articlesNode = removeNULL(from: json["articles"])
        self.articles = [StoryArticle]()
        for (i, A) in articlesNode.enumerated() {
            var newArticle = StoryArticle(A)
            newArticle.tag = i
            self.articles.append(newArticle)
        }
        
    // SplitType
        if let _type = json["splitType"] as? String {
            self.splitType = _type
        }

    // Go deeper
        let goDeeperNode = removeNULL(from: json["goDeeper"])
        let contextsNode = removeNULL(from: json["storyContexts"])
        self.goDeeper = [StorySearchResult]()
        
        for (_, A) in goDeeperNode.enumerated() {
            var newStory = StorySearchResult(A)
            
            for B in contextsNode {
                let titleB = B["title"] as! String
                
                if(titleB == newStory.title) {
                    let logos = B["logos"] as! [[String: Any]]
                    
                    var logosStr = [String]()
                    for LOGO in logos {
                        logosStr.append(LOGO["medianame"] as! String)
                    }
                    
                    newStory.medianames = logosStr.joined(separator: ",")
                }
            }
            
            self.goDeeper.append(newStory)
        }
        
        // Controversies/Claims
        let controversiesNode = removeNULL(from: json["claims"])
        self.controversies = [ControversyListItem]()
        for C in controversiesNode {
            let newClaim = ControversyListItem(jsonObj: C)
            self.controversies.append(newClaim)
        }
    
    }
        

}

// MARK: - Utils
func removeNULL(from node: Any?) -> [[String: Any]] {
    let array = node as! [Any?]
    var filteredArray = [Any?]()
    
    for obj in array {
        if let _ = obj as? [String: Any] {
            filteredArray.append(obj)
        }
    }
    
    return filteredArray as! [[String: Any]]
}

func getSTRING(_ fieldValue: Any?, defaultValue: String = "") -> String {
    if let _value = fieldValue as? String {
        return _value
    } else {
        return defaultValue
    }
}
