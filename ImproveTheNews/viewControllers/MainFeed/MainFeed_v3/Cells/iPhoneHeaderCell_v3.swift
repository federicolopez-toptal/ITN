//
//  iPhoneHeaderCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import UIKit

class iPhoneHeaderCell_v3: UITableViewCell {

    static let identifier = "iPhoneHeaderCell_v3"

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
        self.titleLabel.font = CSS.shared.iPhoneHeader_font
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
//            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CSS.shared.iPhoneHeader_vMargins),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
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
        let W = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 2)
        return self.titleLabel.calculateHeightFor(width: W) + (CSS.shared.iPhoneHeader_vMargins * 2)
    }

}
