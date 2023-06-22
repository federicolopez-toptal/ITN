//
//  iPhoneGroupItem_1AR_Cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/06/2023.
//

import UIKit

class iPhoneGroupItem_1AR_Cell: GroupItemCell {

    static let identifier = "iPhoneGroupItem_1AR_Cell"
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
        
        let view1 = ArticleHImageView()
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            view1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
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
        let newH = iPhoneGroupItem_1AR_Cell.calculateHeightFor(text: title)
        view1_heightConstraint.constant = newH
    }
    
    static func calculateHeightFor(_ articles: [MainFeedArticle]) -> CGFloat {
        let title = articles[0].title
        let newH = iPhoneGroupItem_1AR_Cell.calculateHeightFor(text: title)
        return newH
    }
    
    static func calculateHeightFor(text: String) -> CGFloat {
        return ArticleHImageView.calculateHeight(text: text, width: SCREEN_SIZE().width-15)
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        //self.contentView.backgroundColor = .green
    }

}
