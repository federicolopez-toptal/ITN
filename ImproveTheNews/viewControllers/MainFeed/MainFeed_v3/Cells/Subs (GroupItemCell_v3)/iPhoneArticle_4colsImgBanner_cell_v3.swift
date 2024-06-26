//
//  iPhoneArticle_4colsImg_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/11/2023.
//

import Foundation
import UIKit


class iPhoneArticle_4colsImgBanner_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPhoneArticle_4colsImgBanner_cell_v3"
    var isBanner = false
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    var view3_heightConstraint: NSLayoutConstraint!
    var view4_heightConstraint: NSLayoutConstraint!
    var vLine = UIView()

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
        
        let sep = CSS.shared.iPhoneSide_padding
        let col_WIDTH = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 5))/4
        
        ///
        let view1 = iPhoneBannerPodCast_v3(width: col_WIDTH)
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
        let view2 = iPhoneAllNews_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view2.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
        
        ///
        let view3 = iPhoneAllNews_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view3.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view3.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view3_heightConstraint = view3.heightAnchor.constraint(equalToConstant: 1)
        self.view3_heightConstraint.isActive = true
        self.subViews.append(view3)
        
        ///
        let view4 = iPhoneAllNews_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view4.leadingAnchor.constraint(equalTo: view3.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view4.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view4_heightConstraint = view4.heightAnchor.constraint(equalToConstant: 1)
        self.view4_heightConstraint.isActive = true
        self.subViews.append(view4)
        
        // --------------------------
        self.vLine = VLINE(into: self.contentView)
        self.vLine.activateConstraints([
            self.vLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneBannerPodCast_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        view3_heightConstraint.constant = (self.subViews[2] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        view4_heightConstraint.constant = (self.subViews[3] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        
        if(MUST_SPLIT() == 0) {
            self.vLine.hide()
        } else {
            self.vLine.show()
        }
        
        self.refreshDisplayMode()
        if(MUST_SPLIT() > 0) {
            ADD_VDASHES(to: self.vLine, height: self.calculateGroupHeight())
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
        let height_1 = (self.subViews[0] as! iPhoneBannerPodCast_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        let height_3 = (self.subViews[2] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
        let height_4 = (self.subViews[3] as! iPhoneAllNews_vImgCol_v3).calculateHeight()
    
        var result: CGFloat = 0
        if(height_1 > result) { result = height_1 }
        if(height_2 > result) { result = height_2 }
        if(height_3 > result) { result = height_3 }
        if(height_4 > result) { result = height_4 }
    
        result += 22
        return result
    }

}
