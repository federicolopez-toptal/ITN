//
//  ControversiesData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import Foundation

// --------------------------------------------------
class ControversiesData {
    
    static let shared = ControversiesData()
    
    func loadControversyData(slug: String, page: Int, callback: @escaping (Error?, Controversy?) -> () ) {
        let url = ITN_URL() + "/claims-api/claim/\(slug)?page=\(page)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("CONTROVERSY DATA -  URL", url)
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
                        let C = Controversy(jsonObj: _json)
                        callback(nil, C)
                    }
                } else {
                    callback(CustomError.jsonParseError, nil)
                }
            }
        }

        task.resume()
    }
    
    func loadListForSearch(term: String, callback: @escaping (Error?, [ControversyListItem]?, Int?) -> ()) {
        var T = term
        if(T.isEmpty){ T = "d" }
        var url = ITN_URL() + "/claims-api/claim/search/\(T)?page=1&per_page=200"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("CONTROVERSIES LIST -  URL", url)
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
                        if let _total = _json["total"] as? Int,
                            let _data = _json["data"] as? [[String: Any]] {
                         
                            var list = [ControversyListItem]()
                            for I in _data {
                                let newItem = ControversyListItem(jsonObj: I)
                                list.append(newItem)
                            }
                            callback(nil, list, _total)
                        } else {
                            callback(CustomError.jsonParseError, nil, nil)
                        }
                    }
                } else {
                    if let _data = data, let _text = String(data: _data, encoding: .utf8) {
                        if(_text.lowercased().contains("html") && _text.lowercased().contains("404") ) {
                            callback(nil, [], 0)
                        }
                    } else {
                        callback(CustomError.jsonParseError, nil, nil)
                    }
                }
            }
        }

        task.resume()
    }
    
    func loadListForFeed(topic: String, page: Int, callback: @escaping (Error?, [ControversyListItem]?, Int?) -> ()) {
        //https://www.improvethenews.org/claims-api/claim/search/d?page=1&per_page=2&topic=world
        var url = ITN_URL() + "/claims-api/claim/search/d?page=\(page)&per_page=2"
        if(topic != "news") {
            url += "&topic=\(topic)"
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("CONTROVERSIES LIST -  URL", url)
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
                        if let _total = _json["total"] as? Int,
                            let _data = _json["data"] as? [[String: Any]] {
                         
                            var list = [ControversyListItem]()
                            for I in _data {
                                let newItem = ControversyListItem(jsonObj: I)
                                list.append(newItem)
                            }
                            callback(nil, list, _total)
                        } else {
                            callback(CustomError.jsonParseError, nil, nil)
                        }
                    }
                }
            }
        }

        task.resume()
    }
    
    func loadList(term: String, page: Int, callback: @escaping (Error?, String?, Int?, [ControversyListItem]?) -> () ) {
        let url = ITN_URL() + "/claims-api/claim/search?keyword=\(term)&page=\(page)&per_page=10"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("CONTROVERSIES LIST -  URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil, nil, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil, nil, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _ = _json["error"] {
                        callback(CustomError.jsonParseError, nil, nil, nil)
                    } else {
                        if let _keyword = _json["keyword"] as? String,
                            let _total = _json["total"] as? Int,
                            let _data = _json["data"] as? [[String: Any]] {
                         
                            var list = [ControversyListItem]()
                            for I in _data {
                                let newItem = ControversyListItem(jsonObj: I)
                                //newItem.trace()
                                list.append(newItem)
                            }
                            callback(nil, _keyword, _total, list)
                        } else {
                            callback(CustomError.jsonParseError, nil, nil, nil)
                        }
                    }
                }
            }
        }

        task.resume()
    }
    
    func loadList(topic: String, page: Int,
        callback: @escaping (Error?, Int?, [ControversyListItem]?, [SimpleTopic]?, ControversyPortalData?) -> () ) {
        // error, total, itemList, topics
        
//        let url = ITN_URL() + "/claims-api/claim/search?topic=\(topic)&page=\(page)&per_page=8"
        let url = ITN_URL() + "/claims-api/claim/search/d?page=" + String(page) +
            "&per_page=4&category=" + topic
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("CONTROVERSIES LIST -  URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil, nil, nil, nil)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil, nil, nil, nil)
            } else {
            
//                if let _data = data {
//                    let str = String(data: _data, encoding: .utf8)
//                    print("JSON ------- START")
//                    print(str!)
//                    print("JSON ------- END")
//                }
                
                
//                let textFromFile = READ_LOCAL(resFile: "fakeJson_Controversies.txt")
//                let _data = textFromFile.data(using: .utf8)
                
                
                let _data = data
                
                
                if let _json = JSON(fromData: _data) {
                    if let _ = _json["error"] {
                        callback(CustomError.jsonParseError, nil, nil, nil, nil)
                    } else {
//                        if let _keyword = _json["keyword"] as? String,
                        if let _total = _json["total"] as? Int,
                            let _data = _json["data"] as? [[String: Any]],
//                            let _topics = _json["topics"] as? [[String: Any]] {
                            let _topics = _json["parentCategories"] as? [[String: Any]] {
                            
                            var controData: ControversyPortalData? = nil
                            if let _data = _json["categoryData"] as? [String: Any] {
                                controData = ControversyPortalData(jsonObj: _data)
                            }
                            
                            //let catData = _json["categoryData"] as? [[String: Any]] {
                            
                            var cItems = [ControversyListItem]()
                            for I in _data {
                                let newItem = ControversyListItem(jsonObj: I)
                                cItems.append(newItem)
                            }
                            
                            var topics = [SimpleTopic]()
                            topics.append(SimpleTopic(jsonObj: [
                                "title": "All",
                                "slug": "all"
                            ]))
                            
                            for T in _topics {
                                let newItem = SimpleTopic(jsonObj: T)
                                topics.append(newItem)
                            }
                            
                            
                            callback(nil, _total, cItems, topics, controData)
                        } else {
                            callback(CustomError.jsonParseError, nil, nil, nil, nil)
                        }
                    }
                } else {
                    callback(CustomError.jsonParseError, nil, nil, nil, nil)
                }
            }
        }

        task.resume()
    }

}


// --------------------------------------------------
class FigureForScale {
    
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var scale: Int = 0
    var verified: Bool = false
    var slug: String = ""

    init(jsonObj: [String: Any]) {
        self.id = CHECK_NUM(jsonObj["id"])
        self.name = CHECK(jsonObj["title"])
        self.image = CHECK(jsonObj["image"])
        self.scale = CHECK_NUM(jsonObj["scale"])
        self.verified = CHECK_BOOL(jsonObj["verified"])
        self.slug = CHECK(jsonObj["slug"])
    }
    
    func trace() {
        print(self.name, self.scale)
    }
}

// --------------------------------------------------
class ControversyListItem {

    var title: String = ""
    var slug: String = ""
    var time: String = ""
    
    var textMin: String = ""
    var textMax: String = ""
    var colorMin: String = ""
    var colorMax: String = ""
    
    var figures = [FigureForScale]()
    var used = false
    
    var resolved: String = ""
    
    var image_url: String = ""
    var image_title: String = ""
    var image_credit: String = ""
    
    var controversyType: String = ""
    
    
    init(jsonObj: [String: Any]) {
        self.title = CHECK(jsonObj["title"])
        self.slug = CHECK(jsonObj["slug"])
        self.time = CHECK(jsonObj["time"])
        
        self.textMin = CHECK(jsonObj["startText"])
        self.textMax = CHECK(jsonObj["endText"])
        
        if let _colorObj = jsonObj["color"] as? [String: String] {
            self.colorMin = CHECK(_colorObj["start"])
            self.colorMax = CHECK(_colorObj["end"])
        }
        
        if let _figuresArray = jsonObj["scaleData"] as? [[String: Any]] {
            self.figures = [FigureForScale]()
            
            for _obj in _figuresArray {
                let F = FigureForScale(jsonObj: _obj)
                self.figures.append(F)
            }
        }
        
        self.used = false
        self.resolved = CHECK(jsonObj["resolved"])
        
        if let _imageData = jsonObj["imageData"] as? [String: Any] {
            self.image_url = CHECK(_imageData["image"])
            if let _credit = _imageData["credit"] as? [String: String] {
                self.image_title = CHECK(_credit["title"])
                self.image_credit = CHECK(_credit["url"])
            }
        }
        
        if let _image = jsonObj["image"] as? String {
            self.image_url = _image
        }
        
        if let _controversyType = jsonObj["controversyType"] as? String {
            self.controversyType = _controversyType
        }
    }
    
    func trace() {
        print("CONTROVERSY")
        print(self.title)
        print(self.slug)
        for F in self.figures {
            F.trace()
        }
        print("--------------------------")
    }
    
}

// --------------------------------------------------
class FigureForPortalGraph {
    var name: String = ""
    var image: String = ""
    var slug: String = ""
    var vValue: CGFloat = 0.0
    var hValue: CGFloat = 0.0
    
    init(jsonObj: [String: Any]) {
        self.name = CHECK(jsonObj["title"])
        self.image = CHECK(jsonObj["image"])
        self.slug = CHECK(jsonObj["slug"])
        self.hValue = CGFloat(CHECK_NUM(jsonObj["LR"]))
        self.vValue = CGFloat(CHECK_NUM(jsonObj["PE"]))
    }
}

class controversyPortalGraph {
    var left: String = ""
    var right: String = ""
    var top: String = ""
    var bottom: String = ""
    var figures: [FigureForPortalGraph] = []
    
    init(jsonObj: [String: Any]) {
        if let _chartTitle = jsonObj["chartTitle"] as? [String: String] {
            self.left = CHECK(_chartTitle["left"])
            self.right = CHECK(_chartTitle["right"])
            self.top = CHECK(_chartTitle["top"])
            self.bottom = CHECK(_chartTitle["bottom"])
        }
        
        if let _figures = jsonObj["figures"] as? [[String: Any]] {
            for F in _figures {
                let newFigure = FigureForPortalGraph(jsonObj: F)
                self.figures.append(newFigure)
            }
        }
    }
}

class ControversyPortalData {
    
    var title: String = ""
    var description: String = ""
    
    var graph: controversyPortalGraph? = nil
    
    init(jsonObj: [String: Any]) {
        self.title = CHECK(jsonObj["title"])
        self.description = CHECK(jsonObj["description"])
        
        if let _figureData = jsonObj["figuresData"] as? [String: Any] {
            self.graph = controversyPortalGraph(jsonObj: _figureData)
        }
        
    }
}

// --------------------------------------------------
class Controversy {

    var info: ControversyListItem
    
    var claims = [Claim]()
    var claimsTotal = 0
    
    var goDeepers = [StorySearchResult]()
    var goDeeperTotal = 0
    
    init(jsonObj: [String: Any]) {
        self.info = ControversyListItem(jsonObj: jsonObj)
        
        if let claimsObj = jsonObj["claims"] as? [String: Any],
            let data = claimsObj["data"] as? [[String: Any]],
            let total = claimsObj["total"] as? Int  {
            
            for jsonObj in data {
                let CL = Claim(jsonObj: jsonObj)
                self.claims.append(CL)
            }
            
            self.claimsTotal = total
        }
        
        if let goDeeperObj = jsonObj["goDeeper"] as? [String: Any],
            let data = goDeeperObj["data"] as? [[String: Any]],
            let total = goDeeperObj["total"] as? Int  {
            
            for jsonObj in data {
                let GD = StorySearchResult(jsonObj)
                self.goDeepers.append(GD)
            }
            
            self.goDeeperTotal = total
        }
    }

}
