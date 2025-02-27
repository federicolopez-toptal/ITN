//
//  iPadStory_2colsImg_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2023.
//

import Foundation
import UIKit


class iPadStory_2colsImg_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPadStory_2colsImg_cell_v3"
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!

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
        
        //var col_WIDTH: CGFloat = (SCREEN_SIZE().width - 40 - CSS.shared.iPhoneSide_padding)/2
        let col_WIDTH: CGFloat = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding*3))/2
        
        ///
        let view1 = iPhoneAllNews_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view1.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        ///
        let view2 = iPhoneAllNews_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            view2.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
    }

    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        
        for V in self.subViews {
            V.refreshDisplayMode()
        }
    }
    
    // MARK: misc
    func calculateGroupHeight() -> CGFloat {
        let height_1 = (self.subViews[0] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
    
        return (height_1 > height_2) ? height_1 : height_2
    }

}

