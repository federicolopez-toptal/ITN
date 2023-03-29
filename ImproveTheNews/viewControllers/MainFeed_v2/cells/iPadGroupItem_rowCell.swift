//
//  iPadGroupItem_rowCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit

class iPadGroupItem_rowCell: GroupItemCell {

    static let identifier = "iPadGroupItem_rowCell"

    var hStack_heightConstraint: NSLayoutConstraint!
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    var view3_heightConstraint: NSLayoutConstraint!
    

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
        ])
//        self.hStack_heightConstraint = hStack.heightAnchor.constraint(equalToConstant: 350)
//        self.hStack_heightConstraint.isActive = true
        
        
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
        
        let view3 = ArticleVImageView()
        hStack.addArrangedSubview(view3)
        view3.activateConstraints([
            /* ... */
        ])
        self.view3_heightConstraint = view3.heightAnchor.constraint(equalToConstant: 350)
        self.view3_heightConstraint.isActive = true
        self.subViews.append(view3)
    }
    
    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
        
//        for i in 1...group.articles.count {
//            let title = group.articles[i-1].title
//            let newH = iPadGroupItem_rowCell.calculateHeightForItemWith(text: title)
//
//            if(i==1) {
//                view1_heightConstraint.constant = newH
//            } else if(i==2) {
//                view2_heightConstraint.constant = newH
//            } else {
//                view3_heightConstraint.constant = newH
//            }
//        }

        var maxH: CGFloat = 0
        
        for i in 1...group.articles.count {
            let title = group.articles[i-1].title
            let H = iPadGroupItem_rowCell.calculateHeightForItemWith(text: title)
            
            if(H>maxH) {
                maxH = H
            }
        }
        
        view1_heightConstraint.constant = maxH
        view2_heightConstraint.constant = maxH
        view3_heightConstraint.constant = maxH
    }
    
    static func calculateHeightFor(_ articles: [MainFeedArticle]) -> CGFloat {
        var maxH: CGFloat = 0
        let extraMargin: CGFloat = 5.0
        
        for i in 1...articles.count {
            let title = articles[i-1].title
            let H = iPadGroupItem_rowCell.calculateHeightForItemWith(text: title)
            
            if(H>maxH) {
                maxH = H
            }
        }
        
        return maxH + IPAD_ITEMS_SEP + extraMargin
    }
    
    ////////////
    static func calculateHeightForItemWith(text: String) -> CGFloat {
        let W: CGFloat = ( SCREEN_SIZE().width - (IPAD_ITEMS_SEP*4) )/3
        let newH = ArticleVImageView.calculateHeight(text: text, width: W)
        return newH
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        //self.backgroundColor = .green
    }

}
