//
//  iPadMoreCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit


protocol iPadMoreCellDelegate: AnyObject {
    func onShowMoreButtonTap(sender: iPadMoreCell)
}

class iPadMoreCell: UITableViewCell {

    static let identifier = "iPadMoreCell"
    weak var delegate: iPadMoreCellDelegate?

    var topic = "news"
    private var mustLoadMore = false
    private let loadMoreLabel = UILabel()
    private let noMoreLabel = UILabel()

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.loadMoreLabel.font = ROBOTO_BOLD(12)
        self.loadMoreLabel.text = "SHOW MORE"
        self.loadMoreLabel.textAlignment = .center
        self.loadMoreLabel.layer.masksToBounds = true
        self.loadMoreLabel.layer.cornerRadius = 38/2
        self.contentView.addSubview(self.loadMoreLabel)
        self.loadMoreLabel.activateConstraints([
            self.loadMoreLabel.heightAnchor.constraint(equalToConstant: 38),
            self.loadMoreLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.loadMoreLabel.widthAnchor.constraint(equalToConstant: 115),
            //self.loadMoreLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.loadMoreLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.noMoreLabel.font = ROBOTO_BOLD(12)
        self.noMoreLabel.text = "NO MORE ARTICLES FOR THIS TOPIC"
        self.noMoreLabel.textAlignment = .center
        self.noMoreLabel.layer.masksToBounds = true
        self.noMoreLabel.layer.cornerRadius = 38/2
        self.noMoreLabel.alpha = 0.5
        self.contentView.addSubview(self.noMoreLabel)
        self.noMoreLabel.activateConstraints([
            self.noMoreLabel.heightAnchor.constraint(equalToConstant: 38),
            self.noMoreLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.noMoreLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.noMoreLabel.widthAnchor.constraint(equalToConstant: 230)
        ])
        
        // -----------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        if(self.mustLoadMore) {
            self.delegate?.onShowMoreButtonTap(sender: self)
        }
    }

    func populate(with item: DataProviderMoreItem) {
        self.mustLoadMore = !item.completed
        self.topic = item.topic
        
        if(self.mustLoadMore) {
            self.loadMoreLabel.show()
            self.noMoreLabel.hide()
        } else {
            self.loadMoreLabel.hide()
            self.noMoreLabel.show()
        }

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        
        self.loadMoreLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.loadMoreLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        
        self.noMoreLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.noMoreLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        
        //self.contentView.backgroundColor = .systemPink
    }

}
