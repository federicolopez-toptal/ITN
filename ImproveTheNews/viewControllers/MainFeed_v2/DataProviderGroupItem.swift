//
//  DataProviderGroupItem.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation

// MARK: Base class
class DataProviderGroupItem {
    var MaxNumOfItems = 1
    var storyFlags = [Bool]()
    
    var articles = [MainFeedArticle]()
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
