//
//  StoryContent.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import Foundation


class StoryContent {
    
    private let storyID_url = API_BASE_URL() + "/api/route?slug="
    private let storyData_url = API_BASE_URL() + "/php/stories/index.php?path=story&id=<ID>&filters=<FILTERS>"
    
    func load(url: String, callback: @escaping (MainFeedStory?) ->()) {
        let slug = self.extractSlugFrom(url: url)
        self.getStoryID(slug: slug) { (storyID) in
            if let _storyID = storyID {
                self.getStoryData(storyID: _storyID) { (story) in
                    if(story==nil){ print("ERROR: getStoryData") }
                    callback(story)
                }
            } else {
                print("ERROR: getStoryID")
                callback(nil)
            }
        }
    }
    
}

// MARK: - Utils
extension StoryContent {
    
    private func extractSlugFrom(url: String) -> String {
        if let _url = URL(string: url), let _domain = _url.host {
            let parts = url.components(separatedBy: _domain)
            if(parts.count>1) {
                return String(parts[1].dropFirst())
            }
        }
        return url
    }
    
    private func getStoryID(slug: String,
        callback: @escaping (String?) -> ()) {
        
        let url = storyID_url + slug
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(nil)
            } else {
                var strData = String(decoding: data!, as: UTF8.self)
                strData = String(strData.dropFirst())
                strData = String(strData.dropLast())
                let mData = strData.data(using: .utf8)

                if let json = JSON(fromData: mData) {
                    let path = json["path"] as! String
                    let storyID = path.replacingOccurrences(of: "/stories/", with: "")
                    callback(storyID)
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
    
    private func getStoryData(storyID: String,
        callback: @escaping (MainFeedStory?) -> () ) {
        //callback: @escaping (StoryData?, [StoryFact]?, [StorySpin]?, [StoryArticle]?, String?) ->() ) {
        
        var url = storyData_url.replacingOccurrences(of: "<ID>", with: storyID)
        url = url.replacingOccurrences(of: "<FILTERS>", with: MainFeedv3.sliderValues())
        url += "&split=" + String(MUST_SPLIT()) + "0"
        //url += "&split=00" // + self.mustSplit()
        print("URL story", url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(nil)
            } else {
                if let json = JSON(fromData: data) {
                    if let _ = json["error"] {
                        callback(nil)
                    } else {
                        let story = MainFeedStory(json) //Story content
                        callback(story)
                    }
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
    
}
