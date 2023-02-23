//
//  iPadGroupItem_topCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit

class iPadGroupItem_topCell: UITableViewCell {

    static let identifier = "iPadGroupItem_topCell"
    var subViews = [CustomCellView]()

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
        let columnWith: CGFloat = 275
        
        
        let view2 = ArticleBigImageView()
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view2.widthAnchor.constraint(equalToConstant: columnWith),
            view2.heightAnchor.constraint(equalToConstant: 250)
            
        ])
        
        let view1 = ArticleBigImageView()
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            view1.trailingAnchor.constraint(equalTo: view2.leadingAnchor, constant: -margin),
            view1.heightAnchor.constraint(equalToConstant: 330)
        ])
        self.subViews.append(view1)
        self.subViews.append(view2)

        let view3 = ArticleBigImageView()
        self.contentView.addSubview(view3)
        view3.activateConstraints([
            view3.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view3.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: margin),
            view3.heightAnchor.constraint(equalToConstant: 200),
            view3.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.subViews.append(view3)

        let view4 = ArticleBigImageView()
        self.contentView.addSubview(view4)
        view4.activateConstraints([
            view4.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view4.topAnchor.constraint(equalTo: view3.bottomAnchor, constant: margin),
            view4.heightAnchor.constraint(equalToConstant: 200),
            view4.widthAnchor.constraint(equalTo: view1.widthAnchor)
        ])
        self.subViews.append(view4)

        let view5 = ArticleBigImageView()
        self.contentView.addSubview(view5)
        view5.activateConstraints([
            view5.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            view5.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: IPAD_ITEMS_SEP),
            view5.heightAnchor.constraint(equalToConstant: 250),
            view5.widthAnchor.constraint(equalTo: view2.widthAnchor)
        ])
        self.subViews.append(view5)
        
        view3.hide()
        view4.hide()
    }
    
    func populate(with group: DataProviderGroupItem) {
        var limit = group.articles.count
        if(limit > self.subViews.count){ limit = self.subViews.count }
        
        var count = 0
        for i in 0...limit-1 {
            let A = group.articles[i]
            self.subViews[i].populate(A)
            
            count += 1
        }
        
        if(count < self.subViews.count) {
            for i in count+1...self.subViews.count {
                self.subViews[i-1].hide()
            }
        }
        
        self.refreshDisplayMode()
    }

    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }


//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
