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
    
    func loadList(term: String = "", page: Int, callback: @escaping (Error?, String?, Int?, [ControversyListItem]?) -> () ) {
        let url = ITN_URL() + "/claims-api/claim/search?keyword=\(term)&page=\(page)&per_page=8"
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

}


// --------------------------------------------------
class FigureForScale {
    
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var scale: Int = 0
    var verified: Bool = false
    

    init(jsonObj: [String: Any]) {
        self.id = CHECK_NUM(jsonObj["id"])
        self.name = CHECK(jsonObj["title"])
        self.image = CHECK(jsonObj["image"])
        self.scale = CHECK_NUM(jsonObj["scale"])
        self.verified = CHECK_BOOL(jsonObj["verified"])
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
