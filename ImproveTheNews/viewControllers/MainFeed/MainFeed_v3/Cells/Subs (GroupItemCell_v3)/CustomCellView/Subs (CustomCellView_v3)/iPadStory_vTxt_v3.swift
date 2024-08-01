//
//  iPadStory_vTxt_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit

class iPadStory_vTxt_v3: CustomCellView_v3 {
    
    private var WIDTH: CGFloat = 1
    
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
    
    private func buildContent() {

        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = DM_SERIF_DISPLAY(32)
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -250),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        
        self.sources.buildInto(self)
        self.sources.activateConstraints([
            self.sources.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.sources.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding)
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
        
        self.titleLabel.text = article.title
        self.timeLabel.text = FIX_TIME(article.time).uppercased()
        
        if(PREFS_SHOW_SOURCE_ICONS() && Layout.current() == .textImages) {
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
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        return self.titleLabel.calculateHeightFor(width: self.WIDTH - CSS.shared.iPhoneSide_padding - 250) +
                12 + 24 + 32
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour_old?.cancel()
        
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
