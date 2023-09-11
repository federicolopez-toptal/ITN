//
//  TopicsCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/06/2023.
//

import UIKit

class TopicsCell: UITableViewCell {
    
    static let identifier = "TopicsCell"
    static var lastHeight: CGFloat = 0
    
    var topics = [TopicSearchResult]()
    let tagsContainer = UIView()
    var tagsContainerHeightLayout: NSLayoutConstraint!
    
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        //self.tagsContainer.backgroundColor = .green
        self.contentView.addSubview(self.tagsContainer)
        self.tagsContainer.activateConstraints([
            self.tagsContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.tagsContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.tagsContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ])
        self.tagsContainerHeightLayout = self.tagsContainer.heightAnchor.constraint(equalToConstant: 100)
        self.tagsContainerHeightLayout.isActive = true
    }
    
    static func calculateHeightFor(topics: [TopicSearchResult]) -> CGFloat {
        return 5 + TopicsCell.lastHeight + 5
    }
    
    func populate(with topics: [TopicSearchResult]) {
        self.topics = topics
        
        let H: CGFloat = 28.0
        let SEP: CGFloat = 8.0
        let LIMIT = SCREEN_SIZE().width - 15
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        
        REMOVE_ALL_SUBVIEWS(from: self.tagsContainer)
        for (i, T) in topics.enumerated() {
            let label = UILabel()
            label.font = ROBOTO(13)
            label.textColor = UIColor(hex: 0xDA4933)
            label.backgroundColor = UIColor(hex: 0xFF643C).withAlphaComponent(0.2)
            label.textAlignment = .center
            label.text = T.name
            label.layer.cornerRadius = H/2
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor(hex: 0xFF643C).cgColor
            label.clipsToBounds = true
            
            let W = label.calculateWidthFor(height: H) + 26
            let trailing = val_x + W
            if(trailing > LIMIT) {
                val_x = 0
                val_y += H + SEP
            }

            self.tagsContainer.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: self.tagsContainer.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: self.tagsContainer.topAnchor, constant: val_y),
                label.widthAnchor.constraint(equalToConstant: W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 200 + i
            button.backgroundColor = .clear //.blue.withAlphaComponent(0.5)
            self.tagsContainer.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(tagButtonOnTap(_:)), for: .touchUpInside)
            
            val_x += SEP + W
        }
    
        TopicsCell.lastHeight = val_y + H
        self.tagsContainerHeightLayout.constant = TopicsCell.lastHeight
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }
    
    // MARK: - Event(s)
    @objc func tagButtonOnTap(_ sender: UIButton) {
        let tag = sender.tag - 200
        self.loadTopic(self.topics[tag].label)
    }
    
    func loadTopic(_ topic: String) {
        if(IPHONE()) {
            let vc = MainFeedViewController()
            vc.topic = topic
            CustomNavController.shared.viewControllers = [vc]

            DELAY(0.1) {
                CustomNavController.shared.slidersPanel.show()
                CustomNavController.shared.floatingButton.show()
            }
        } else {
            let vc = MainFeed_v2ViewController()
            vc.topic = topic
            CustomNavController.shared.viewControllers = [vc]

            DELAY(0.1) {
                CustomNavController.shared.slidersPanel.show()
                CustomNavController.shared.floatingButton.show()
            }
        }
    }
}
