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
    var image_credit_title: String = "Not available"
    var image_credit_url: String = ""
    var time: String = ""
    
    var facts = [Fact]()
    var spins = [Spin]()
    var articles = [StoryArticle]()
    
    
    init (_ json: [String: Any]) {
    // main fields
        let mainNode = json["storyData"] as! [String: Any]
        
        self.id = getSTRING(mainNode["id"], defaultValue: "1")
        self.title = getSTRING(mainNode["title"], defaultValue: "Title not available")
        self.time = getSTRING(mainNode["time"])
        
        if let _imageObj = mainNode["image"] as? [String: Any] {
            self.image_src = getSTRING(_imageObj["src"])
            if let _imageCreditObj = _imageObj["credit"] as? [String: String] {
                self.image_credit_title = getSTRING(_imageCreditObj["title"])
                self.image_credit_title = getSTRING(_imageCreditObj["url"])
            }
        }
    
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
        for A in articlesNode {
            let newArticle = StoryArticle(A)
            self.articles.append(newArticle)
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