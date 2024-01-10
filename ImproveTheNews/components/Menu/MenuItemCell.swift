//
//  MenuItemCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/10/2022.
//

import UIKit

class MenuItemCell: UITableViewCell {

    static let identifier = "MenuItemCell"
    static let heigth: CGFloat = 55
    
    let icon = UIImageView()
    let titleLabel = UILabel()
    var gapWidthContraint: NSLayoutConstraint?
    let arrowImageView = UIImageView()
    let selectedView = UIView()
    
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
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        let gap = UIView()
        gap.backgroundColor = .clear //.systemPink
        self.addSubview(gap)
        gap.activateConstraints([
            gap.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 33),
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
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.titleLabel.font = CSS.shared.menu_font
        self.titleLabel.text = "TEST TOPIC"
        self.titleLabel.numberOfLines = 0
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 19),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.addSubview(self.arrowImageView)
        self.arrowImageView.activateConstraints([
            self.arrowImageView.widthAnchor.constraint(equalToConstant: 28),
            self.arrowImageView.heightAnchor.constraint(equalToConstant: 28),
            self.arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
        
        
        self.addSubview(self.selectedView)
        self.selectedView.activateConstraints([
            self.selectedView.leadingAnchor.constraint(equalTo: self.icon.leadingAnchor, constant: -10),
            self.selectedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            self.selectedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        self.sendSubviewToBack(self.selectedView)
        self.selectedView.layer.cornerRadius = 8
        self.selectedView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
        self.selectedView.hide()
        
//        let line = UIView()
//        line.backgroundColor =  .systemPink //DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
//        self.addSubview(line)
//        line.activateConstraints([
//            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            line.heightAnchor.constraint(equalToConstant: 1.0)
//        ])
//        line.hide()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.selectedView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
    }
    
    // -------------------------------
    func setLeftGap(_ value: CGFloat) {
        self.gapWidthContraint?.constant = value
    }
    
    func setText(_ text: String) {
        self.titleLabel.text = text
        self.titleLabel.font = CSS.shared.menu_font
        self.titleLabel.addCharacterSpacing(kernValue: 1.0)
    }

    func setIcon(_ icon: UIImage?) {
        self.icon.image = icon
        self.icon.tintColor = CSS.shared.displayMode().menuItem_color
    }
    
    func showArrow(_ value: Int) {
        switch(value) {
            case 0:
                self.arrowImageView.image = nil
            case -1:
                self.arrowImageView.image = UIImage(named: "arrow.up.old")?.withRenderingMode(.alwaysTemplate)
            case 1:
                self.arrowImageView.image = UIImage(named: "arrow.down.old")?.withRenderingMode(.alwaysTemplate)
                
            default:
                NOTHING()
        }
        if(self.arrowImageView.image != nil) {
            self.arrowImageView.tintColor = CSS.shared.displayMode().menuItem_color
        }
    }
    
    func select(state: Bool) {
        self.selectedView.hide()
        if(state) {
            self.selectedView.show()
        }
    }

}
