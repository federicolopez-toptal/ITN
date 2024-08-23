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
    
    func loadList(term: String = "",
        page: Int, type: Int, callback: @escaping (Error?, Int?, [PublicFigureListItem]?) -> () ) {
        //https://www.improvethenews.org/claims-api/public-figure/list
        
        var url = ITN_URL()
        if(term.isEmpty) {
            url += "/claims-api/public-figure/list?page=\(page)&type=" + String(type)
        } else {
            url += "/claims-api/public-figure/list?page=\(page)&filter=\(term.urlEncodedString())&type=" + String(type)
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
            
//                if let _data = data {
//                    let str = String(data: _data, encoding: .utf8)
//                    print("JSON ------- START")
//                    print(str!)
//                    print("JSON ------- END")
//                }
            
//                let textFromFile = READ_LOCAL(resFile: "fakeJson_PublicFigures.txt")
//                let _data = textFromFile.data(using: .utf8)
            
            
                let _data = data
            
            
                if let _json = JSON(fromData: _data) {
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
    
    //-----------------------------
    func loadMore(slug: String, topic: String, page: Int,
        callback: @escaping (Error?, PublicFigure?) -> ()) {
        
        let url = ITN_URL() + "/claims-api/public-figure/\(slug)?page=\(page)&topic=\(topic)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("STORIES for TOPIC", topic, url)
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
    var type: Int = 0
    
    init(jsonObj: [String: Any]) {
        if let _id = jsonObj["id"] as? Int {
            self.id = _id
        }
        if let _type = jsonObj["figure_type_id"] as? Int {
            self.type = _type
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
    var slug: String = ""
    var image: String = ""
    var description: String = ""
    
        var sourceText: String = ""
        var sourceUrl: String = ""
        var imageCredit: String = ""
        var imageUrl: String = ""

    var topics = [SimpleTopic]()

    var stories = [MainFeedArticle]()
    var storiesCount: Int = 0

    var claims = [Claim]()
    var claimsCount: Int = 0
    
    

    init(jsonObj: [String: Any]) {
        self.name = CHECK(jsonObj["title"])
        self.slug = CHECK(jsonObj["slug"])
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
        
        if let claimsObj = jsonObj["claims"] as? [String: Any],
            let data = claimsObj["data"] as? [[String: Any]],
            let total = claimsObj["total"] as? Int  {
            
            for jsonObj in data {
                let CL = Claim(jsonObj: jsonObj)
                
                self.claims.append(CL)
            }
            
            self.claimsCount = total
        }

        
        
    }

}

// --------------------------------------------------
class Claim {
    
    var figureName: String = ""
    var figureImage: String = ""
    var figureSlug: String = ""
    
    var time: String = ""
    var title: String = ""
    
    var controversyTitle: String = ""
    var controversySlug: String = ""
    
    var sources: [ClaimSource] = []
    
    var description: String = ""
    var claim: String = ""
    
    
    
    init(jsonObj: [String: Any]) {

        if let figureObj = jsonObj["figure"] as? [String: Any] {
            self.figureName = CHECK(figureObj["title"])
            self.figureImage = CHECK(figureObj["image"])
            self.figureSlug = CHECK(figureObj["slug"])
        }
        
        self.time = CHECK(jsonObj["time"])
        self.title = CHECK(jsonObj["title"])
        
        if let clusterObj = jsonObj["cluster"] as? [String: Any] {
            self.controversyTitle = CHECK(clusterObj["title"])
            self.controversySlug = CHECK(clusterObj["slug"])
        }
        
        if let sourcesArray = jsonObj["sources"] as? [[String: Any]] {
            for S in sourcesArray {
                let sourceObj = ClaimSource(jsonObj: S)
                self.sources.append(sourceObj)
            }
        }
        
        self.description = CHECK(jsonObj["description"])
        self.claim = CHECK(jsonObj["claim"])
    }
    
}

// --------------------------------------------------
class ClaimSource {
    var numId: Int = -1
    var strId: String = ""
    
    var name: String = ""
    var url: String = ""
    
    init(jsonObj: [String: Any]) {
        if let _id = jsonObj["id"] as? Int {
            self.numId = _id
        }
        if let _id = jsonObj["id"] as? String {
            self.strId = _id
        }
        
        self.name = CHECK(jsonObj["name"])
        self.url = CHECK(jsonObj["url"])
    }
}
