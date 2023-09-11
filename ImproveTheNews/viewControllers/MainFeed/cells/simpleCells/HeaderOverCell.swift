//
//  HeaderCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class HeaderOverCell: UICollectionViewCell {

    static let identifier = "HeaderCell"

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
        self.titleLabel.font = MERRIWEATHER_BOLD(18) //roboto_bold
        self.titleLabel.text = "TEST TOPIC"
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 14),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func populate(with header: DP_header) {
        self.titleLabel.text = header.text
        let characterSpacing: Double = 1.5
        self.titleLabel.addCharacterSpacing(kernValue: characterSpacing)
        
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 40)
    }

}


/*
//-------------------
        if let _prevTestLine = self.contentView.viewWithTag(951) {
            _prevTestLine.removeFromSuperview()
        }
        
        //print(SCREEN_SIZE().width)
        let collectionViewWidth: CGFloat = 375 // iPhone 12 mini, iPhone 8
        let _size = StoryCO_cell.calculateHeight(text: story.title, sourcesCount: story.storySources.count,
            width: collectionViewWidth)
        
        let testLine = UIView()
        testLine.tag = 951
        testLine.backgroundColor = .yellow.withAlphaComponent(0.5)
        testLine.frame = CGRect(x: 0, y: _size.height, width: collectionViewWidth, height: 4)
        self.contentView.addSubview(testLine)
*/
