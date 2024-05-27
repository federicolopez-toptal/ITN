//
//  BigStoryView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import Foundation
import UIKit

class iPhoneStory_vImg_v3: CustomCellView_v3 {
    
    private let imgWidth: CGFloat = 370
    private let imgHeight: CGFloat = 213
    
    private var WIDTH: CGFloat = 1
    
    let mainImageView = CustomImageView()
    let titleLabel = UILabel()
    var pill = StoryPillView()
    let sources = SourceIconsView()
    let timeLabel = UILabel()
    var time_leading: NSLayoutConstraint?
    
    var article: MainFeedArticle!
    
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
        self.titleLabel.font = CSS.shared.iPhoneStory_titleFont
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        
        self.sources.buildInto(self)
        self.sources.activateConstraints([
            self.sources.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.sources.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor,
                constant: CSS.shared.iPhoneSide_padding)
        ])
        
        self.timeLabel.font = CSS.shared.iPhoneStory_textFont
        self.timeLabel.textAlignment = .right
        self.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor)
        ])
        self.time_leading = self.timeLabel.leadingAnchor.constraint(equalTo: self.sources.trailingAnchor, constant: 8)
        self.time_leading?.isActive = true


        self.refreshDisplayMode()
        
        // -------------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article

        self.mainImageView.load(url: article.imgUrl)
        self.mainImageView.showCorners(true)
        
        self.titleLabel.text = article.title
        self.timeLabel.text = FIX_TIME(article.time).uppercased()
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.sources.load(article.storySources)
            self.sources.show()
            self.time_leading?.constant = 8
        } else {
            self.sources.customHide()
            self.time_leading?.constant = 0
        }
    }
    
    func showFigureImage(_ url: String) {
        if(url.isEmpty){ return }
        
        self.sources.loadFigure(url)
        self.sources.show()
        self.time_leading?.constant = 8
    }
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.pill.refreshDisplayMode()
        self.sources.refreshDisplayMode()
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.mainImageView.refreshDisplayMode()
        
        if let _A = self.article {
            if(_A.isContext) {
                self.pill.setAsContext()
            } else {
                self.pill.setAsStory()
            }
        }
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        return self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding +
                self.titleLabel.calculateHeightFor(width: self.WIDTH - (CSS.shared.iPhoneSide_padding * 2)) +
                12 + 24 + 32
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour?.cancel()
        
        if let _article = self.article {
            if(_article.isEmpty()) { return }
            
            if(_article.isStory) {
                let vc = StoryViewController()
                vc.story = self.article
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        }
    }
    
}
