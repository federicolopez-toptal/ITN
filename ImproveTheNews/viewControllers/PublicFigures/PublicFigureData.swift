//
//  PublicFigureData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/03/2024.
//

import Foundation

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
    
}
