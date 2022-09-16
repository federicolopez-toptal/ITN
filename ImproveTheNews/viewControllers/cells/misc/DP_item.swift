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
    var height: CGFloat?
    
    init(H: CGFloat?) {
        self.height = H
    }
}

class DP_header: DP_item {
    var text: String
    
    init(text: String, isHeadlines: Bool = false) {
        var mText = text
        if(isHeadlines){ mText = "LATEST " + text }
        
        self.text = mText
        super.init(H: HeaderCell.heigth)
    }
}

class DP_itemPointingData: DP_item {
    var topicIndex: Int
    var articleIndex: Int
    
    init(T: Int, A: Int, height: CGFloat?) {
        self.topicIndex = T
        self.articleIndex = A
        super.init(H: height)
    }
}

class DP_itemPointing_2Data: DP_item {
    var topicIndex_1: Int
    var articleIndex_1: Int
    var topicIndex_2: Int?
    var articleIndex_2: Int?
    
    init(T1: Int, A1: Int, T2: Int?, A2: Int?, height: CGFloat?) {
        self.topicIndex_1 = T1
        self.articleIndex_1 = A1
        self.topicIndex_2 = T2
        self.articleIndex_2 = A2
        super.init(H: height)
    }
}





class DP_Story: DP_itemPointingData { // Large story
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: StoryCell.heigth)
    }
}
class DP_Article: DP_itemPointingData { // wide article + image
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: nil)
    }
}
class DP_TextArticle: DP_itemPointingData { // wide article (text)
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: nil)
    }
}
class DP_TextStory: DP_itemPointingData { // wide story (text)
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: nil)
    }
}
class DP_Columns: DP_itemPointing_2Data { // 2 Columns
    init(T1 topicIndex1: Int, A1 articleIndex1: Int, T2 topicIndex2: Int?, A2 articleIndex2: Int?) {
        super.init(T1: topicIndex1, A1: articleIndex1, T2: topicIndex2, A2: articleIndex2, height: nil)
    }
}


