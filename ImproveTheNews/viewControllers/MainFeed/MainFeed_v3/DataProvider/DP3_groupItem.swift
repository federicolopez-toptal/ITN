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
class DP3_iPhoneStory_1Wide: DP3_groupItem {

    // 1 big/wide story (image & text versions)
    override init() {
        super.init()
        
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 1
        self.storyFlags = [true]
    }
}

class DP3_iPhoneStory_2cols: DP3_groupItem {
    // 2 stories in a row, 2 columns (image & text versions)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [true, true]
    }
}

class DP3_iPhoneStory_4cols: DP3_groupItem {
    // 4 stories in a row, 4 columns (image & text versions)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 4
        self.storyFlags = [true, true, true, true]
    }
}

// --------------------------
class DP3_iPhoneArticle_2cols: DP3_groupItem {
    // 2 articles in a row, 2 columns (image & text versions)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 2
        self.storyFlags = [false, false]
    }
}

class DP3_iPhoneArticle_4cols: DP3_groupItem {
    // 4 articles in a row, 4 columns (image & text versions)
    override init() {
        super.init()
        self.articles = [MainFeedArticle]()
        
        self.MaxNumOfItems = 4
        self.storyFlags = [false, false, false, false]
    }
}

// --------------------------
class DP3_iPad5items: DP3_groupItem {
    // 3 stories (1 big) + 2 articles
    var type = 1
    
    init(type: Int = 1) {
        super.init()
        
        self.type = type
        self.MaxNumOfItems = 6
        self.storyFlags = [true, true, true, true, true, true]
    }
}
