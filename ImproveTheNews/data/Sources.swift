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
    var allExtra: [SourceExtraIcon]?
    private let sourcesUrl = ITN_URL() + "/news.json" //"/php/api/news/sources.php"
    private let extraSourcesUrl = ITN_URL() + "/news-non-itn.json"

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
        
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    self.parse(_json)
                    
                    if(self.allExtra == nil) {
                        self.loadExtraData { (error) in
                            callback(nil)
                        }
                    } else {
                        callback(nil)
                    }
                    
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }
        task.resume()
    }
    
    private func loadExtraData(callback: @escaping (Error?) -> ()) {
        var request = URLRequest(url: URL(string: extraSourcesUrl)!)
        request.httpMethod = "GET"
        
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                let mData = ADD_MAIN_NODE(to: data)
                if let _json = JSON(fromData: mData) {
                    self.parseExtra(_json)
                    callback(nil)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }
        task.resume()
    }

    private func parseExtra(_ json: [String: Any]) {
        let mainNode = json["data"] as! [Any]
        self.allExtra = [SourceExtraIcon]()
        
        for obj in mainNode {
            var newExtraSource = SourceExtraIcon(obj as! [String: Any])
            self.allExtra?.append(newExtraSource)
        }
    }

    private func parse(_ json: [String: Any]) {
        let mainNode = json["data"] as! [Any]
        self.all = [SourceIcon]()
        
        let filters: [String] = READ(LocalKeys.preferences.sourceFilters)?.components(separatedBy: ",") ?? []
        
        for obj in mainNode {
            var newSource = SourceIcon(obj as! [String: Any])
            if(newSource.hasCode()) {
                if(filters.contains(newSource.code!)) {
                    newSource.state = false
                }
                
                self.all?.append(newSource)
            }
        }
         
        self.all = self.all!.sorted {
            $0.name.lowercased() < $1.name.lowercased()
        }
    }
    
    func search(identifier: String) -> SourceIcon? {
        let _identifier = self.fixIdentifier(identifier)
    
        var found: SourceIcon? = nil
        found = self.all?.first(where: { $0.identifier == _identifier.lowercased() })
        
        if(found == nil) {
            found = self.all?.first(where: { $0.name.lowercased() == _identifier.lowercased() })
        }
        
        if(found == nil) {
            if let _eFound = self.allExtra?.first(where: { $0.name.lowercased() == _identifier.lowercased() }) {
                found = SourceIcon(data: _eFound)
            }
        }
        
        return found
    }
    func fixIdentifier(_ id: String) -> String {
        var result = ""
        
        switch(id.lowercased()) {
            case "bbcnews":
                result = "bbc"
            case "washingtonpost":
                result = "wapo"
            case "jerusalempost":
                result = "jpost"
            case "npronlinenews":
                result = "npr"
            case "associatedpress":
                result = "ap"
            case "foxnews":
                result = "fox"
            case "wallstreetjournal":
                result = "wsj"
            case "newyorktimes":
                result = "nytimes"
            case "newyorkpost":
                result = "nypost"
            case "spectator(uk)":
                result = "spectator"
            case "pbsnewshour":
                result = "pbs"
                
            default:
                result = id
        }
        
        return result
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

struct SourceExtraIcon {
    var name: String
    var icon: String
    
    init(_ json: [String: Any]) {
        self.name = CHECK(json["name"])
        self.icon = CHECK(json["icon"])
    }
}

struct SourceIcon {

    var identifier: String
    var url: String?
    var name: String
    var paywall: Bool
    var code: String? = nil
    var state: Bool = true
    var LR: Int = 1
    var PE: Int = 1
    
    init(data: SourceExtraIcon) {
        self.identifier = data.name
        self.name = data.name
        self.paywall = false
        
        // code, state, LR, PE
        self.url = ITN_URL() + "/" + data.icon
    }
    
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
                    value = ITN_URL() + "/" + value
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
        
        if let _LR = json["lr"] as? String {
            self.LR = Int(_LR)!
        }
        if let _PE = json["pe"] as? String {
            self.PE = Int(_PE)!
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
