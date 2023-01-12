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
    
    
    init (_ json: [String: Any]) {
    // main fields
        let mainNode = json["storyData"] as! [String: Any]
        
        if let _id = mainNode["id"] as? Int {
            self.id = String(_id)
        }
        
        if let _title = mainNode["title"] as? String {
            self.title = _title
        }
        
        if let _time = mainNode["time"] as? String {
            self.time = _time
        }
        
        if let _imageObj = mainNode["image"] as? [String: Any] {
            self.image_src = _imageObj["src"] as! String
            if let _imageCreditObj = _imageObj["credit"] as? [String: String] {
                self.image_credit_title = _imageCreditObj["title"]!
                self.image_credit_url = _imageCreditObj["url"]!
            }
        }
    
    // Facts
        let factsNode = self.removeNullFrom(json["facts"])
        self.facts = [Fact]()
        for F in factsNode {
            let newFact = Fact(F)
            if(!newFact.source_title.isEmpty && !newFact.source_url.isEmpty) { // Only facts with sources
                self.facts.append(newFact)
            }
        }
    }
    
    
    
}

// MARK: - Utils
extension MainFeedStory {
    
    private func removeNullFrom(_ node: Any?) -> [[String: Any]] {
        let array = node as! [Any?]
        var filteredArray = [Any?]()
        
        for obj in array {
            if let _ = obj as? [String: Any] {
                filteredArray.append(obj)
            }
        }
        
        return filteredArray as! [[String: Any]]
    }
    
}
