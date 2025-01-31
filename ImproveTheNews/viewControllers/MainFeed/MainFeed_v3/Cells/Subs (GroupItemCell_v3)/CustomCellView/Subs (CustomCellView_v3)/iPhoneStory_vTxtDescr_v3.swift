//
//  iPhoneStory_vTxt_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit

class iPhoneStory_vTxtDescr_v3: CustomCellView_v3 {
    
    private var WIDTH: CGFloat = 1
    
    let titleLabel = UILabel()
    let descrlabel = UILabel()
    var pill = StoryPillView()
    let sources = SourceIconsView(size: 24, border: 2, separation: 20)
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
        self.titleLabel.font = DM_SERIF_DISPLAY_resize(23)
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        
        self.descrlabel.numberOfLines = 0
        self.descrlabel.font = AILERON_resize(17)
        self.addSubview(self.descrlabel)
        self.descrlabel.activateConstraints([
            self.descrlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.descrlabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.descrlabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.descrlabel.bottomAnchor, constant: 22),
            self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
        
        self.sources.buildInto(self)
        self.sources.activateConstraints([
            self.sources.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.sources.leadingAnchor.constraint(equalTo: self.pill.leadingAnchor)
//            self.sources.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        
        self.timeLabel.font = AILERON(14)
        self.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.sources.centerYAnchor)
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
        self.descrlabel.text = article.summaryText        
        
        var timeText = ""
        if(article.storySources.count>3) {
            timeText = "+\(article.storySources.count-3)   •   "
        }
        timeText += FIX_TIME(article.time).uppercased()
        self.timeLabel.text = timeText
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.sources.load(article.storySources)
            self.sources.show()
            self.time_leading?.constant = 8
        } else {
            self.sources.customHide()
            self.time_leading?.constant = 0
        }
        
        self.pill.hide()
    }
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.descrlabel.textColor = CSS.shared.displayMode().main_textColor
        self.pill.refreshDisplayMode()
        self.sources.refreshDisplayMode()
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        let _w: CGFloat = self.WIDTH - 32
    
        return self.titleLabel.calculateHeightFor(width: _w) +
                8 + self.descrlabel.calculateHeightFor(width: _w) +
                22 + 24 + 32
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
