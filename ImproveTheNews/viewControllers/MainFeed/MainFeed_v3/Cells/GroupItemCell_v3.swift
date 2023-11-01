//
//  GroupItemCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit

class GroupItemCell_v3: UITableViewCell {

    var subViews = [CustomCellView_v3]()

    func populate(with group: DP3_groupItem) {
        var limit = group.articles.count
        if(limit > self.subViews.count){ limit = self.subViews.count }
        
        var count = 0
        for i in 0...limit-1 {
            let A = group.articles[i]
            self.subViews[i].show()
            self.subViews[i].populate(A)
            
            count += 1
        }
        
        if(count < self.subViews.count) {
            for i in count+1...self.subViews.count {
                self.subViews[i-1].hide()
            }
        }
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }

}
