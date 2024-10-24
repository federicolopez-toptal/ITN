//
//  iPhoneGroupItem_1ST_Cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/06/2023.
//

import UIKit

class iPhoneGroupItem_1ST_Cell: GroupItemCell {

    static let identifier = "iPhoneGroupItem_1ST_Cell"
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
        
        let view1 = ArticleBigTextView()
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            view1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 130)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
    }
    
    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
        
        let title = group.articles[0].title
        let newH = iPhoneGroupItem_1ST_Cell.calculateHeightFor(text: title)
        view1_heightConstraint.constant = newH
    }
    
    static func calculateHeightFor(_ articles: [MainFeedArticle]) -> CGFloat {
        let title = articles[0].title
        let newH = iPhoneGroupItem_1ST_Cell.calculateHeightFor(text: title)
        return newH
    }
    
    static func calculateHeightFor(text: String) -> CGFloat {
        return ArticleBigTextView.calculateHeight2(text: text, isStory: true, width: SCREEN_SIZE().width-0)
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }

    func highlight(text T: String) {
        if let _view1 = self.subViews[0] as? ArticleBigTextView {
            _view1.highlight(subtext: T)
        }
    }

}
