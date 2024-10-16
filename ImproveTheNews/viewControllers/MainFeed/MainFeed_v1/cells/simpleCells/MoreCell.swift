//
//  MoreCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/10/2022.
//

import UIKit

protocol MoreCellDelegate: AnyObject {
    func onShowMoreButtonTap(sender: MoreCell)
}

class MoreCell: UICollectionViewCell {
    
    static let identifier = "MoreCell"
    static let buttonHeight: CGFloat = 38.0
    weak var delegate: MoreCellDelegate?
    var topic: String?
    
    let titleLabel = UILabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    let button = UIButton(type: .system)
    
    
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
        
    let roboto_bold = ROBOTO_BOLD(12)
    
        self.titleLabel.font = roboto_bold
        self.titleLabel.text = "SHOW MORE"
        self.titleLabel.textAlignment = .center
        self.titleLabel.layer.masksToBounds = true
        self.titleLabel.layer.cornerRadius = MoreCell.buttonHeight/2
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.heightAnchor.constraint(equalToConstant: MoreCell.buttonHeight),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        self.titleLabelWidthConstraint = self.titleLabel.widthAnchor.constraint(equalToConstant: 115)
        self.titleLabelWidthConstraint?.isActive = true
        
        let margin: CGFloat = 5
        self.button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.contentView.addSubview(self.button)
        self.button.activateConstraints([
            self.button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.button.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor, constant: margin*2),
            self.button.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor, constant: margin*2)
        ])
        self.button.addTarget(self, action: #selector(onShowMoreButtonTap(_:)), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(onShowMoreButtonTap(_:)), for: .touchUpInside)
    }
    
    func populate(with info: DP_more) {
        self.topic = info.topic
        if(!info.completed) {
            self.titleLabel.text = "SHOW MORE"
            self.titleLabel.alpha = 1.0
            self.titleLabelWidthConstraint?.constant = 115
            self.button.isEnabled = true
        } else {
            self.titleLabel.text = "NO MORE ARTICLES FOR THIS TOPIC"
            self.titleLabel.alpha = 0.5
            self.titleLabelWidthConstraint?.constant = 230
            self.button.isEnabled = false
        }
        
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.titleLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        let H: CGFloat = 25 + MoreCell.buttonHeight + 25
        return CGSize(width: width, height: H)
    }
    
}

// MARK: Events
extension MoreCell {
    @objc func onShowMoreButtonTap(_ sender: UIButton) {
        self.delegate?.onShowMoreButtonTap(sender: self)
    }
}
