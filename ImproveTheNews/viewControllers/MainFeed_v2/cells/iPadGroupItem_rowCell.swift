//
//  iPadGroupItem_rowCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit

class iPadGroupItem_rowCell: GroupItemCell {

    static let identifier = "iPadGroupItem_rowCell"

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
        
        
        let view2 = ArticleBigImageView()
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view2.widthAnchor.constraint(equalToConstant: columnWith),
            view2.heightAnchor.constraint(equalToConstant: 280)
            
        ])
        
        let view1 = ArticleBigImageView()
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view1.trailingAnchor.constraint(equalTo: view2.leadingAnchor, constant: -margin),
            view1.heightAnchor.constraint(equalToConstant: 350)
        ])
        self.subViews.append(view1)
        self.subViews.append(view2)

        let view3 = ArticleHImageView()
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view3.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: margin),
            view3.heightAnchor.constraint(equalToConstant: 120),
            view3.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.subViews.append(view3)
    }

}
