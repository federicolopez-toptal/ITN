//
//  StoryContent.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import Foundation


class StoryContent {
    
    private let storyID_url = ITN_URL() + "/api/route?slug="
    private let storyData_url = ITN_URL() + "/php/stories/index.php?path=story&id=<ID>&filters=<FILTERS>"
    
    func load(url: String, callback: @escaping (MainFeedStory?, DeepDiveContent?) ->()) {
        let slug = self.extractSlugFrom(url: url)
        self.getStoryID(slug: slug) { (storyID) in
            if let _storyID = storyID {
                self.getStoryData(storyID: _storyID) { (story, deepDive) in
                    if(story==nil){ print("ERROR: getStoryData") }
                    callback(story, deepDive)
                }
            } else {
                print("ERROR: getStoryID")
                callback(nil, nil)
            }
        }
    }
    
}

// MARK: - Utils
extension StoryContent {
    
    private func extractSlugFrom(url: String) -> String {
        if let _url = URL(string: url), let _domain = _url.host {
            let parts = url.components(separatedBy: _domain)
            if(parts.count>1) {
                return String(parts[1].dropFirst())
            }
        }
        return url
    }
    
    private func getStoryID(slug: String,
        callback: @escaping (String?) -> ()) {
        
        let url = storyID_url + slug
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(nil)
            } else {
                var strData = String(decoding: data!, as: UTF8.self)
                strData = String(strData.dropFirst())
                strData = String(strData.dropLast())
                let mData = strData.data(using: .utf8)

                if let json = JSON(fromData: mData) {
                    let path = json["path"] as! String
                    let storyID = path.replacingOccurrences(of: "/stories/", with: "")
                    callback(storyID)
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
    
    func getStoryData(storyID: String,
        callback: @escaping (MainFeedStory?, DeepDiveContent?) -> () ) {
        //callback: @escaping (StoryData?, [StoryFact]?, [StorySpin]?, [StoryArticle]?, String?) ->() ) {
        
        var url = storyData_url.replacingOccurrences(of: "<ID>", with: storyID)
        url = url.replacingOccurrences(of: "<FILTERS>", with: MainFeedv3.sliderValues())
        url += "&split=" + String(MUST_SPLIT()) + "0"
        //url += "&split=00" // + self.mustSplit()
        
        print("----")
        print("URL story", url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(nil, nil)
            } else {
                if let json = JSON(fromData: data) {
                    if let _ = json["error"] {
                        callback(nil, nil)
                    } else {
                        var deepDive: DeepDiveContent? = nil
                        let story = MainFeedStory(json) //Story content
                        
                        if let _deepDiveNode = json["deepDive"] as? [String: Any] {
                            if let _sections = _deepDiveNode["sections"] as? [[String: Any]] {
                                deepDive = DeepDiveContent(_sections)
                            }
                        }
                        
                        callback(story, deepDive)
                    }
                } else {
                    callback(nil, nil)
                }
            }
        }
        task.resume()
    }
    
}

class DeepDiveContent {
    
    var sections = [DeepDiveSection]()
    
    init(_ sections: [[String: Any]]) {
        self.sections = []
        
        for _S in sections {
            let newSection = DeepDiveSection(_S)
            self.sections.append(newSection)
        }
    }
    
    func sectionNames() -> [String] {
        var result = [String]()
        for _S in self.sections {
            result.append(_S.title)
        }
        
        return result
    }
    
}

class DeepDiveContentBasic {
    var type: String = ""
    var content: String = ""
    
    init(_ values: [String: String]) {
        self.type = CHECK(values["type"]).uppercased()
        self.content = CHECK(values["content"])
    }
}

class DeepDiveContent_IMG: DeepDiveContentBasic {
    var src: String = ""
    var link: String = ""
    var linkText: String = ""
    
    override init(_ values: [String: String]) {
        super.init(values)
        self.src = CHECK(values["src"])
        self.link = CHECK(values["link"])
        self.linkText = CHECK(values["linkText"])
    }
}

class DeepDiveSection {
    
    var title: String = ""
    var content: (String, String) = ("", "")
    var newContent: [DeepDiveContentBasic] = []
    var additionalInfo: (String, String) = ("", "")
    var sources: [String] = []
    var stories: [MainFeedArticle] = []
    
    init(_ json: [String: Any]) {
        self.title = CHECK(json["title"])
        
        if let _content = json["content"] as? [[String: String]] {
            if let _first = _content.first {
                self.content.0 = CHECK(_first["type"])
                self.content.1 = CHECK(_first["content"])
            }
            
            self.newContent = []
            for _item in _content {
                if let _type = _item["type"]?.uppercased() {
                    if(_type == "HTML") {
                        let newItem = DeepDiveContentBasic(_item)
                        self.newContent.append(newItem)
                    } else if(_type == "IMAGE") {
                        let newItem = DeepDiveContent_IMG(_item)
                        self.newContent.append(newItem)
                    }
                }
            }
        }
        
        if let _node = json["additionalInfo"] as? [String: String] {
            self.additionalInfo.0 = CHECK(_node["title"])
            self.additionalInfo.1 = CHECK(_node["description"])
        }
        
        self.sources = []
        if let _node = json["sources"] as? [String] {
            self.sources = _node
        }
        
        self.stories = []
        if let _node = json["stories"] as? [[String: Any]] {
            for ST in _node {
                let newStory = MainFeedArticle(jsonFromGoDeeper: ST)
                self.stories.append(newStory)
            }
        }
    }
    
}
