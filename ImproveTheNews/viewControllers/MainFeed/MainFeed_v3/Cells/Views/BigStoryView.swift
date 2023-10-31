//
//  BigStoryView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import Foundation
import UIKit
import SDWebImage

class BigStoryView: CustomCellView {
    
    private let imgWidth: CGFloat = 370
    private let imgHeight: CGFloat = 213
    
    private var WIDTH: CGFloat = 1
    
    let mainImageView = Cell_imageView(frame: .zero)
    let titleLabel = UILabel()
    let pill = StoryPillView()
    let sources = SourceIconsView()
    let timeLabel = UILabel()
    
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.buildContent()
    }
    
    private func calculateImageViewHeight() -> CGFloat {
        let H = (self.WIDTH * imgHeight)/imgWidth
        return H
    }
    
    private func buildContent() {

        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.widthAnchor.constraint(equalToConstant: self.WIDTH),
            self.mainImageView.heightAnchor.constraint(equalToConstant: self.calculateImageViewHeight())
        ])
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = DM_SERIF_DISPLAY(23)
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.left_padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CSS.shared.left_padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.left_padding),
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.left_padding),
        ])
        
        self.sources.buildInto(self)
        self.sources.activateConstraints([
            self.sources.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.sources.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: CSS.shared.left_padding)
        ])
        
        self.timeLabel.font = AILERON(12)
        self.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.timeLabel.leadingAnchor.constraint(equalTo: self.sources.trailingAnchor, constant: 8)
        ])
        
        self.refreshDisplayMode()
    }
    
    override func populate(_ article: MainFeedArticle) {
        self.mainImageView.load(url: article.imgUrl)
        self.titleLabel.text = article.title
        self.sources.load(article.storySources)
        self.timeLabel.text = article.time.uppercased()
    }
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.pill.refreshDisplayMode()
        self.sources.refreshDisplayMode()
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
    }
    
    func calculateHeight() -> CGFloat {
        return self.calculateImageViewHeight() + CSS.shared.left_padding +
                self.titleLabel.calculateHeightFor(width: self.WIDTH - (CSS.shared.left_padding * 2)) +
                12 + 24 + 32
    }
    
}
