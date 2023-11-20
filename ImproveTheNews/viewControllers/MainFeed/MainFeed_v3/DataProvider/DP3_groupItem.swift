//
//  DP3_groupItem.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/10/2023.
//

import Foundation
import UIKit

// MARK: Data Provider with a group of stories/articles
class DP3_groupItem: DP3_item {
    var MaxNumOfItems = 1
    var storyFlags = [Bool]()
    
    var articles = [MainFeedArticle]()
}

////////////////////////////////////////////////////////////////////////
// MARK: Subclasses
class DP3_iPhoneStory_vImg: DP3_groupItem {

    // 1 big story with image
    override init() {
        super.init()
        
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 1
        self.storyFlags = [true]
    }
}

class DP3_iPhoneStory_vTxt: DP3_groupItem {
    // 1 big story (only text))
    var showSources = true
    
    init(showSources: Bool = false) {
        super.init()
        self.showSources = showSources
        
        self.articles = [MainFeedArticle]()
        self.MaxNumOfItems = 1
        self.storyFlags = [true]
    }
}

// --------------------------
class DP3_iPhoneStory_2colsImg: DP3_groupItem {
    // 2 stories in a row, 2 columns (image)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [true, true]
    }
}

class DP3_iPhoneStory_2colsTxt: DP3_groupItem {
    // 2 stories in a row, 2 columns (text)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [true, true]
    }
}

class DP3_iPhoneArticle_2colsImg: DP3_groupItem {
    // 2 articles in a row, 2 columns (image)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
}

class DP3_iPhoneArticleSplit_2colsImg: DP3_groupItem {
    // 2 articles in a row, 2 columns (image) - Split
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
}

class DP3_iPhoneArticle_2colsTxt: DP3_groupItem {
    // 2 articles in a row, 2 columns (text)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
}

class DP3_iPhoneArticleSplit_2colsTxt: DP3_groupItem {
    // 2 articles in a row, 2 columns (text) - Split
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
}
