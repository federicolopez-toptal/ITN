//
//  KeywordSearch.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/06/2023.
//

import Foundation


class KeywordSearch {

    static var shared = KeywordSearch()
    static var searchTerm: String?
    
    private var searchUrl = ITN_URL() + "/php/util/search-topics.php"
    
    private var searchPageSize: Int = 12
    var searchType: searchType = .all
    var topics: [TopicSearchResult] = []
    var stories: [StorySearchResult] = []
    var contextStories: [StorySearchResult] = []
    var articles: [ArticleSearchResult] = []
    
    var controversies: [ControversyListItem] = []
    var loadingControversies = false
    
    var task: URLSessionDataTask? = nil
    
    var lastSearch: String = ""
    
    
    init() {
    }
    
    func toZero() {
        self.topics = []
        self.stories = []
        self.contextStories = []
        self.articles = []
        self.controversies = []
    }
    
    func cancelSearch() {
        self.task?.cancel()
    }
    
    func search(_ text: String, type: searchType = .all, pageNumber: Int = 1, callback: @escaping (Bool, Int, Bool) -> () ) {
        
        self.searchType = type
        self.lastSearch = text
        let offset = self.searchPageSize * (pageNumber-1)
        
        if(type == .all) {
            self.topics = []
            self.stories = []
            self.contextStories = []
            self.articles = []
            self.controversies = []
        }
        
//        var _text = text
//        _text = _text.replacingOccurrences(of: "'", with: "")
//        _text = _text.replacingOccurrences(of: "\"", with: "")
        
        var url = self.searchUrl + "?searchtype=" + self.searchType.rawValue
        url += "&searchstring=" + text.urlEncodedString() + "&limit=" + String(self.searchPageSize)
        url += "&offset=" + String(offset)
        url += "&slidercookies=" + MainFeedv3.sliderValues()
        url += "&userId=" + UUID.shared.getValue()
        
        print("----")
        print("SEARCH", url)
        
        var addNode = false
        if(type != .all) {
            addNode = true
        }
        
        //print("SEARCHING...")
        self.makeSearch(withUrl: url, addMainNode: addNode) { (success, serverMsg, json) in
            if let _json = json, success {
            
                var count = self.parseResult(_json)
                callback(true, count, false)
                
                if(pageNumber == 1) {
                    self.loadingControversies = true
                    DELAY(1.5) {
                        ControversiesData.shared.loadListForSearch(term: text.urlEncodedString()) { (_, list, total) in
                            if let _list = list, let _total = total {
                                self.controversies = _list
                                count += _total
                            }
                            self.loadingControversies = false
                            callback(true, count, true)
                        }
                    }
                }
                
//                if(pageNumber==1) {
//                    ControversiesData.shared.loadListForSearch(term: text.urlEncodedString()) { (_, list, total) in
//                        if let _list = list, let _total = total {
//                            self.controversies = _list
//                            count += _total
//                        }
//
//                        callback(true, count)
//                    }
//                } else {
//                    callback(true, count)
//                }

//                callback(true, count)
            
            } else {
                print("ERROR", serverMsg)
                callback(false, -1, false)
            }
        }
    }
    
    private func makeSearch(withUrl url: String, addMainNode: Bool, callback: @escaping (Bool, String, [String: Any]?) -> () ) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
//        if let _task = self.task, _task.state != .completed {
//            //_task.cancel()
//            print("cancelar busqueda")
//        }
        self.task?.cancel()
        
//        self.task = URLSession.shared.dataTask(with: request) { data, resp, error in
        self.task = URL_SESSION().dataTask(with: request) { data, resp, error in
            if let _error = error {
                if(_error.localizedDescription != "cancelled") {
                    callback(false, _error.localizedDescription, nil)
                }
            } else {
                if(addMainNode) {
                    let mData = ADD_MAIN_NODE(to: data)
                    if let _json = JSON(fromData: mData) {
                        callback(true, "", _json)
                    } else {
//                        print("ERROR JSON - main node")
                        callback(false, API.defaultErrorMessage, nil)
                    }
                } else {
                    if let _json = JSON(fromData: data) {
                        callback(true, "", _json)
                    } else {
//                        print("ERROR JSON - NO main node")
                        callback(false, API.defaultErrorMessage, nil)
                    }
                }
            }
        }
        self.task?.resume()
    }
    
    private func parseResult(_ json: [String: Any]) -> Int {
        var count = 0
        var myCount = 0
        
        if(self.searchType == .all) {
            // TOPICS
            if(self.lastSearch.isEmpty) {
                let defaultTopics = self.defaultTopics()
                count += defaultTopics.count
                for T in defaultTopics {
                    self.topics.append(T)
                }
            } else {
                if let _topics = json["topics"] as? [Any] {
                    count += _topics.count
                    for TOP in _topics {
                        let newTopic = TopicSearchResult(TOP as! [String: String])
                        //newTopic.trace()
                        
                        self.topics.append(newTopic)
                    }
                }
            }
            
            // STORIES
            if let _stories = json["stories"] as? [Any] {
                count += _stories.count
                for STO in _stories {
                    let newStory = StorySearchResult(STO as! [String: Any])
                    self.stories.append(newStory)
                    myCount += 1
                }
            }
            
            // CONTEXT STORIES
            if let _cStories = json["contextstories"] as? [Any] {
                count += _cStories.count
                
                for STO in _cStories {
                    let newStory = StorySearchResult(STO as! [String: Any], strType: "CX")
                    self.contextStories.append(newStory)
                    myCount += 1
                }
            }
            
            // ARTICLES
            if let _articles = json["articles"] as? [Any] {
                count += _articles.count
                for ART in _articles {
                    let newArticle = ArticleSearchResult(ART as! [String: Any])
                    self.articles.append(newArticle)
                    myCount += 1
                    
//                    if(myCount==2) {
//                        break
//                    }
                }
            }
            
            // CONTROVERSIES
            
        }
        
        if(self.searchType == .stories) { // ONLY ADDING STORIES
            if let _data = json["data"] as? [Any] {
                if let _stories = _data[0] as? [Any] {
                    count += _stories.count
                    for STO in _stories {
                        let newStory = StorySearchResult(STO as! [String: Any])
                        self.stories.append(newStory)
                    }
                }
            }
        }
        
        if(self.searchType == .articles) { // ONLY ADDING ARTICLES
            if let _data = json["data"] as? [Any] {
                if let _articles = _data[0] as? [Any] {
                    count += _articles.count
                    for ART in _articles {
                        let newArticle = ArticleSearchResult(ART as! [String: Any])
                        self.articles.append(newArticle)
                    }
                }
            }
        }
        
        return count
    }
    
    func defaultTopics() -> [TopicSearchResult] {
        var topics = [TopicSearchResult]()
        
        topics.append(TopicSearchResult([
            "label": "news",
            "lcname": "headline",
            "name": "Headlines"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "world",
            "lcname": "world",
            "name": "World"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "crime_justice",
            "lcname": "crime & justice",
            "name": "Crime & justice"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "social_issues",
            "lcname": "social issues",
            "name": "Social issues"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "sci_tech",
            "lcname": "science & technology",
            "name": "Science & technology"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "education",
            "lcname": "education",
            "name": "Education"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "health",
            "lcname": "health",
            "name": "Health"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "environment_energy",
            "lcname": "environment/energy",
            "name": "Environment/energy"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "military",
            "lcname": "military",
            "name": "Military"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "politics",
            "lcname": "politics",
            "name": "Politics"
        ]) )
        
        topics.append(TopicSearchResult([
            "label": "money",
            "lcname": "money",
            "name": "Money"
        ]) )
        
        return topics
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
    var used: Bool = false
    var media_id: Int = -1
    
    init(_ data: [String: Any]) {
        self.title = data["title"] as! String
        self.url = data["url"] as! String
        self.timeAgo = data["timeago"] as! String
        self.imgUrl = data["imgurl"] as! String
        self.country = data["countryID"] as! String
        self.mediaName = data["medianame"] as! String
        self.LR = data["LR"] as! Int
        self.PE = data["PE"] as! Int
        self.media_id = data["media_id"] as! Int
    }
}

struct StorySearchResult {
    var id: String = ""

    var image_url: String = ""
    var slug: String = ""
    var timeago: String = ""
    var date: String = ""
    var title: String = ""
    var medianames: String = ""
    var used: Bool = false
    
    var figureName: String = ""
    var figureImageUrl: String = ""
    
    var type: Int = 1
    var videoFile: String?
    
    var strType: String = ""
    
    init(_ data: [String: Any], strType: String = "") {
        let num = CHECK_NUM(data["id"])
        if(num != -1) {
            self.id = String(num)
        }
    
        if let _imageUrl = data["image_url"] as? String {
            self.image_url = _imageUrl
        } else if let _imageUrl = data["image"] as? String {
            self.image_url = _imageUrl
        }
        
        self.slug = ""
        if let _slug = data["slug"] as? String {
            self.slug = _slug
        } else {
            if let _url = data["url"] as? String {
                self.slug = _url.replacingOccurrences(of: "/story", with: "story")
            }
        }
        
        //print("TIME RELATIVE:", data["timeRelative"])
        if let _timeAgo = data["timeago"] as? String {
            self.timeago = _timeAgo
        } else if let _timeAgo = data["timeRelative"] as? String {
            self.timeago = _timeAgo
        } else if let _timeAgo = data["updated"] as? String {
            //self.timeago = self.formattedUpdatedTime(input: _timeAgo)
            self.timeago = DATE_TO_TIMEAGO(_timeAgo)
        } else if let _timeAgo = data["time"] as? String {
            self.timeago = FIX_TIME(_timeAgo)
        }
        
        self.date = CHECK(data["timestamp"])
        self.title = data["title"] as! String
        
        self.medianames = ""
        if let _mediaNames = data["medianames"] as? String {
            self.medianames = _mediaNames
        } else if let _mediaNames = data["media"] as? [String] {
            self.medianames = _mediaNames.joined(separator: ",")
        } else if let _mediaNames = data["mediaList"] as? [String] {
            self.medianames = _mediaNames.joined(separator: ",")
        }
        
        if let _type = data["storytype"] as? Int {
            self.type = _type
        }
        if let _type = data["storytype"] as? String, _type.lowercased() == "context" {
            self.type = 2
        }
        
        if let _videoFile = data["videofile"] as? String {
            self.videoFile = _videoFile
        }
        
        if let _figuresArray = data["figures"] as? [[String: Any]], _figuresArray.count>0 {
            if let F = _figuresArray.first {
                self.figureName = CHECK(F["name"])
                self.figureImageUrl = CHECK(F["image"])
            }
        }
        
        self.strType = strType
    }
    
    func formattedUpdatedTime(input: String) -> String {
        /*
            Examples:
                input:  2023-04-30 21:31:29
                output: APR 28, 2023
         */
        //Examples: ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let inputDate = formatter.date(from: input)!
        var result = ""
        
        formatter.dateFormat = "LLL"
        result = formatter.string(from: inputDate)
        
        formatter.dateFormat = "dd"
        result += " " + formatter.string(from: inputDate)
        
        formatter.dateFormat = "yyyy"
        result += ", " + formatter.string(from: inputDate)
    
        return result
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
    
    func trace() {
        print("TopicSearchResult -------------")
        print("label", self.label)
        print("lcname", self.lcName)
        print("name", self.name)
    }
}

// MARK: - Enum(s)
enum searchType: String {
    case all = "all"
    case topics = "topics"
    case stories = "stories"
    case contextStories = "contextstories"
    case articles = "articles"
}

