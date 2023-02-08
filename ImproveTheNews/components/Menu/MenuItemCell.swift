//
//  MenuItemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/10/2022.
//

import UIKit

class MenuItemCell: UITableViewCell {

    static let identifier = "MenuItemCell"
    static let heigth: CGFloat = 50
    
    let icon = UIImageView()
    let titleLabel = UILabel()
    var gapWidthContraint: NSLayoutConstraint?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        let roboto_bold = ROBOTO_BOLD(13)
        
        let gap = UIView()
        gap.backgroundColor = .clear //.systemPink
        self.addSubview(gap)
        gap.activateConstraints([
            gap.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            gap.heightAnchor.constraint(equalToConstant: 30),
            gap.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.gapWidthContraint = gap.widthAnchor.constraint(equalToConstant: 1)
        self.gapWidthContraint?.isActive = true
        
        
        self.addSubview(self.icon)
        self.icon.image = UIImage(named: "menu.headlines")
        self.icon.activateConstraints([
            self.icon.widthAnchor.constraint(equalToConstant: 24),
            self.icon.heightAnchor.constraint(equalToConstant: 24),
            self.icon.leadingAnchor.constraint(equalTo: gap.trailingAnchor, constant: 0),
            self.icon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.titleLabel.backgroundColor = .clear //.orange
        self.titleLabel.textColor = UIColor(hex: 0x93A0B4)
        self.titleLabel.font = roboto_bold
        self.titleLabel.text = "TEST TOPIC"
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 12),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let line = UIView()
        line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
        self.addSubview(line)
        line.activateConstraints([
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        line.hide()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }
    
    func setLeftGap(_ value: CGFloat) {
        self.gapWidthContraint?.constant = value
    }

}
