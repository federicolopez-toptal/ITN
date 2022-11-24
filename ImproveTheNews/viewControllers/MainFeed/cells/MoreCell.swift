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
            self.titleLabel.widthAnchor.constraint(equalToConstant: 115),
            self.titleLabel.heightAnchor.constraint(equalToConstant: MoreCell.buttonHeight),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        let margin: CGFloat = 5
        let button = UIButton(type: .system)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.contentView.addSubview(button)
        button.activateConstraints([
            button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor, constant: margin*2),
            button.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor, constant: margin*2)
        ])
        button.addTarget(self, action: #selector(onShowMoreButtonTap(_:)), for: .touchUpInside)
    }
    
    func populate(with info: DP_more) {
        self.topic = info.topic
        self.refreshDisplayMode()
    }
    
    private func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.titleLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE8E9EA)
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
