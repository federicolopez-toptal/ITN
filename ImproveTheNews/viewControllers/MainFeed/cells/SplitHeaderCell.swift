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
        
        self.leftLabel.textAlignment = .center
        self.leftLabel.font = merriweather_bold
        hStack.addArrangedSubview(self.leftLabel)
        self.leftLabel.activateConstraints([
            self.leftLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
            
        self.rightLabel.textAlignment = .center
        self.rightLabel.font = merriweather_bold
        hStack.addArrangedSubview(self.rightLabel)
        self.rightLabel.activateConstraints([
            self.rightLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func populate(with header: DP_splitHeader) {
        self.leftLabel.text = header.leftText
        self.rightLabel.text = header.rightText
    
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.leftLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.rightLabel.textColor = self.leftLabel.textColor
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 35.0)
    }
}
