//
//  iPhoneSplitHeaderCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/11/2023.
//

import UIKit

class iPhoneSplitHeaderCell_v3: UITableViewCell {

    static let identifier = "iPhoneSplitHeaderCell_v3"

    let leftLabel = UILabel()
    let rightLabel = UILabel()
    var vLine = UIView()
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        let W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding*3))/2
    
        self.leftLabel.font = CSS.shared.iPhoneHeader_font
        self.leftLabel.textAlignment = .center
        self.contentView.addSubview(self.leftLabel)
        self.leftLabel.activateConstraints([
            self.leftLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.leftLabel.widthAnchor.constraint(equalToConstant: W),
            self.leftLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.rightLabel.font = CSS.shared.iPhoneHeader_font
        self.rightLabel.textAlignment = .center
        self.contentView.addSubview(self.rightLabel)
        self.rightLabel.activateConstraints([
            self.rightLabel.leadingAnchor.constraint(equalTo: self.leftLabel.trailingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.rightLabel.widthAnchor.constraint(equalToConstant: W),
            self.rightLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.vLine = VLINE(into: self.contentView)
        self.vLine.activateConstraints([
            self.vLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func populate(with item: DP3_splitHeaderItem) {
        self.leftLabel.text = item.leftTitle
        self.rightLabel.text = item.rightTitle
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.leftLabel.textColor = CSS.shared.displayMode().header_textColor
        self.rightLabel.textColor = CSS.shared.displayMode().header_textColor
        self.vLine.backgroundColor = CSS.shared.displayMode().line_color
    }
    
    func calculateHeight() -> CGFloat {
        return 45
    }

}
