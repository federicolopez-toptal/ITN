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

class DP3_spacer: DP3_item {
    var size: CGFloat = 1.0
    
    init(size: CGFloat) {
        self.size = size
    }
}

class DP3_more: DP3_item {
    var topic = "news"
    var completed = false
    
    init(topic: String, completed: Bool) {
        self.topic = topic
        self.completed = completed
    }
}

class DP3_footer: DP3_item {
}




class DP3_banner: DP3_item {
}
