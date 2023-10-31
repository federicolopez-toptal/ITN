//
//  FAQ_Stories.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/10/2023.
//

import Foundation

class FAQ_Stories {
    
    func loadData(callback: @escaping ([StorySearchResult]?, Error?) -> ()) {
        let url = ITN_URL() + "/api/faqstories?type=latest&page=1&path=faq-stories"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
    
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(nil, error)
            } else {
                if let _json = JSON(fromData: data) {
                    if let dataNode = _json["data"] as? [String: Any], let storiesArray = dataNode["storyData"] as? [Any] {
                        var _stories = [StorySearchResult]()
                        for ST in storiesArray {
                            let story = StorySearchResult(ST as! [String: Any])
                            _stories.append(story)
                        }
                        
                        callback(_stories, nil)
                    } else {
                        callback(nil, nil)
                    }
                } else {
                    callback(nil, nil)
                }
            }
        }
        task.resume()
    }
    
}
