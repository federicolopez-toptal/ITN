//
//  DP_item.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import Foundation
import UIKit



// MARK: - Data Provider Item
class DP_item {
//    var height: CGFloat?
//
//    init(H: CGFloat?) {
//        self.height = H
//    }
}

class DP_header: DP_item {
    var text: String
    
    init(text: String, isHeadline: Bool = false) {
        var mText = text
        if(isHeadline){ mText = "LATEST " + text }
        
        self.text = mText
    }
}

class DP_splitHeader: DP_item {
    var leftText: String
    var rightText: String
    
    init(leftText: String, rightText: String) {
        self.leftText = leftText
        self.rightText = rightText
    }
}

class DP_more: DP_item {
    var topic: String
    
    init(topic: String) {
        self.topic = topic
    }
}

class DP_footer: DP_item {
}

class DP_itemPointingData: DP_item {
    var topicIndex: Int
    var articleIndex: Int
    
    init(T: Int, A: Int) {
        self.topicIndex = T
        self.articleIndex = A
    }
}

class DP_banner: DP_item {
    var bannerIndex: Int
    
    init(index B: Int) {
        self.bannerIndex = B
    }
}

// --------
class DP_Story_BI: DP_itemPointingData { // Big Story with image
    override init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex)
    }
}
class DP_Story_WT: DP_itemPointingData { // wide story (only text)
    override init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex)
    }
}
class DP_Article_WI: DP_itemPointingData { // Wide article with image
    override init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex)
    }
}
class DP_Article_WT: DP_itemPointingData { // wide article (only text)
    override init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex)
    }
}

// --------
class DP_Story_CI: DP_itemPointingData { // story column (with image)
    var column: Int
    init(T topicIndex: Int, A articleIndex: Int, column: Int) {
        self.column = column
        super.init(T: topicIndex, A: articleIndex)
    }
}
class DP_Story_CT: DP_itemPointingData { // story column (only text)
    var column: Int
    init(T topicIndex: Int, A articleIndex: Int, column: Int) {
        self.column = column
        super.init(T: topicIndex, A: articleIndex)
    }
}

class DP_Article_CI: DP_itemPointingData { // article column (with image)
    var column: Int
    init(T topicIndex: Int, A articleIndex: Int, column: Int) {
        self.column = column
        super.init(T: topicIndex, A: articleIndex)
    }
}
class DP_Article_CT: DP_itemPointingData { // article column (only text)
    var column: Int
    init(T topicIndex: Int, A articleIndex: Int, column: Int) {
        self.column = column
        super.init(T: topicIndex, A: articleIndex)
    }
}


