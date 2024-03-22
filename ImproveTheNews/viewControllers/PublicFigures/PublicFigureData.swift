//
//  PublicFigureData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/03/2024.
//

import Foundation


// --------------------------------------------------
class PublicFigureData {
    
    static let shared = PublicFigureData()
    
    func loadList(term: String = "", page: Int, callback: @escaping (Error?, Int?, [PublicFigureListItem]?) -> () ) {
        
        var url = ITN_URL()
        if(term.isEmpty) {
            url += "/api/public-figures?page=\(page)"
        } else {
            url += "/api/public-figures?page=\(page)&filter=\(term.urlEncodedString())"
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("PUBLIC FIGURES LIST -  URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _ = _json["error"] {
                        callback(CustomError.jsonParseError, nil, nil)
                    } else {
                        if let _items = _json["items"] as? [[String: Any]], let _total = _json["total"] as? Int {
                            
                            var listItems = [PublicFigureListItem]()
                            for I in _items {
                                let newItem = PublicFigureListItem(jsonObj: I)
                                listItems.append(newItem)
                            }
                            callback(nil, _total, listItems)
                            
                        } else {
                            callback(CustomError.jsonParseError, nil, nil)
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil, nil)
                }
            }
        }

        task.resume()         
    }
    
    //-----------------------------
    func loadFigure(slug: String,
        callback: @escaping (Error?, PublicFigure?) -> ()) {
        
        let url = ITN_URL() + "/claims-api/public-figure/\(slug)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("FIGURE", url)
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
                    if let _ = _json["error"] {
                        callback(CustomError.jsonParseError, nil)
                    } else {
                        let figure = PublicFigure(jsonObj: _json)
                        callback(nil, figure)
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil)
                }
            }
        }

        task.resume()
    }
    
}



// --------------------------------------------------
class PublicFigureListItem {
    var id: Int = 0
    var slug: String = ""
    var title: String = ""
    var image: String = ""
    
    init(jsonObj: [String: Any]) {
        if let _id = jsonObj["id"] as? Int {
            self.id = _id
        }
    
        self.slug = CHECK(jsonObj["slug"])
        self.title = CHECK(jsonObj["title"])
        self.image = CHECK(jsonObj["image"])
    }
    
}

// --------------------------------------------------
class SimpleTopic {
    var name: String = ""
    var slug: String = ""
    
    init(jsonObj: [String: Any]) {
        self.name = CHECK(jsonObj["title"])
        self.slug = CHECK(jsonObj["slug"])
    }
    
    func trace() {
        print("Topic:")
        print(self.name)
        print(self.slug)
        print("----------")
    }
}

// --------------------------------------------------
class PublicFigure {

    var name: String = ""
    var image: String = ""
    var description: String = ""
    
        var sourceText: String = ""
        var sourceUrl: String = ""
        var imageCredit: String = ""
        var imageUrl: String = ""

    var topics = [SimpleTopic]()

    var stories = [MainFeedArticle]()
    var storiesCount: Int = 0

    init(jsonObj: [String: Any]) {
        self.name = CHECK(jsonObj["title"])
        self.image = CHECK(jsonObj["image"])
        self.description = CHECK(jsonObj["description"])
        
        if let sourceObj = jsonObj["source"] as? [String: String] {
            self.sourceText = CHECK(sourceObj["title"])
            self.sourceUrl = CHECK(sourceObj["url"])
        }
        
        if let creditObj = jsonObj["credit"] as? [String: String] {
            self.imageCredit = CHECK(creditObj["title"])
            self.imageUrl = CHECK(creditObj["url"])
        }
        
        if let topicsObj = jsonObj["topics"] as? [ [String: Any] ] {
            self.topics = [SimpleTopic]()
            let T0 = SimpleTopic(jsonObj: [
                "title": "All",
                "slug": "all"
            ])
            self.topics.append(T0)
            
            for T in topicsObj {
                self.topics.append( SimpleTopic(jsonObj: T) )
            }
        }
        
        if let storiesObj = jsonObj["stories"] as? [String: Any],
            let data = storiesObj["data"] as? [[String: Any]],
            let total = storiesObj["total"] as? Int  {
            
            for jsonObj in data {
                let ST = MainFeedArticle(jsonFromFigure: jsonObj)
                self.stories.append(ST)
            }
            
            self.storiesCount = total
        }
        
    }

}

