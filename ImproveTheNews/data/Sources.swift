//
//  Sources.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import Foundation

class Sources {
    
    static let shared = Sources()

    var all: [SourceIcon]?
    private let sourcesUrl = API_BASE_URL() + "/news.json" //"/php/api/news/sources.php"



    func checkIfLoaded(callback: @escaping (Bool) -> ()) {
        if(all != nil) {
            callback(true)
        } else {
            self.loadData { (error) in
                if let _ = error {
                    callback(false)
                } else {
                    callback(true)
                }
            }
        }
    }

    private func loadData(callback: @escaping (Error?) -> ()) {
        var request = URLRequest(url: URL(string: sourcesUrl)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    self.parse(_json)
                    callback(nil)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }
        task.resume()
    }

    private func parse(_ json: [String: Any]) {
        let mainNode = json["data"] as! [Any]
        self.all = [SourceIcon]()
        
        for obj in mainNode {
            let newSource = SourceIcon(obj as! [String: Any])
            self.all?.append(newSource)
        }
    }
    
    func search(name: String) -> SourceIcon? {
        let found = self.all?.first(where: { $0.identifier == name.lowercased() })
        return found
    }
}

struct SourceIcon {

    var identifier: String
    var url: String?

    init(_ json: [String: Any]) {
        self.identifier = (json["shortname"] as! String).lowercased()
        
        if let _icon = json["icon"] as? String {
            if(!_icon.isEmpty) {
                var value = _icon
                if(!value.contains("http") && !value.contains("www")) {
                    value = API_BASE_URL() + "/" + value
                }
                self.url = value
            }
        }
    }
}
