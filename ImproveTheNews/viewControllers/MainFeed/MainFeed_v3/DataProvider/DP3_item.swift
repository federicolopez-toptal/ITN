//
//  DP3_item.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/10/2023.
//

import Foundation
import UIKit

// MARK: Plain Data Provider
class DP3_item {
}

////////////////////////////////////////////////////////////////////////
// MARK: Subclasses
class DP3_headerItem: DP3_item {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class DP3_splitHeaderItem: DP3_item {
    var leftTitle: String = ""
    var rightTitle: String = ""
    
    init(leftTitle: String, rightTitle: String) {
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
    }
}

// --------------------------
class DP3_spacer: DP3_item {
    var size: CGFloat = 1.0
    
    init(size: CGFloat) {
        self.size = size
    }
}

// --------------------------
class DP3_more: DP3_item {
    var topic = "news"
    var completed = false
    
    init(topic: String, completed: Bool) {
        self.topic = topic
        self.completed = completed
    }
}

// --------------------------
class DP3_text: DP3_item {
    var text: String = ""
    var alignment: NSTextAlignment = .center
   
    init(text: String, alignment: NSTextAlignment = .center) {
        self.text = text
        self.alignment = alignment
    }
}

class DP3_topics: DP3_item {
    var topics: [TopicSearchResult] = []
    
    init(topics: [TopicSearchResult]) {
        self.topics = topics
    }
}

// --------------------------
class DP3_footer: DP3_item {
}

// --------------------------
class DP3_banner: DP3_item {
}

// --------------------------
class DP3_controversy: DP3_item {
    var controversy: ControversyListItem
    
    init(controversy: ControversyListItem) {
        self.controversy = controversy
    }
}

class DP3_controversies_x2: DP3_item {
    var controversy1: ControversyListItem
    var controversy2: ControversyListItem?
    
    init(controversy1: ControversyListItem, controversy2: ControversyListItem?) {
        self.controversy1 = controversy1
        self.controversy2 = controversy2
    }
}
