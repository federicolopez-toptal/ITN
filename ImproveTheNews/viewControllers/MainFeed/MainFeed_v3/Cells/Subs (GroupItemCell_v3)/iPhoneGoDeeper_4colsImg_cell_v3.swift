//
//  iPhoneGoDeeper_4colsImg_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2023.
//

import Foundation
import UIKit


class iPhoneGoDeeper_4colsImg_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPhoneGoDeeper_4colsImg_cell_v3"
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    var view3_heightConstraint: NSLayoutConstraint!
    var view4_heightConstraint: NSLayoutConstraint!

    var bgViews = [UIView]()
    var bgViewsHeight = [NSLayoutConstraint]()

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
        let col_WIDTH: CGFloat = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 5))/4
        
        ///
        let view1 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view1.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
            self.createBackgroundViewFor(view1)
        
        ///
        let view2 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view2.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
            self.createBackgroundViewFor(view2)
        
        ///
        let view3 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view3.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view3.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view3_heightConstraint = view3.heightAnchor.constraint(equalToConstant: 1)
        self.view3_heightConstraint.isActive = true
        self.subViews.append(view3)
            self.createBackgroundViewFor(view3)
        
        ///
        let view4 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH)
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view4.leadingAnchor.constraint(equalTo: view3.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view4.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view4_heightConstraint = view4.heightAnchor.constraint(equalToConstant: 1)
        self.view4_heightConstraint.isActive = true
        self.subViews.append(view4)
            self.createBackgroundViewFor(view4)
    }
    
    func createBackgroundViewFor(_ refView: UIView) {
        let bgView = UIView()
        self.contentView.addSubview(bgView)
        bgView.activateConstraints([
            bgView.leadingAnchor.constraint(equalTo: refView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: refView.trailingAnchor),
            bgView.topAnchor.constraint(equalTo: refView.topAnchor)
        ])
        let bgHeight = bgView.heightAnchor.constraint(equalToConstant: 150)
        bgHeight.isActive = true
        self.bgViewsHeight.append(bgHeight)
        
        self.contentView.sendSubviewToBack(bgView)
        self.bgViews.append(bgView)
    }

    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        view3_heightConstraint.constant = (self.subViews[2] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        view4_heightConstraint.constant = (self.subViews[3] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        
        for _H in self.bgViewsHeight {
            _H.constant = self.calculateGroupHeight() - 16
        }
        
        for bgV in self.bgViews {
            bgV.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        }
        
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
        let height_1 = (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        let height_3 = (self.subViews[2] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        let height_4 = (self.subViews[3] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
    
        var result: CGFloat = 0
        if(height_1 > result) { result = height_1 }
        if(height_2 > result) { result = height_2 }
        if(height_3 > result) { result = height_3 }
        if(height_4 > result) { result = height_4 }
    
        return result
    }

}

