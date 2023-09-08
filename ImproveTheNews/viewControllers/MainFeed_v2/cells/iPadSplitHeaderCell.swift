//
//  iPadSplitHeaderCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/02/2023.
//

import UIKit

class iPadSplitHeaderCell: UITableViewCell {
    
    static let identifier = "iPadSplitHeaderCell"
    
    let titleLabel_1 = ROBOTO_TEXT()
    let titleLabel_2 = ROBOTO_TEXT()
    let vLine = UIView()


    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        let margin = IPAD_ITEMS_SEP
        
        let hStack = HSTACK(into: self.contentView)
        hStack.backgroundColor = .clear //.green
        hStack.spacing = margin
        hStack.distribution = .fillEqually
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20)
        ])
        
        hStack.addArrangedSubview(self.titleLabel_1)
        hStack.addArrangedSubview(self.titleLabel_2)
    
        self.contentView.addSubview(self.vLine)
        self.vLine.activateConstraints([
            self.vLine.widthAnchor.constraint(equalToConstant: 1.5),
            self.vLine.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.vLine.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.vLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel_1.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.titleLabel_2.textColor = self.titleLabel_1.textColor
        self.vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0x1D242F)
        
        //self.contentView.backgroundColor = .systemPink
    }
    
    func populate() {
        if(MUST_SPLIT()==1) {
            self.titleLabel_1.text = "LEFT"
            self.titleLabel_2.text = "RIGHT"
        } else {
            self.titleLabel_1.text = "CRITICAL"
            self.titleLabel_2.text = "PRO"
        }
        
        refreshDisplayMode()
    }
    
}
