//
//  SpacerCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class SpacerCell: UICollectionViewCell {
    
    static let identifier = "SpacerCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }
    
}
