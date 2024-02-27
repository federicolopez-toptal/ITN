//
//  iPadStory_vImg_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import Foundation
import UIKit

class iPadStory_vImg_v3: CustomCellView_v3 {
    
    private let imgWidth: CGFloat = 16
    private let imgHeight: CGFloat = 7.4
    
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
        // 16:9
    
        let W = self.WIDTH - (CSS.shared.iPhoneSide_padding * 2)
        let H = (W * imgHeight)/imgWidth
        return H
    }
    
    private func buildContent() {

        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = DM_SERIF_DISPLAY(32)
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])

        if(MUST_SPLIT()==0) {
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -250).isActive = true
        } else {
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding).isActive = true
        }
        

        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.mainImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.mainImageView.heightAnchor.constraint(equalToConstant: self.calculateImageViewHeight())
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
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
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.pill.refreshDisplayMode()
        self.sources.refreshDisplayMode()
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.mainImageView.refreshDisplayMode()
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        return self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding +
                self.titleLabel.calculateHeightFor(width: self.WIDTH - CSS.shared.iPhoneSide_padding - 250) +
                CSS.shared.iPhoneSide_padding + 24 + 32
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
