//
//  iPadGroupItem_rowCellText.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPadGroupItem_rowCellText: GroupItemCell {

    static let identifier = "iPadGroupItem_rowCellText"

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
        let rowHeight: CGFloat = 250
        
        let hStack = HSTACK(into: self.contentView)
        hStack.backgroundColor = .clear //.green
        hStack.spacing = margin
        hStack.distribution = .fillEqually
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            hStack.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
        
        let view1 = ArticleBigTextView()
        view1.setFontSize(20)
        view1.setSourcesLimit(3)
        hStack.addArrangedSubview(view1)
        view1.activateConstraints([
            view1.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
        self.subViews.append(view1)
        
        let view2 = ArticleBigTextView()
        view2.setFontSize(20)
        view2.setSourcesLimit(3)
        hStack.addArrangedSubview(view2)
        view2.activateConstraints([
            view2.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
        self.subViews.append(view2)
        
        let view3 = ArticleBigTextView()
        view3.setFontSize(20)
        view3.setSourcesLimit(3)
        hStack.addArrangedSubview(view3)
        view3.activateConstraints([
            view3.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
        self.subViews.append(view3)
    }

}
