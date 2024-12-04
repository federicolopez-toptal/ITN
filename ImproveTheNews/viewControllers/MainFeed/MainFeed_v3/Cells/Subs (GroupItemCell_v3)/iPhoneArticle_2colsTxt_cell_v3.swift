//
//  iPhoneArticle_2colsTxt_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit


class iPhoneArticle_2colsTxt_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPhoneArticle_2colsTxt_cell_v3"
    var isBanner = false
    var checkSplit = false
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    var vLine = UIView()

    var customPopulate = false

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        self.subViews = [CustomCellView_v3]()
        var col_WIDTH: CGFloat = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 3))/2
        if(IPAD()){
            col_WIDTH = ((SCREEN_SIZE_iPadSideTab().width) - (CSS.shared.iPhoneSide_padding * 4))/2
        }
        
        ///
        let view1 = iPhoneAllNews_vTxtCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view1.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        ///
        let view2 = iPhoneAllNews_vTxtCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            view2.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
        
        self.vLine = VLINE(into: self.contentView)
        self.vLine.activateConstraints([
            self.vLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    // MARK: Overrides
    func customPopulate(with group: DP3_groupItem) {
        // ------ (super.populate(with: group)
        var limit = group.articles.count
        if(limit > self.subViews.count){ limit = self.subViews.count }
        
        var count = 0
        for i in 0...limit-1 {
            let A = group.articles[i]
            let V = self.subViews[i]
            
            V.show()
//            self.subViews[i].populate(A)
            if(V is iPhoneAllNews_vTxtCol_v3) {
                (V as! iPhoneAllNews_vTxtCol_v3).customPopulate(A)
            }
            
            if(A.isEmpty()) {
                V.hide()
            }
            
            count += 1
        }
        
        if(count < self.subViews.count) {
            for i in count+1...self.subViews.count {
                self.subViews[i-1].hide()
            }
        }
        
        self.vLine.hide()
        self.refreshDisplayMode()
        // ------
    }
    
    override func populate(with group: DP3_groupItem) {
        if(self.customPopulate) {
            self.customPopulate(with: group)
            return
        }
        
        super.populate(with: group)
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneAllNews_vTxtCol_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneAllNews_vTxtCol_v3).calculateHeight()
        
        if(self.checkSplit) {
            if(MUST_SPLIT_B() == 0) {
                self.vLine.hide()
            } else {
                self.vLine.show()
            }
        } else {
            self.vLine.hide()
        }
        
        self.refreshDisplayMode()
        if(self.checkSplit) {
            if(MUST_SPLIT_B() > 0) {
                ADD_VDASHES(to: self.vLine, height: self.calculateGroupHeight())
            }
        }

    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        
        for V in self.subViews {
            V.refreshDisplayMode()
        }
        
        self.vLine.backgroundColor = CSS.shared.displayMode().line_color        
    }
    
    // MARK: misc
    func calculateGroupHeight() -> CGFloat {
        let height_1 = (self.subViews[0] as! iPhoneAllNews_vTxtCol_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneAllNews_vTxtCol_v3).calculateHeight()
    
        return (height_1 > height_2) ? height_1 : height_2
    }

}
