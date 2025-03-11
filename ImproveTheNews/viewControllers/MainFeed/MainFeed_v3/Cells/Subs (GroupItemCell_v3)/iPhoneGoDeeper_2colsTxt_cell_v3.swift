//
//  iPhoneGoDeeper_2colsTxt_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2023.
//

import Foundation
import UIKit


class iPhoneGoDeeper_2colsTxt_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPhoneGoDeeper_2colsTxt_cell_v3"
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!

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
        
        let col_WIDTH: CGFloat = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 3))/2
        
        ///
        let view1 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH, imgHeight: 0)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            view1.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
            let bgView1 = UIView()
            self.contentView.addSubview(bgView1)
            bgView1.activateConstraints([
                bgView1.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
                bgView1.trailingAnchor.constraint(equalTo: view1.trailingAnchor),
                bgView1.topAnchor.constraint(equalTo: view1.topAnchor)
            ])
            let bgHeight1 = bgView1.heightAnchor.constraint(equalToConstant: 150)
            bgHeight1.isActive = true
            self.bgViewsHeight.append(bgHeight1)
            
            self.contentView.sendSubviewToBack(bgView1)
            self.bgViews.append(bgView1)
        
        ///
        let view2 = iPhoneGoDeeper_vImgCol_v3(width: col_WIDTH, imgHeight: 0)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            view2.widthAnchor.constraint(equalToConstant: col_WIDTH)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
        
            let bgView2 = UIView()
            self.contentView.addSubview(bgView2)
            bgView2.activateConstraints([
                bgView2.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
                bgView2.trailingAnchor.constraint(equalTo: view2.trailingAnchor),
                bgView2.topAnchor.constraint(equalTo: view2.topAnchor)
            ])
            let bgHeight2 = bgView2.heightAnchor.constraint(equalToConstant: 150)
            bgHeight2.isActive = true
            self.bgViewsHeight.append(bgHeight2)
            
            self.contentView.sendSubviewToBack(bgView2)
            self.bgViews.append(bgView2)
    }

    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        
        for _H in self.bgViewsHeight {
            _H.constant = self.calculateGroupHeight() - 16
        }
        
        let height_1 = (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()

        if(height_1 < height_2) {
            let diff = height_2 - height_1
            (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).addComponentsSeparation(diff)
        } else {
            let diff = height_1 - height_2
            (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).addComponentsSeparation(diff)
        }
        
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        
        for V in self.subViews {
            V.refreshDisplayMode()
        }
        
        for bgV in self.bgViews {
            bgV.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
//            bgV.backgroundColor = .green
        }
    }
    
    // MARK: misc
    func calculateGroupHeight() -> CGFloat {
        let height_1 = (self.subViews[0] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneGoDeeper_vImgCol_v3).calculateHeight()
    
        return (height_1 > height_2) ? height_1 : height_2
    }

}

