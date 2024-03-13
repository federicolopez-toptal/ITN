//
//  NewsLetterData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/03/2024.
//

import Foundation

class NewsLetterData {
    
    static let shared = NewsLetterData()
    
    func loadData(range: String, type: String, offset: Int,
        callback: @escaping (Error?, [NewsLetterStory]) -> ()) {
        
        let url = ITN_URL() + "/php/stories/newsletters-archive.php" +
            "?range=" + range + "&type=" + type + "&offset=" + String(offset)
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print(url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, [])
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, [])
            } else {
                if let _json = JSON(fromData: data) {
                    if let _ = _json["error"] {
                        if let _msg = _json["message"] as? String {
                            if(_msg.lowercased().contains("no record found")) {
                                callback(nil, [])
                            } else {
                                callback(CustomError.jsonParseError, [])
                            }
                        } else {
                            callback(CustomError.jsonParseError, [])
                        }
                    } else {
                        if let storiesNode = _json["stories"] as? [[String: Any]] {
                            var stories = [NewsLetterStory]()
                            for node in storiesNode {
                                let newItem = NewsLetterStory(node)
                                stories.append(newItem)
                            }
                            
                            callback(nil, stories)
                        } else {
                            callback(CustomError.jsonParseError, [])
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, [])
                }
            }
        }

        task.resume()
    }
    
}
