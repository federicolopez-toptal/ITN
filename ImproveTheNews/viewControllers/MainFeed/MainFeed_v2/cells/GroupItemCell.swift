//
//  GroupItemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit

class GroupItemCell: UITableViewCell {

    var subViews = [CustomCellView]()

    func populate(with group: DataProviderGroupItem) {
        var limit = group.articles.count
        if(limit > self.subViews.count){ limit = self.subViews.count }
        
        var count = 0
        for i in 0...limit-1 {
            let A = group.articles[i]
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
    
    func populate(with group: DP3_groupItem) {
        var limit = group.articles.count
        if(limit > self.subViews.count){ limit = self.subViews.count }
        
        var count = 0
        for i in 0...limit-1 {
            let A = group.articles[i]
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
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }

}
