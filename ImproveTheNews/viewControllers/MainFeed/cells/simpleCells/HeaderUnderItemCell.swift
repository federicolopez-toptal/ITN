//
//  HeaderZeroCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/12/2022.
//

import Foundation
import UIKit


class HeaderUnderItemCell: UICollectionViewCell {

    static let identifier = "HeaderZeroCell"

    let titleLabel = UILabel()
    
    
    
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
        
    //let roboto_bold = ROBOTO_BOLD(12)
        
        self.titleLabel.backgroundColor = .clear //.orange
        self.titleLabel.textColor = .black
        self.titleLabel.font =  DM_SERIF_DISPLAY_fixed(18) //MERRIWEATHER_BOLD(18) //roboto_bold
        self.titleLabel.text = "TEST TOPIC"
//        self.titleLabel.backgroundColor = .black
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            //self.titleLabel.heightAnchor.constraint(equalToConstant: 14),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 2)
        ])
    }
    
    func populate(with header: DP_header) {
        self.titleLabel.text = header.text.capitalized
        let characterSpacing: Double = 1.5
        //self.titleLabel.addCharacterSpacing(kernValue: characterSpacing)
        
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 34)
    }

}
