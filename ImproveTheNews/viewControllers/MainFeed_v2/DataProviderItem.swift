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
    /* ... */
}

class DataProviderFooterItem: DataProviderItem {
    /* ... */
}

class DataProviderSpacer: DataProviderItem {
    var size: CGFloat = 1.0
    
    init(size: CGFloat) {
        self.size = size
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

class DataProvideriPadGroup_topText: DataProviderGroupItem {

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

class DataProvideriPadGroup_rowText: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 3
        self.storyFlags = [false, false, false]
    }
    
}

class DataProvideriPadGroup_rowNoStories: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
    
}

class DataProvideriPadGroupItem_split: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
    
}

class DataProvideriPadGroupItem_splitText: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
    
}

class DataProvideriPadGroupItem_splitStory: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 4
        self.storyFlags = [true, true, true, true]
    }
    
}

class DataProvideriPadGroupItem_splitStoryText: DataProviderGroupItem {

    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 4
        self.storyFlags = [true, true, true, true]
    }
    
}

