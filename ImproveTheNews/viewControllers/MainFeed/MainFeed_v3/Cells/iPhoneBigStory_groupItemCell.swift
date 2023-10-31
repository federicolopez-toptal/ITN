//
//  iPhoneBigStory_groupItemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import UIKit

class iPhoneBigStory_groupItemCell: GroupItemCell {

    static let identifier = "iPhoneBigStory_groupItemCell"
    private let WIDTH = SCREEN_SIZE().width
    
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
        self.subViews = [CustomCellView]()
        
        let view1 = BigStoryView(width: SCREEN_SIZE().width)
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
    
    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
                
        view1_heightConstraint.constant = (self.subViews[0] as! BigStoryView).calculateHeight()
        self.refreshDisplayMode()
    }
    
    func calculateGroupHeight() -> CGFloat {
        return (self.subViews[0] as! BigStoryView).calculateHeight()
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        for V in self.subViews {
            V.refreshDisplayMode()
        }
    }
}
