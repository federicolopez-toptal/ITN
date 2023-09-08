//
//  iPadSpacerCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/04/2023.
//

import UIKit

class iPadSpacerCell: UITableViewCell {

    static let identifier = "iPadSpacerCell"

    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }

}
