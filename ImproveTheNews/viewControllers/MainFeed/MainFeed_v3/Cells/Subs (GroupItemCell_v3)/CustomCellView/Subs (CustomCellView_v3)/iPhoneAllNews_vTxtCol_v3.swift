//
//  iPhoneAllNews_vTxtCol_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit

class iPhoneAllNews_vTxtCol_v3: CustomCellView_v3 {

    var article: MainFeedArticle!
    private var WIDTH: CGFloat = 1
    
    var storyComponents = [UIView]()
        let storyTitleLabel = UILabel()
        let storyPill = StoryPillMiniView()
        let storyTimeLabel = UILabel()

    var articleComponents = [UIView]()
        let articleTitleLabel = UILabel()
        let articleSourceTimeLabel = UILabel()
        let articleStanceIcon = StanceIconView()
    
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

    // Story
        self.storyTitleLabel.numberOfLines = 0
        self.storyTitleLabel.font = CSS.shared.iPhoneStory_titleFont_small
        self.addSubview(self.storyTitleLabel)
        self.storyTitleLabel.activateConstraints([
            self.storyTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.storyTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.storyTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
        storyComponents.append(self.storyTitleLabel)
        
        self.storyPill.buildInto(self)
        self.storyPill.activateConstraints([
            self.storyPill.topAnchor.constraint(equalTo: self.storyTitleLabel.bottomAnchor, constant: 12),
            self.storyPill.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        storyComponents.append(self.storyPill)
        
        self.storyTimeLabel.font = CSS.shared.iPhoneStory_textFont
        self.storyTimeLabel.textAlignment = .left
        self.addSubview(self.storyTimeLabel)
        self.storyTimeLabel.activateConstraints([
            self.storyTimeLabel.centerYAnchor.constraint(equalTo: self.storyPill.centerYAnchor),
            self.storyTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        storyComponents.append(self.storyTimeLabel)
        
    // Article
        self.articleTitleLabel.numberOfLines = 0
        self.articleTitleLabel.font = CSS.shared.iPhoneArticle_titleFont
        self.addSubview(self.articleTitleLabel)
        self.articleTitleLabel.activateConstraints([
            self.articleTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.articleTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        articleComponents.append(self.articleTitleLabel)

        self.articleSourceTimeLabel.font = CSS.shared.iPhoneArticle_textFont
        self.articleSourceTimeLabel.numberOfLines = 0
        self.articleSourceTimeLabel.textAlignment = .left
        self.addSubview(self.articleSourceTimeLabel)
        self.articleSourceTimeLabel.activateConstraints([
            self.articleSourceTimeLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 12),
            self.articleSourceTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.articleSourceTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35)
        ])
        articleComponents.append(self.articleSourceTimeLabel)
        
        self.addSubview(self.articleStanceIcon)
        self.articleStanceIcon.activateConstraints([
            self.articleStanceIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleStanceIcon.centerYAnchor.constraint(equalTo: self.articleSourceTimeLabel.centerYAnchor)
        ])
        self.articleStanceIcon.delegate = self
        articleComponents.append(self.articleStanceIcon)
        
        self.refreshDisplayMode()
        // -------------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article
        
        if(article.isStory) {
            self.storyTitleLabel.text = article.title
            self.storyTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
        } else {
            self.articleTitleLabel.text = article.title
            
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: article.source) {
                sourcesArray.append(_identifier)
            }
            
            self.articleSourceTimeLabel.text = CLEAN_SOURCE(from: article.source).uppercased() + "    " + SHORT_TIME(input:FIX_TIME(article.time))
            self.articleStanceIcon.setValues(article.LR, article.PE)
        }
        
        ///////
        for V in self.storyComponents {
            if(self.article.isStory) {
                V.show()
            } else {
                V.hide()
            }
        }
        for V in self.articleComponents {
            if(!self.article.isStory) {
                V.show()
            } else {
                V.hide()
            }
        }
        ///
        
        if(!self.article.isStory) {
            if(PREFS_SHOW_STANCE_ICONS()) {
                self.articleStanceIcon.show()
            } else {
                self.articleStanceIcon.hide()
            }
        }
    }
    
    override func refreshDisplayMode() {
        self.storyTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.storyPill.refreshDisplayMode()
        self.storyTimeLabel.textColor = CSS.shared.displayMode().sec_textColor
        
        self.articleTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.articleSourceTimeLabel.textColor = CSS.shared.displayMode().main_textColor
        self.articleStanceIcon.refreshDisplayMode()
    }
    
    // MARK: misc
    private func calculateHeightForStory() -> CGFloat {
        return self.storyTitleLabel.calculateHeightFor(width: self.WIDTH) + 12 + 18
    }
    
    private func calculateHeightForArticle() -> CGFloat {
        return self.articleTitleLabel.calculateHeightFor(width: self.WIDTH) + 12 + 18
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = 0
        if(self.article.isStory) {
            result += self.calculateHeightForStory()
        } else {
            result += self.calculateHeightForArticle()
        }

        return result + 25
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour?.cancel()
        
        if(self.article.isEmpty()) { return }
        
        if(self.article.isStory) {
            let vc = StoryViewController()
            vc.story = self.article
            CustomNavController.shared.pushViewController(vc, animated: true)
        } else {
            let vc = ArticleViewController()
            vc.article = article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
}

extension iPhoneAllNews_vTxtCol_v3: StanceIconViewDelegate {
    func onStanceIconTap(sender: StanceIconView) {
        let info: [String : Any] = [
            "LR": self.article.LR,
            "PE": self.article.PE,
            "source": CLEAN_SOURCE(from: self.article.source),
            "country": self.article.country
        ]
        NOTIFY(Notification_stanceIconTap, userInfo: info)
    }
}
