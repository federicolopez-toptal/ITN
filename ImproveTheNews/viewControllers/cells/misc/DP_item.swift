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




class DP_Story: DP_itemPointingData {
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: StoryCell.heigth)
    }
}
class DP_Article: DP_itemPointingData {
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: nil)
    }
}
class DP_TextArticle: DP_itemPointingData {
    init(T topicIndex: Int, A articleIndex: Int) {
        super.init(T: topicIndex, A: articleIndex, height: nil)
    }
}
