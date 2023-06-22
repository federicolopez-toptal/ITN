//
//  HeaderCell_v2.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit

class iPadHeaderCell: UITableViewCell {

    static let identifier = "iPadHeaderCell"

    let titleLabel = ARTICLE_TITLE()

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        self.titleLabel.font = IPHONE() ? MERRIWEATHER_BOLD(13) : MERRIWEATHER_BOLD(27)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: IPAD_INNER_MARGIN)
        ])
        
        if(IPHONE()) {
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        } else {
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
    }
    
    func populate(with item: DataProviderHeaderItem) {
        self.titleLabel.text = item.title
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)        
    }

}
