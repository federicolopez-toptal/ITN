//
//  DP3_iPhoneStory_vText.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import UIKit

class iPhoneStory_vTxt_cell_v3: GroupItemCell_v3 {

    static let identifier = "iPhoneStory_vTxt_cell_v3"
    var view1_heightConstraint: NSLayoutConstraint!
    
    
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
        
        ///
        let view1 = iPhoneStory_vTxt_v3(width: SCREEN_SIZE().width)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
    }
    
    // MARK: Overrides
    override func populate(with group: DP3_groupItem) {
        super.populate(with: group)
        view1_heightConstraint.constant = (self.subViews[0] as! iPhoneStory_vTxt_v3).calculateHeight()
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
        return (self.subViews[0] as! iPhoneStory_vTxt_v3).calculateHeight()
    }
}
