//
//  KeywordSearch.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/06/2023.
//

import Foundation


class KeywordSearch {

    static var shared = KeywordSearch()
    
    private var searchUrl = "https://www.improvethenews.org/php/util/search-topics.php"
    //private var searchUrl = "http://ec2-18-191-221-195.us-east-2.compute.amazonaws.com/php/util/search-topics.php"
    
    private var searchPageSize: Int = 11
    private var searchPage: Int = 1
    
    var searchType: searchType = .all
    var topics: [TopicSearchResult] = []
    var stories: [StorySearchResult] = []
    var articles: [ArticleSearchResult] = []
    
    
    init() {
    }
    
    func search(_ text: String, type: searchType = .all, callback: @escaping (Bool) -> () ) {
        self.searchType = type
        self.topics = []
        self.stories = []
        self.articles = []
        let offset = (self.searchPage-1)*self.searchPageSize
        
        var url = self.searchUrl + "?searchtype=" + self.searchType.rawValue
        url += "&searchstring=" + text + "&limit=" + String(self.searchPageSize)
        url += "&offset=" + String(offset)
        url += "&slidercookies=" + MainFeedv3.sliderValues()
        url += "&userId=" + UUID.shared.getValue()
        
        print("----")
        print("SEARCH", url)
        
        self.makeSearch(withUrl: url) { (success, serverMsg, json) in
            if let _json = json, success {
                self.parseResult(_json)
                callback(true)
            } else {
                print("ERROR", serverMsg)
                callback(false)
            }
        }
    }
    
    private func makeSearch(withUrl url: String, callback: @escaping (Bool, String, [String: Any]?) -> () ) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, resp, error in
            if let _error = error {
                callback(false, _error.localizedDescription, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    callback(true, "", _json)
                } else {
                    callback(false, API.defaultErrorMessage, nil)
                }
                
            }
        }
        task.resume()
    }
    
    private func parseResult(_ json: [String: Any]) {
        // TOPICS
        if let _topics = json["topics"] as? [Any] {
            for TOP in _topics {
                let newTopic = TopicSearchResult(TOP as! [String: String])
                self.topics.append(newTopic)
            }
        }
        
        // STORIES
        if let _stories = json["stories"] as? [Any] {
            for STO in _stories {
                let newStory = StorySearchResult(STO as! [String: Any])
                self.stories.append(newStory)
            }
        }
        
        // ARTICLES
        if let _articles = json["articles"] as? [Any] {
            for ART in _articles {
                let newArticle = ArticleSearchResult(ART as! [String: Any])
                self.articles.append(newArticle)
            }
        }
    }
}

// MARK: - Custom types
struct ArticleSearchResult {
    
    var title: String = ""
    var url: String = ""
    var timeAgo: String = ""
    var imgUrl: String = ""
    var country: String = ""
    var mediaName: String = ""
    var LR: Int = 1
    var PE: Int = 1
    
    init(_ data: [String: Any]) {
        self.title = data["title"] as! String
        self.url = data["url"] as! String
        self.timeAgo = data["timeago"] as! String
        self.imgUrl = data["imgurl"] as! String
        self.country = data["countryID"] as! String
        self.mediaName = data["medianame"] as! String
        self.LR = data["LR"] as! Int
        self.PE = data["PE"] as! Int
    }
}

struct StorySearchResult {
    var image_url: String = ""
    var slug: String = ""
    var timeago: String = ""
    var title: String = ""
    var medianames: String = ""
    
    init(_ data: [String: Any]) {
        self.image_url = data["image_url"] as! String
        self.slug = data["slug"] as! String
        self.timeago = data["timeago"] as! String
        self.title = data["title"] as! String
        
        self.medianames = ""
        if let _medianames = data["medianames"] as? String {
            self.medianames = _medianames
        }
    }
}

struct TopicSearchResult {
    var label: String = ""
    var name: String = ""
    var lcName: String = ""
    
    init(_ data: [String: String]) {
        self.label = data["label"]!
        self.lcName = data["lcname"]!
        self.name = data["name"]!
    }
}

// MARK: - Enum(s)
enum searchType: String {
    case all = "all"
    case topics = "topics"
    case stories = "stories"
    case articles = "articles"
}

