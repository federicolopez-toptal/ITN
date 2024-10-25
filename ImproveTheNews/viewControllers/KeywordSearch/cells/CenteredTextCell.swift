//
//  CenteredTextCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/06/2023.
//

import UIKit

class CenteredTextCell: UITableViewCell {

    static let identifier = "CenteredTextCell"
    static var height: CGFloat = 30
    
    var customTextLabel = UILabel()
    var offsetY_layout: NSLayoutConstraint!
    
    var loading = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.customTextLabel.textAlignment = .center
        self.customTextLabel.font = ROBOTO(13)
    
        self.contentView.addSubview(self.customTextLabel)
        self.customTextLabel.activateConstraints([
            self.customTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                constant: IPAD_sideOffset(multiplier: -0.5)),
            self.customTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        self.offsetY_layout = self.customTextLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        self.offsetY_layout.isActive = true
        
        self.contentView.addSubview(self.loading)
        self.loading.activateConstraints([
            self.loading.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.loading.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        self.loading.color = CSS.shared.displayMode().main_textColor
        self.loading.hidesWhenStopped = true
        self.showLoading(true)
    }
    
    func populate(with text: String, offsetY: CGFloat = 0) {
        self.customTextLabel.text = text
        self.offsetY_layout.constant = offsetY
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.customTextLabel.textColor = UIColor(hex: 0xDA4933)
    }
    
    func showLoading(_ state: Bool) {
        if(state) {
            self.customTextLabel.hide()
            self.loading.startAnimating()
        } else {
            self.customTextLabel.show()
            self.loading.stopAnimating()
        }
    }

}
