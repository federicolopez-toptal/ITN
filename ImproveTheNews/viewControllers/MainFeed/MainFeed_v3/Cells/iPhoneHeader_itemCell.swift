//
//  iPhoneHeader_itemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import UIKit

class iPhoneHeader_itemCell: UITableViewCell {

    static let identifier = "iPhoneHeader_itemCell"

    let titleLabel = UILabel()


    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        self.titleLabel.font = CSS.shared.header_font
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CSS.shared.header_padding),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.left_padding)
        ])
    }
    
    func populate(with item: DataProviderHeaderItem) {
        self.titleLabel.text = item.title
        self.refreshDisplayMode()
    }
    
    func populate(with item: DP3_headerItem) {
        self.titleLabel.text = item.title
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.titleLabel.textColor = CSS.shared.displayMode().header_textColor
    }
    
    func calculateHeight() -> CGFloat {
        let W = SCREEN_SIZE().width - (CSS.shared.left_padding * 2)
        return CSS.shared.header_padding + self.titleLabel.calculateHeightFor(width: W) + CSS.shared.header_padding
    }

}
