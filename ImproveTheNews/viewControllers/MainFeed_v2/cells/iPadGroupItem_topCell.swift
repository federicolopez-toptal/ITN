//
//  iPadGroupItem_topCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit

class iPadGroupItem_topCell: GroupItemCell {

    static let identifier = "iPadGroupItem_topCell"

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
            view3.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.view3_heightConstraint = view3.heightAnchor.constraint(equalToConstant: 130)
        self.view3_heightConstraint.isActive = true
        self.subViews.append(view3)

        let view4 = ArticleHImageView()
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view4.topAnchor.constraint(equalTo: view3.bottomAnchor, constant: margin),
            view4.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.view4_heightConstraint = view4.heightAnchor.constraint(equalToConstant: 130)
        self.view4_heightConstraint.isActive = true
        self.subViews.append(view4)

        let view5 = ArticleVImageView()
        self.contentView.addSubview(view5)
        view5.activateConstraints([
            view5.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            view5.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: IPAD_ITEMS_SEP),
            view5.widthAnchor.constraint(equalTo: view2.widthAnchor)
        ])
        self.view5_heightConstraint = view5.heightAnchor.constraint(equalToConstant: 350)
        self.view5_heightConstraint.isActive = true

        self.subViews.append(view5)
    }

    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
        let count = group.articles.count
        
        if(3<=count) {
            let title = group.articles[3-1].title
            let newH = iPadGroupItem_topCell.calculateHeightFor(index: 3, text: title)
            view3_heightConstraint.constant = newH
        }
        if(4<=count) {
            let title = group.articles[4-1].title
            let newH = iPadGroupItem_topCell.calculateHeightFor(index: 4, text: title)
            view4_heightConstraint.constant = newH
        }
        if(count==5) {
            let title = group.articles[5-1].title
            let newH = iPadGroupItem_topCell.calculateHeightFor(index: 5, text: title)
            view5_heightConstraint.constant = newH
        }
    }
    
    static func calculateHeightFor(_ articles: [MainFeedArticle]) -> CGFloat {
        let count = articles.count
        let margin = IPAD_ITEMS_SEP
        var result: CGFloat = 1
        let extraMargin: CGFloat = 5.0
        
        if(1<=count || 2<=count) {
            result += 350 + (margin * 2)    // fijo
        }
        if(3<=count) {
            let title = articles[3-1].title
            let newH = iPadGroupItem_topCell.calculateHeightFor(index: 3, text: title)
            result += newH + margin
            //result += 130 + margin
        }
        
        if(count==4) {
            let title = articles[4-1].title
            let newH = iPadGroupItem_topCell.calculateHeightFor(index: 4, text: title)
            result += newH + margin
            //result += 130 + margin
        }
        else if(count==5) {
            let title3 = articles[3-1].title
            let H3 = iPadGroupItem_topCell.calculateHeightFor(index: 3, text: title3)

            let title4 = articles[4-1].title
            let H4 = iPadGroupItem_topCell.calculateHeightFor(index: 4, text: title4)

            let title5 = articles[5-1].title
            let H5 = iPadGroupItem_topCell.calculateHeightFor(index: 5, text: title5)

            let leftColumnH = 350 + (IPAD_ITEMS_SEP * 3) + H3 + H4
            let rightColumnH = 280 + (IPAD_ITEMS_SEP * 2) + H5

            if(leftColumnH > rightColumnH) {
                result = leftColumnH + margin
            } else {
                result = rightColumnH + margin
            }
        }
        
        result += extraMargin
        return result
    }
    
    static func calculateHeightFor(index: Int, text: String) -> CGFloat {
        var newH: CGFloat = 0
        let columnWith: CGFloat = 300
        
        if(index==3 || index==4) {
            let margin = IPAD_ITEMS_SEP
            let W: CGFloat = SCREEN_SIZE().width - columnWith - (margin * 3)
            newH = ArticleHImageView.calculateHeight(text: text, width: W)
        } else if(index == 5) {
            newH = ArticleVImageView.calculateHeight(text: text, width: columnWith)
        }
        
        return newH
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        //self.contentView.backgroundColor = .systemPink
    }

}

//static func getHeightForCount(_ count: Int) -> CGFloat { // OLD
//    let margin = IPAD_ITEMS_SEP
//    var result: CGFloat = 1
//    let extraMargin: CGFloat = 5.0
//
//    switch(count) {
//        case 1, 2:
//            result = 350 + (margin * 2) + extraMargin
//        case 3:
//            result = 350 + 130 + (margin * 3) + extraMargin
//        default:
//            result = 675
//    }
//
//    return result
//}
