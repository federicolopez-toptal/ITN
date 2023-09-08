//
//  iPadGroupItem_topCellText.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadGroupItem_topCellText: GroupItemCell {

    static let identifier = "iPadGroupItem_topCellText"

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
        self.subViews = [CustomCellView]()
        
        let margin = IPAD_ITEMS_SEP
        let columnWith: CGFloat = 300
        let sizeBig: CGFloat = 215
        let sizeSmall: CGFloat = 120
        
        let view2 = ArticleBigTextView()
        view2.setFontSize(20)
        view2.setSourcesLimit(3)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view2.widthAnchor.constraint(equalToConstant: columnWith),
            view2.heightAnchor.constraint(equalToConstant: sizeBig)
        ])
        
        let view1 = ArticleBigTextView()
        view1.setFontSize(24)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view1.trailingAnchor.constraint(equalTo: view2.leadingAnchor, constant: -margin),
            view1.heightAnchor.constraint(equalToConstant: sizeBig)
        ])
        self.subViews.append(view1)
        self.subViews.append(view2)

        let view3 = ArticleBigTextView()
        view3.setFontSize(20)
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view3.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: margin),
            view3.widthAnchor.constraint(equalTo: view1.widthAnchor),
            view3.heightAnchor.constraint(equalToConstant: sizeSmall),
        ])
        self.subViews.append(view3)

        let view4 = ArticleBigTextView()
        view4.setFontSize(20)
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view4.topAnchor.constraint(equalTo: view3.bottomAnchor, constant: margin),
            view4.heightAnchor.constraint(equalToConstant: sizeSmall),
            view4.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.subViews.append(view4)

        let view5 = ArticleBigTextView()
        view5.setFontSize(20)
        self.contentView.addSubview(view5)
        view5.activateConstraints([
            view5.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            view5.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: IPAD_ITEMS_SEP),
            view5.heightAnchor.constraint(equalToConstant: (sizeSmall*2)+margin),
            view5.widthAnchor.constraint(equalTo: view2.widthAnchor)
        ])
        self.subViews.append(view5)
    }

    static func getHeightForCount(_ count: Int) -> CGFloat {
        let margin = IPAD_ITEMS_SEP
        var result: CGFloat = 1
        let extraMargin: CGFloat = 5.0
        
        switch(count) {
            case 1, 2:
                result = 215 + (margin * 2) + extraMargin
            case 3:
                result = 215 + 120 + (margin * 3) + extraMargin
            default:
                result = 215 + (120*2) + (margin * 4) + extraMargin
        }

        return result
    }
    
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }

}
