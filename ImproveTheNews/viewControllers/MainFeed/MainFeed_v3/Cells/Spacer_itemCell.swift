//
//  Spacer_itemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import UIKit

class Spacer_itemCell: UITableViewCell {

    static let identifier = "Spacer_itemCell"

    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }

}
