//
//  SpacerCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import UIKit

class SpacerCell_v3: UITableViewCell {

    static let identifier = "SpacerCell_v3"

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.refreshDisplayMode()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        if(SPACER_COLOR != nil) { self.contentView.backgroundColor = SPACER_COLOR }
    }

}
