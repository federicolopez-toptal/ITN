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
    
    init(text: String, isHeadlines: Bool = false) {
        var mText = text
        if(isHeadlines){ mText = "LATEST " + text }
        
        self.text = mText
    }
}

class DP_itemPointingData: DP_item {
    var topicIndex: Int
    var articleIndex: Int
    
    init(T: Int, A: Int) {
        self.topicIndex = T
        self.articleIndex = A
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
class DP_Story_CO: DP_itemPointingData { // story column
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
class DP_Article_CO: DP_itemPointingData { // article column
    override init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex)
    }
}


