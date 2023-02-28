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

// ------------------------------------------------------
class DataProviderHeaderItem: DataProviderItem {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class DataProviderSplitHeaderItem: DataProviderItem {
    /* ... */
}

class DataProviderBannerItem: DataProviderItem {
    
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
class DataProviderGroupItem: DataProviderItem {
    var MaxNumOfItems = 1
    var storyFlags = [Bool]()
    
    var articles = [MainFeedArticle]()
}
// ----------------- //

class DataProvideriPadGroup_top: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 5
        self.storyFlags = [true, true, false, false, false]
    }
    
}

class DataProvideriPadGroup_row: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 3
        self.storyFlags = [false, false, false]
    }
    
}

class iPadGroupItem_split: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
    
}
