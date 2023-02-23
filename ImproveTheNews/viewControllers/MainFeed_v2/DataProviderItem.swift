//
//  DataProviderItem.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation

// MARK: Basic classes
class DataProviderItem {
}

class DataProviderGroupItem: DataProviderItem {
    var MaxNumOfItems = 1
    var storyFlags = [Bool]()
    
    var articles = [MainFeedArticle]()
}

class DataProviderHeaderItem: DataProviderItem {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class DataProviderMoreItem: DataProviderItem {
    var topic = "news"
    var completed = false
    
    init(topic: String, completed: Bool) {
        self.topic = topic
        self.completed = completed
    }
}

// ------------------------------------------------------
class iPadGroupItem_top: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 5
        self.storyFlags = [true, true, false, false, false]
    }
    
}

class iPadGroupItem_row: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 3
        self.storyFlags = [false, false, false]
    }
    
}
