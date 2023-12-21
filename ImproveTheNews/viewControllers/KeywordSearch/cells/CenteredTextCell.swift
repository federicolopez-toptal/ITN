//
//  CenteredTextCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/06/2023.
//

import UIKit

class CenteredTextCell: UITableViewCell {

    static let identifier = "CenteredTextCell"
    static var height: CGFloat = 30
    
    var customTextLabel = UILabel()
    var offsetY_layout: NSLayoutConstraint!
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.customTextLabel.textAlignment = .center
        self.customTextLabel.font = ROBOTO(13)
    
        self.contentView.addSubview(self.customTextLabel)
        self.customTextLabel.activateConstraints([
            self.customTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.customTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        self.offsetY_layout = self.customTextLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        self.offsetY_layout.isActive = true
    }
    
    func populate(with text: String, offsetY: CGFloat = 0) {
        self.customTextLabel.text = text
        self.offsetY_layout.constant = offsetY
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.customTextLabel.textColor = UIColor(hex: 0xDA4933)
    }

}
