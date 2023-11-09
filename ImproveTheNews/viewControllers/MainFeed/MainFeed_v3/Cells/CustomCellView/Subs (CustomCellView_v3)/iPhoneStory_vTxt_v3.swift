//
//  iPhoneStory_vTxt_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit
import SDWebImage

class iPhoneStory_vTxt_v3: CustomCellView_v3 {
    
    private var WIDTH: CGFloat = 1
    
    let titleLabel = UILabel()
    var pill = StoryPillView()
    let timeLabel = UILabel()
    
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
        self.titleLabel.font = CSS.shared.iPhoneStory_titleFont
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        
        self.pill.buildInto(self)
        self.pill.activateConstraints([
            self.pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        
        self.timeLabel.font = CSS.shared.iPhoneStory_textFont
        self.timeLabel.textAlignment = .right
        self.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor),
            self.timeLabel.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: 8)
        ])


        self.refreshDisplayMode()
        
        // -------------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article
        
        self.titleLabel.text = article.title
        self.timeLabel.text = article.time.uppercased()
    }
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.pill.refreshDisplayMode()
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        return self.titleLabel.calculateHeightFor(width: self.WIDTH - (CSS.shared.iPhoneSide_padding * 2)) +
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
