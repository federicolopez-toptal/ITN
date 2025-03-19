
//
//  TopicFullDetails.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/03/2025.
//

import Foundation
import UIKit


// https://www.improvemynews.com/topics.json

class TopicRef {
    
    var key: String = ""
    var name: String = ""

    init(key: String, data: [String: Any]?) {
        self.key = key
        
        if let _data = data {
            self.name = CHECK(_data["topic"])
        }
    }
    
}

// ------------------------------------------------------------
class TopicsHelper {
    
    static let shared = TopicsHelper()
    // ------------------------------


    private var loading = false
    private var loaded = false

    var data: [TopicRef] = []

    func searchByName(_ nameParam: String) -> String? {
        var N = nameParam.replacingOccurrences(of: "-", with: " ")
        let found = self.data.first { $0.name.lowercased() == N.lowercased() }
    
        if let _found = found {
            return _found.key
        } else {
            return nil
        }
    }

    func loadTopics() {
        if(self.loading || self.loaded) { return }
        
        self.loadAllTopics { (error) in
            print(self.data.count, "topics loaded!")
        }
    }

    func loadAllTopics(callback: @escaping (Error?) -> ()) {
        self.loading = true
        self.loaded = false
        let strUrl = ITN_URL() + "/topics.json"
        
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        
        print("TOPICS fullDetails from", request.url!.absoluteString)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            self.loading = false

            if(error as? URLError)?.code == .timedOut {
                print("Reques TIME OUT!")
                callback(error)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                if let _json = JSON(fromData: data) {
                    self.loaded = true
                    
                    self.data = []
                    for K in _json.keys {
                        let newTopic = TopicRef(key: K, data: _json[K] as? [String: Any])
                        self.data.append(newTopic)
                    }
                    
                    callback(nil)
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error)
                }
            }
        }

        task.resume()
    }
    
}
