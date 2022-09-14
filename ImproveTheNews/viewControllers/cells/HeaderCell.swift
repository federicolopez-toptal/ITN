//
//  HeaderCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class HeaderCell: UITableViewCell {

    static let identifier = "HeaderCell"
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
    
}

extension HeaderCell {
    
    private func buildContent() {
        self.backgroundColor = .white
        
        let roboto_bold = UIFont(name: "Roboto-Bold", size: 13)
        
        self.titleLabel.backgroundColor = .clear //.orange
        self.titleLabel.textColor = .black
        self.titleLabel.font = roboto_bold
        self.titleLabel.text = "TEST TOPIC"
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func populate(with header: DP_header) {
        self.titleLabel.text = header.text
        let characterSpacing: Double = 1.5
        self.titleLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
    }

}
