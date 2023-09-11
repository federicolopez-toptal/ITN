//
//  iPadGroupItem_splitCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/02/2023.
//

import UIKit

class iPadGroupItem_splitCell: GroupItemCell {

    static let identifier = "iPadGroupItem_splitCell"

    let vLine = UIView()
    
    
    
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
        
        let hStack = HSTACK(into: self.contentView)
        hStack.backgroundColor = .clear //.green
        hStack.spacing = margin
        hStack.distribution = .fillEqually
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            hStack.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        let view1 = ArticleVImageView()
        hStack.addArrangedSubview(view1)
        view1.activateConstraints([
            view1.heightAnchor.constraint(equalToConstant: 350)
        ])
        self.subViews.append(view1)
        
        let view2 = ArticleVImageView()
        hStack.addArrangedSubview(view2)
        view2.activateConstraints([
            view2.heightAnchor.constraint(equalToConstant: 350)
        ])
        self.subViews.append(view2)
        
        self.contentView.addSubview(self.vLine)
        self.vLine.activateConstraints([
            self.vLine.widthAnchor.constraint(equalToConstant: 1.5),
            self.vLine.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.vLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0x1D242F).withAlphaComponent(0.2)
    }

}
