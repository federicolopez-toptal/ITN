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
    // example: https://www.improvemynews.com/news.json


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
        
        var filters: [String] = READ(LocalKeys.preferences.sourceFilters)?.components(separatedBy: ",") ?? []
        
        for obj in mainNode {
            var newSource = SourceIcon(obj as! [String: Any])
            if(newSource.hasCode()) {
                if(filters.contains(newSource.code!)) {
                    newSource.state = false
                }
                self.all?.append(newSource)
            }
        }
    }
    
    func search(identifier: String) -> SourceIcon? {
        let found = self.all?.first(where: { $0.identifier == identifier.lowercased() })
        return found
    }
    
    func search(name: String) -> String? {
        if let _cleanName = name.components(separatedBy: " #").first {
            if let _found = self.all?.first(where: { $0.name.lowercased() == _cleanName.lowercased() }) {
                return _found.identifier
            }
        }
        
        return nil
    }
    
    func updateSourceState(_ code: String, _ state: Bool) {
        for (i, icon) in self.all!.enumerated() {
            if(icon.code == code) {
                self.all![i].state = state
                break
            }
        }
    }
    
}

struct SourceIcon {

    var identifier: String
    var url: String?
    var name: String
    var paywall: Bool
    var code: String?
    var state: Bool = true
    
    init(_ json: [String: Any]) {
        self.identifier = ""
        if let _identifier = json["shortname"] as? String {
            self.identifier = _identifier.lowercased()
        } else {
            if let _identifier = json["label"] as? String {
                self.identifier = _identifier.lowercased()
            }
        }        
        self.name = (json["name"] as! String) //.lowercased()
        
        if let _icon = json["icon"] as? String {
            if(!_icon.isEmpty) {
                var value = _icon
                if(!value.contains("http") && !value.contains("www")) {
                    value = API_BASE_URL() + "/" + value
                }
                self.url = value
            }
        }
        
        self.paywall = false
        if let _paywall = json["paywall"] as? String {
            if(_paywall == "1"){ self.paywall = true }
        }
        
        if let _code = json["API codes"] as? String {
            if(_code.count>2) {
                self.code = _code.subString(from: 0, count: 2)
            } else {
                self.code = _code
            }
        }        
    }
    
    func hasCode() -> Bool {
        if let _code = self.code {
            if(_code.isEmpty) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
