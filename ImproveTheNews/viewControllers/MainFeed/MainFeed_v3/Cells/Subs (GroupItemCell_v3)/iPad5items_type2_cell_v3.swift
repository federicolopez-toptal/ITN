//
//  iPad5items_type1_cell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2023.
//

import Foundation
import UIKit


class iPad5items_type2_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPad5items_type2_cell_v3"
    
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    var view3_heightConstraint: NSLayoutConstraint!
    var view4_heightConstraint: NSLayoutConstraint!
    var view5_heightConstraint: NSLayoutConstraint!


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
        
        let sep: CGFloat = 16
        let W = SCREEN_SIZE_iPadSideTab().width
        let colW: CGFloat = ceil(W * 0.24)
        
        let view1_width: CGFloat = SCREEN_SIZE_iPadSideTab().width - (colW*2) - (sep*4)
        // --------
        let view1_height: CGFloat = SCREEN_SIZE_iPadSideTab().height - (colW*2) - (sep*4)
        var minDim: CGFloat = view1_width
        if(view1_height < minDim){ minDim = view1_height }
        
        let view1 = iPadAllNews_vImgColBig_v3(width: view1_width, imageWidth: minDim)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sep),
            view1.widthAnchor.constraint(equalToConstant: view1_width)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        
        ///
        let view2 = iPhoneAllNews_vImgCol_v3_B(width: colW)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: sep),
            view2.widthAnchor.constraint(equalToConstant: colW)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        
        ///
        let view3 = iPhoneAllNews_vImgCol_v3_B(width: colW)
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: sep),
            view3.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            view3.widthAnchor.constraint(equalToConstant: colW)
        ])
        self.view3_heightConstraint = view3.heightAnchor.constraint(equalToConstant: 1)
        self.view3_heightConstraint.isActive = true
                        
        ///
        let view4 = iPhoneAllNews_vImgCol_v3_B(width: colW)
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view4.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: sep),
            view4.widthAnchor.constraint(equalToConstant: colW)
        ])
        self.view4_heightConstraint = view4.heightAnchor.constraint(equalToConstant: 1)
        self.view4_heightConstraint.isActive = true
        
        ///
        let view5 = iPhoneAllNews_vImgCol_v3_B(width: colW)
        self.contentView.addSubview(view5)
        view5.activateConstraints([
            view5.topAnchor.constraint(equalTo: view4.bottomAnchor, constant: sep),
            view5.leadingAnchor.constraint(equalTo: view4.leadingAnchor),
            view5.widthAnchor.constraint(equalToConstant: colW)
        ])
        self.view5_heightConstraint = view5.heightAnchor.constraint(equalToConstant: 1)
        self.view5_heightConstraint.isActive = true
        
        self.subViews.append(view1)
        self.subViews.append(view2)
        self.subViews.append(view3)
        self.subViews.append(view4)
        self.subViews.append(view5)
        
        //------------------------
        let line1View = UIView()
        self.contentView.addSubview(line1View)
        line1View.activateConstraints([
            line1View.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            line1View.trailingAnchor.constraint(equalTo: view2.trailingAnchor),
            line1View.topAnchor.constraint(equalTo: view2.bottomAnchor),
            line1View.heightAnchor.constraint(equalToConstant: 2)
        ])
        ADD_HDASHES(to: line1View)
            
        let line2View = UIView()
        self.contentView.addSubview(line2View)
        line2View.activateConstraints([
            line2View.leadingAnchor.constraint(equalTo: view4.leadingAnchor),
            line2View.trailingAnchor.constraint(equalTo: view4.trailingAnchor),
            line2View.topAnchor.constraint(equalTo: view4.bottomAnchor),
            line2View.heightAnchor.constraint(equalToConstant: 2)
        ])
        ADD_HDASHES(to: line2View)
    }

    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        
        view1_heightConstraint.constant = (self.subViews[0] as! iPadAllNews_vImgColBig_v3).calculateHeight()
        view2_heightConstraint.constant = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        view3_heightConstraint.constant = (self.subViews[2] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        view4_heightConstraint.constant = (self.subViews[3] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        view5_heightConstraint.constant = (self.subViews[4] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        
        for V in self.subViews {
            V.refreshDisplayMode()
        }
        
        //self.contentView.backgroundColor = .systemPink
    }
    
    // MARK: misc
    func calculateGroupHeight() -> CGFloat {
        let height_1 = (self.subViews[0] as! iPadAllNews_vImgColBig_v3).calculateHeight()
        let height_2 = (self.subViews[1] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        let height_3 = (self.subViews[2] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        let height_4 = (self.subViews[3] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
        let height_5 = (self.subViews[4] as! iPhoneAllNews_vImgCol_v3_B).calculateHeight()
    
        var result: CGFloat = height_1
        if(height_2 + height_3 > result){ result = height_2 + height_3 }
        if(height_4 + height_5 > result){ result = height_4 + height_5 }
        
        return result
    }

}

