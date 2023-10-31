//
//  iPadGroupItem_splitStoriesCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadGroupItem_splitStoriesCell: GroupItemCell {

    static let identifier = "iPadGroupItem_splitStoriesCell"

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
        let margin = IPAD_ITEMS_SEP
        
        let vStack = VSTACK(into: self.contentView)
        vStack.backgroundColor = .clear //.green
        vStack.spacing = margin
        vStack.distribution = .fillEqually
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin)
        ])
        
        for _ in 1...4 {
            let view = ArticleBigImageView()
            
            vStack.addArrangedSubview(view)
            view.activateConstraints([
                view.heightAnchor.constraint(equalToConstant: 350)
            ])
            self.subViews.append(view)
        }
    }


    static func getHeightForCount(_ count: Int) -> CGFloat {
        let margin = IPAD_ITEMS_SEP
        let _count = CGFloat(count)
        
        return (350 * _count) + (margin*(_count+1))
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }
}
