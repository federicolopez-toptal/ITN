//
//  HeaderCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class HeaderCell: UICollectionViewCell {

    static let identifier = "HeaderCell"
    private let HEIGHT: CGFloat = 45.0
    private let WIDTH: CGFloat = SCREEN_SIZE().width
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: self.WIDTH)
        width.isActive = true
        return width
    }()
    
    let titleLabel = UILabel()
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        width.constant = self.WIDTH
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1)) // cell height
    }
    
}

extension HeaderCell {
    
    private func buildContent() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: self.HEIGHT)
        ])
        self.contentView.backgroundColor = .white
        
    let roboto_bold = UIFont(name: "Roboto-Bold", size: 13)
        
        self.titleLabel.backgroundColor = .clear //.orange
        self.titleLabel.textColor = .black
        self.titleLabel.font = roboto_bold
        self.titleLabel.text = "TEST TOPIC"
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
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
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
    }

}
