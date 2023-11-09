//
//  iPhoneMoreCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2023.
//

import UIKit

protocol iPhoneMoreCell_v3_delegate: AnyObject {
    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3)
}

class iPhoneMoreCell_v3: UITableViewCell {

    static let identifier = "iPhoneMoreCell_v3"
    weak var delegate: iPhoneMoreCell_v3_delegate?
    
    var topic = "news"
    private var loadMore = false
    let infoLabel = UILabel()
    let rectView = UIView()
    
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.contentView.addSubview(self.rectView)
        self.rectView.activateConstraints([
            self.rectView.widthAnchor.constraint(equalToConstant: 122),
            self.rectView.heightAnchor.constraint(equalToConstant: 48),
            self.rectView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.rectView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        self.rectView.layer.cornerRadius = 5
    
        self.infoLabel.font = CSS.shared.iPhoneMore_font
        self.infoLabel.textAlignment = .center
        self.contentView.addSubview(self.infoLabel)
        self.infoLabel.activateConstraints([
            self.infoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        // -----------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        if(self.loadMore) {
            self.delegate?.onShowMoreButtonTap(sender: self)
        }
    }
    
    func populate(with item: DP3_more) {
        self.loadMore = !item.completed
        self.topic = item.topic
    
        if(self.loadMore) {
            self.infoLabel.text = "Show more"
            self.infoLabel.alpha = 1.0
            self.rectView.show()
        } else {
            self.infoLabel.text = "No more articles for this topic"
            self.infoLabel.alpha = 0.5
            self.rectView.hide()
        }
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.infoLabel.textColor = CSS.shared.displayMode().main_textColor
        self.rectView.backgroundColor = CSS.shared.displayMode().moreButton_bgColor
    }
    
    func calculateHeight() -> CGFloat {
        return 13 + 48 + 13
    }
    
}
