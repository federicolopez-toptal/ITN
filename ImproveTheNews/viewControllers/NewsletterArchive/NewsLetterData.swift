//
//  NewsLetterData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/03/2024.
//

import Foundation

class NewsLetterData {
    
    static let shared = NewsLetterData()
    
    // Load newsletter list
    func loadData(range: String, type: String, offset: Int,
        callback: @escaping (Error?, [NewsLetterStory], Int, Int) -> ()) {
        
        let url = ITN_URL() + "/php/stories/newsletters-archive.php" +
            "?range=" + range + "&type=" + type + "&offset=" + String(offset)
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("NEWSLETTER URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, [], -1, -1)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, [], -1, -1)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _ = _json["error"] {
                        if let _msg = _json["message"] as? String {
                            if(_msg.lowercased().contains("no record found")) {
                                callback(nil, [], -1, -1)
                            } else {
                                callback(CustomError.jsonParseError, [], -1, -1)
                            }
                        } else {
                            callback(CustomError.jsonParseError, [], -1, -1)
                        }
                    } else {
                        if let storiesNode = _json["stories"] as? [[String: Any]] {
                            var stories = [NewsLetterStory]()
                            for node in storiesNode {
                                let newItem = NewsLetterStory(node)
                                stories.append(newItem)
                            }
                            
                            let pages = _json["pages"] as! Int
                            let currentPage = _json["page_no"] as! Int
                            
                            callback(nil, stories, currentPage, pages)
                        } else {
                            callback(CustomError.jsonParseError, [], -1, -1)
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, [], -1, -1)
                }
            }
        }

        task.resume()
    }
    
    // load weekly newsletter
    func loadWeeklyNewsletter(_ ST: NewsLetterStory,
        callback: @escaping (Error?, WeeklyNewsletter?) -> () ) {
        
        let url = ITN_URL() + "/php/stories/weekly-newsletters.php?date=" + ST.date
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("Loading weekly NEWSLETTER", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    let data = WeeklyNewsletter(jsonObj: _json)
                    
                    callback(nil, data)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil)
                }
            }
        }

        task.resume()
    }
    
    // load daily newsletter
    func loadDailyNewsletter(_ ST: NewsLetterStory,
        callback: @escaping (Error?, DailyNewsletter?) -> () ) {
        
        let url = ITN_URL() + "/php/stories/daily-newsletters.php?date=" + ST.date
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("Loading daily NEWSLETTER", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    let data = DailyNewsletter(jsonObj: _json)
                    
                    callback(nil, data)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil)
                }
            }
        }

        task.resume()
    }
    
}


// ---------------------------------------
class otherNewsLetter {
    var date: String = ""
    var title: String = ""
    
    init(date: String, title: String) {
        self.date = date
        self.title = title
    }
}

// ---------------------------------------
class DailyNewsletter {

    var date: String = ""
    var prev: otherNewsLetter! = nil
    var next: otherNewsLetter! = nil
    var stories: [DailyStory] = []

    init(jsonObj: [String: Any]) {
        self.date = CHECK(jsonObj["newsletter-date"])
        
        if let _prevObj = jsonObj["prevnewsletter"] as? [[String: Any]], let _prev = _prevObj.first { // prev
            self.prev = otherNewsLetter(date: CHECK(_prev["pubdate"]), title: CHECK(_prev["title"]))
        }
        
        if let _nextObj = jsonObj["nextnewsletter"] as? [[String: Any]], let _next = _nextObj.first { // next
            self.next = otherNewsLetter(date: CHECK(_next["pubdate"]), title: CHECK(_next["title"]))
        }
        
        if let _stories = jsonObj["stories"] as? [[String: Any]] {
            for _st in _stories {
                let ST = DailyStory(jsonObj: _st)
                self.stories.append(ST)
            }
        }
    }

}

class DailyStory {

    var title: String = ""
    var slug: String = ""
    var imageUrl: String = ""
    var imageCreditText: String = ""
    var imageCreditUrl: String = ""
    var facts: [String] = []
    var narratives: [String] = []

    init(jsonObj: [String: Any]) {
        self.title = CHECK(jsonObj["title"])
        self.slug = CHECK(jsonObj["slug"])
        self.imageUrl = CHECK(jsonObj["image_url"])
        self.imageCreditText = CHECK(jsonObj["image_credit_title"])
        self.imageCreditUrl = CHECK(jsonObj["image_credit_url"])
        
        if let _facts = jsonObj["facts"] as? [String] {
            self.facts = _facts
        }
        
        if let _narratives = jsonObj["narratives"] as? [String] {
            self.narratives = _narratives
        }
    }

}
// ---------------------------------------
// ---------------------------------------
// ---------------------------------------
class WeeklyNewsletter {
    
    var date: String = ""
    var image: String = ""
    var prev: otherNewsLetter! = nil
    var next: otherNewsLetter! = nil
    var stories: [WeeklyStory] = []
    
    init(jsonObj: [String: Any]) {
        self.date = CHECK(jsonObj["newsletter-date"])
        self.image = CHECK(jsonObj["image_url"])
        
        if let _prev = jsonObj["prev_newsletter"] as? [String: String] { // prev
            self.prev = otherNewsLetter(date: CHECK(_prev["pubdate"]), title: CHECK(_prev["title"]))
        }
        
        if let _next = jsonObj["next_newsletter"] as? [String: String] { // next
            self.next = otherNewsLetter(date: CHECK(_next["pubdate"]), title: CHECK(_next["title"]))
        }
        
        if let _stories = jsonObj["stories"] as? [[String: String]],
            let _first = _stories.first,
            let _encoding = _first["encoding"] {
            
            let rawStories = _encoding.components(separatedBy: "#")
            for rawST in rawStories {
                if(!rawST.isEmpty) {
                    let ST = WeeklyStory(fromText: rawST)
                    self.stories.append(ST)
                }
            }
        }
    }
    
    func trace() {
        print("Weekly newsletter stories ----------------")
        for ST in self.stories {
            ST.trace()
            print("-------")
        }
    }
}

class WeeklyStory {
    
    var title: String = ""
    var topic: String = ""
    var parsedContent: String = ""
    var urls: [String] = []
    var linkedTexts: [String] = []
    
    init(fromText text: String) {
        var topicStart = -1
        
        for i in 0...text.count-1 {
            if(title.isEmpty) { // 1: Title
                if(text[i]==":") {
                    self.title = text.subString(from: 0, count: i-1)!
                    topicStart = i+1
                }
            } else { // 2: Topic + Content
                let char = text[i]
                
                if(char.isUppercase) {
                    let C = i-1
                    if(C>topicStart) {
                        self.topic = text.subString(from: topicStart, count: C)!
                        self.topic = self.topic.replacingOccurrences(of: "-", with: "_")
                        self.topic = self.topic.replacingOccurrences(of: "_and_", with: "_")
                        
                        if(self.topic == "science_technology"){ self.topic = "sci_tech" }
                        if(self.topic.contains("<a")){ self.topic = "" }

                    } else {
                        // No topic
                        NOTHING()
                    }
                    
                    let content = text.replacingOccurrences(of: title + ":" + topic, with: "")
                    self.parseContent(content)
                    
                    break
                }
            }
        }
    }
    
    private func parseContent(_ T: String) {
        var text = T
        var count = 0
        
        while(text.lowercased().contains("<a")) {
            var found = false
            for i in 0...text.count-1 {
                var upperLimit = i+2
                if(upperLimit < text.count) {
                    if(text.subString2(from: i, count: 2)!.lowercased() == "<a ") { // link found
                        for j in i...text.count-1 {
                            upperLimit = j+3
                            if(upperLimit < text.count) {
                                if(text.subString2(from: j, count: 3)!.lowercased() == "</a>") { // link ending
                                    let htmlLink = text.subString2(from: i, count: j-i+3)!
                                    
                                    let data = self.parseHtmlLink(htmlLink)
                                    self.urls.append(data.0)
                                    self.linkedTexts.append(data.1)
                                    
                                    text = text.replacingOccurrences(of: htmlLink, with: "[\(count)]")
                                    count += 1
                                    
                                    found = true
                                    break
                                }
                            }
                        }
                        
                        if(!found && i == text.count-1) {
                            print("Link incompleto!")
                        }
                        
                        if(found) { break }
                    }
                }
            }
        }
        
        text = text.replacingOccurrences(of: "  ", with: " ")
        self.parsedContent = text
    }
    
    func parseHtmlLink(_ htmlLink: String) -> (String, String) {
/*
<a class ='hyplink' href= http://www.verity.news/story/2024/hamas-considers-latest-ceasefire-proposal > considered</a>
 */
 
        var link = htmlLink.lowercased()
        link = link.replacingOccurrences(of: "href=\"", with: "href='")
        link = link.replacingOccurrences(of: "href= ", with: "href='")
        link = link.replacingOccurrences(of: "\">", with: "'>")
        link = link.replacingOccurrences(of: " >", with: "'>")
 
        var url = ""
        var text = ""
 
        for i in 0...link.count-1 {
            var upperLimit = i+5
            if(upperLimit < link.count) {
                if(link.subString2(from: i, count: 5)!.lowercased() == "href='") { // link found
                    for j in i...link.count-1 {
                        upperLimit = j
                        if(upperLimit < link.count) {
                            if(link.subString2(from: j, count: 1)!.lowercased() == "'>") { // link ending
                                url = link.subString2(from: i+5, count: j-i-5)!
                                url = url.replacingOccurrences(of: "'", with: "")
                                
                                text = htmlLink.subString2(from: j+2, count: link.count-j-2-1)!
                                text = text.replacingOccurrences(of: "</a>", with: "")
                                text = text.trimmingCharacters(in: .whitespaces)
                                
                                break
                            }
                        }
                    }
                }
            }
        }
 
        return (url, text)
    }
    
    
    func trace() {
        print(self.title)
        print(self.topic)
        print(self.parsedContent)
        print(self.urls)
        print(self.linkedTexts)
    }
    
}

