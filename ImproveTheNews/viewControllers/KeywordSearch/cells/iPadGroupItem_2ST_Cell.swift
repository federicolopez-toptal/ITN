//
//  iPadGroupItem_2ST_Cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/07/2023.
//

import UIKit

class iPadGroupItem_2ST_Cell: GroupItemCell {

    static let identifier = "iPadGroupItem_2ST_Cell"
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
        
        let W: CGFloat = SCREEN_SIZE().width - (20*3)
        
        let view1 = ArticleVImageView()
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.widthAnchor.constraint(equalToConstant: W/2)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 350)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        let view2 = ArticleVImageView()
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 20),
            view2.topAnchor.constraint(equalTo: view1.topAnchor),
            view2.widthAnchor.constraint(equalToConstant: W/2)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 350)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
    }
    
    override func populate(with group: DataProviderGroupItem) {
        super.populate(with: group)
//        let title = group.articles[0].title
//        let newH = iPhoneGroupItem_1ST_Cell.calculateHeightFor(text: title)
//        view1_heightConstraint.constant = newH
    }
    
    override func refreshDisplayMode() {
        super.refreshDisplayMode()
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }

    func highlight(text T: String) {
        for subView in self.subViews {
            if let _view = subView as? ArticleVImageView {
                _view.highlight(subtext: T)
            }
        }
    }

}
