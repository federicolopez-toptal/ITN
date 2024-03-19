//
//  NewsLetterData.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/03/2024.
//

import Foundation

class NewsLetterData {
    
    static let shared = NewsLetterData()
    
    // Load newsletter list
    func loadData(range: String, type: String, offset: Int,
        callback: @escaping (Error?, [NewsLetterStory], Int, Int) -> ()) {
        
        let url = ITN_URL() + "/php/stories/newsletters-archive.php" +
            "?range=" + range + "&type=" + type + "&offset=" + String(offset)
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("NEWSLETTER URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, [], -1, -1)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, [], -1, -1)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _ = _json["error"] {
                        if let _msg = _json["message"] as? String {
                            if(_msg.lowercased().contains("no record found")) {
                                callback(nil, [], -1, -1)
                            } else {
                                callback(CustomError.jsonParseError, [], -1, -1)
                            }
                        } else {
                            callback(CustomError.jsonParseError, [], -1, -1)
                        }
                    } else {
                        if let storiesNode = _json["stories"] as? [[String: Any]] {
                            var stories = [NewsLetterStory]()
                            for node in storiesNode {
                                let newItem = NewsLetterStory(node)
                                stories.append(newItem)
                            }
                            
                            let pages = _json["pages"] as! Int
                            let currentPage = _json["page_no"] as! Int
                            
                            callback(nil, stories, currentPage, pages)
                        } else {
                            callback(CustomError.jsonParseError, [], -1, -1)
                        }
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, [], -1, -1)
                }
            }
        }

        task.resume()
    }
    
    // load daily/weely newsletter
    func loadNewsletter(_ ST: NewsLetterStory,
        callback: @escaping (Error?) -> () ) {
        
        var url = ""
        if(ST.type == 1) {
            url = ITN_URL() + "/php/stories/daily-newsletters.php?date=" + ST.date
        } else {
            url = ITN_URL() + "/php/stories/weekly-newsletters.php?date=" + ST.date
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("Loading NEWSLETTER", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error)
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error)
            } else {
                if let _json = JSON(fromData: data) {
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
