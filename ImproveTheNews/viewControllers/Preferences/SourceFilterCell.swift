//
//  SourceFilterCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/08/2024.
//

import UIKit
import SDWebImage


class SourceFilterCell: UITableViewCell {
    
    static let identifier = "SourceFilterCell"
    static let heigth: CGFloat = 32+16
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let moneyIcon = UIImageView()
    let check = SourceCheck()
    
    
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
        let iconDim: CGFloat = 32
    
        self.iconImageView.backgroundColor = .gray
        self.addSubview(self.iconImageView)
        self.iconImageView.activateConstraints([
            self.iconImageView.widthAnchor.constraint(equalToConstant: iconDim),
            self.iconImageView.heightAnchor.constraint(equalToConstant: iconDim),
            self.iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.iconImageView.layer.cornerRadius = iconDim/2
        self.iconImageView.clipsToBounds = true
    
        self.addSubview(self.nameLabel)
        self.nameLabel.font = AILERON(16)
        self.nameLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.nameLabel.text = "Lorem ipsum"
        self.nameLabel.activateConstraints([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 10),
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.moneyIcon.image = UIImage(named: DisplayMode.imageName("money"))
        self.addSubview(self.moneyIcon)
        self.moneyIcon.activateConstraints([
            self.moneyIcon.widthAnchor.constraint(equalToConstant: 24),
            self.moneyIcon.heightAnchor.constraint(equalToConstant: 24),
            self.moneyIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.moneyIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 6)
        ])
        
        self.check.buildInto(self.contentView)
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.nameLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.moneyIcon.image = UIImage(named: DisplayMode.imageName("money"))
        self.check.refreshDisplayMode()
    }
    
    func populate(with data: SourceIcon) {
        self.nameLabel.text = data.name
        
        if let _url = data.url {
            if(!_url.contains(".svg")) {
                iconImageView.sd_setImage(with: URL(string: _url))
            } else {
                iconImageView.image = UIImage(named: data.identifier + ".png")
            }
        }
        
        if(data.paywall) {
            self.moneyIcon.show()
        } else {
            self.moneyIcon.hide()
        }
        
        self.check.setState(data.state)
    }
    
}
