//
//  MenuItemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/10/2022.
//

import UIKit

class MenuItemCell: UITableViewCell {

    static let identifier = "MenuItemCell"
    static let heigth: CGFloat = 45
    
    let titleLabel = UILabel()
    
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
        
        self.titleLabel.backgroundColor = .clear //.orange
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.titleLabel.font = roboto_bold
        self.titleLabel.text = "TEST TOPIC"
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let line = UIView()
        line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }

}
