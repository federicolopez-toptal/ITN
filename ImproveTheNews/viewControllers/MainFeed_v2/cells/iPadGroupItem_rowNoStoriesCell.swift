//
//  iPadGroupItem_rowNoStoriesCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/04/2023.
//

import UIKit

class iPadGroupItem_rowNoStoriesCell: GroupItemCell {

    static let identifier = "iPadGroupItem_rowNoStoriesCell"

    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!

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
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor)
            //hStack.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        let view1 = ArticleVImageView()
        hStack.addArrangedSubview(view1)
        view1.activateConstraints([
            /* ... */
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 350)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        let view2 = ArticleVImageView()
        hStack.addArrangedSubview(view2)
        view2.activateConstraints([
            /* ... */
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 350)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
    }
    
    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
        var maxH: CGFloat = 0
        
        for i in 1...group.articles.count {
            let title = group.articles[i-1].title
            let H = iPadGroupItem_rowNoStoriesCell.calculateHeightForItemWith(text: title)
            
            if(H>maxH) {
                maxH = H
            }
        }
        
        view1_heightConstraint.constant = maxH
        view2_heightConstraint.constant = maxH
    }
    
    static func calculateHeightFor(_ articles: [MainFeedArticle]) -> CGFloat {
        var maxH: CGFloat = 0
        let extraMargin: CGFloat = 5.0
        
        for i in 1...articles.count {
            let title = articles[i-1].title
            let H = iPadGroupItem_rowNoStoriesCell.calculateHeightForItemWith(text: title)
            
            if(H>maxH) {
                maxH = H
            }
        }
        
        return maxH + IPAD_ITEMS_SEP + extraMargin
    }
    
    ////////////
    static func calculateHeightForItemWith(text: String) -> CGFloat {
        let W: CGFloat = ( SCREEN_SIZE().width - (IPAD_ITEMS_SEP*3) )/2
        let newH = ArticleVImageView.calculateHeight(text: text, width: W)
        return newH
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
    }

}
