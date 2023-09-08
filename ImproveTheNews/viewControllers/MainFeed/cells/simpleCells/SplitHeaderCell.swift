//
//  SplitHeaderCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/11/2022.
//

import UIKit

class SplitHeaderCell: UICollectionViewCell {
    
    static let identifier = "SplitHeaderCell"
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // -----------------------------------
    private func buildContent() {
        
        self.contentView.backgroundColor = .white
        let merriweather_bold = MERRIWEATHER_BOLD(17)
        
        let hStack = HSTACK(into: self.contentView)
        hStack.backgroundColor = .clear
        hStack.activateConstraints([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            hStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        // LEFT
        let hSubStack1 = HSTACK(into: hStack)
        hSubStack1.backgroundColor = .clear
        hSubStack1.activateConstraints([
            hSubStack1.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
        ADD_SPACER(to: hSubStack1, width: 16)
        self.leftLabel.textAlignment = .left
        self.leftLabel.font = merriweather_bold
        hSubStack1.addArrangedSubview(self.leftLabel)
            
        // RIGHT
        let hSubStack2 = HSTACK(into: hStack)
        hSubStack2.backgroundColor = .clear
        hSubStack2.activateConstraints([
            hSubStack2.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
        ADD_SPACER(to: hSubStack2, width: 16)
        self.rightLabel.textAlignment = .left
        self.rightLabel.font = merriweather_bold
        hSubStack2.addArrangedSubview(self.rightLabel)
        
    }
    
    func populate(with header: DP_splitHeader) {
        self.leftLabel.text = header.leftText
        self.rightLabel.text = header.rightText
    
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.leftLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.rightLabel.textColor = self.leftLabel.textColor
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 35.0)
    }
}
