//
//  iPhoneAllNews_vTxtCol_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit

class iPhoneAllNews_vTxtCol_v3_B: CustomCellView_v3 {

    var article: MainFeedArticle!
    private var WIDTH: CGFloat = 1
    private var fontSize: CGFloat = 18
    
    var storyComponents = [UIView]()
        let storyTitleLabel = UILabel()
        let storyPill = StoryPillBigView()
        let storySources = SourceIconsView(size: 28, border: 2, separation: 25)
        let storyTimeLabel = UILabel()

    var articleComponents = [UIView]()
        let articleTitleLabel = UILabel()
        let articleFlag = FlagView(size: 24)
        let articleSource = SourceIconsView(size: 28, border: 2, separation: 25)
        let articleSourceNameLabel = UILabel()
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
        let articleTimeLabel = UILabel()
        let articleStanceIcon = StanceIconView()
    
        var sourceTime_leading: NSLayoutConstraint?
        var source_leading: NSLayoutConstraint?
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, fontSize: CGFloat = 18) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.fontSize = fontSize
        
        self.buildContent()
    }
    
    private func buildContent() {

    // Story
        self.storyTitleLabel.numberOfLines = 0
        self.storyTitleLabel.font = DM_SERIF_DISPLAY_resize(24)
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
        
        self.storySources.buildInto(self)
        self.storySources.activateConstraints([
            self.storySources.centerYAnchor.constraint(equalTo: self.storyPill.centerYAnchor),
            self.storySources.leadingAnchor.constraint(equalTo: self.leadingAnchor)
//            self.storySources.leadingAnchor.constraint(equalTo: self.storyPill.trailingAnchor,
//                constant: CSS.shared.iPhoneSide_padding/2)
        ])
        storyComponents.append(self.storySources)
        self.storySources.refreshDisplayMode()
        
        self.storyTimeLabel.font = AILERON(14)
        self.storyTimeLabel.textAlignment = .left
        self.addSubview(self.storyTimeLabel)
        self.storyTimeLabel.activateConstraints([
            self.storyTimeLabel.centerYAnchor.constraint(equalTo: self.storyPill.centerYAnchor),
            self.storyTimeLabel.leadingAnchor.constraint(equalTo: self.storySources.trailingAnchor, constant: 8)
        ])
        storyComponents.append(self.storyTimeLabel)
        
    // Article
        self.articleTitleLabel.numberOfLines = 0
        self.articleTitleLabel.font = AILERON_resize(20)
        self.addSubview(self.articleTitleLabel)
        self.articleTitleLabel.activateConstraints([
            self.articleTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.articleTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        articleComponents.append(self.articleTitleLabel)

        self.articleFlag.buildInto(self)
        self.articleFlag.activateConstraints([
            self.articleFlag.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.articleFlag.topAnchor.constraint(equalTo: self.articleTitleLabel.bottomAnchor, constant: 12+2)
        ])
        articleComponents.append(self.articleFlag)

        self.articleSource.buildInto(self)
        self.source_leading = self.articleSource.leadingAnchor.constraint(equalTo: self.articleFlag.trailingAnchor, constant: 2)
        
        self.articleSource.activateConstraints([
            self.source_leading!,
            self.articleSource.topAnchor.constraint(equalTo: self.articleTitleLabel.bottomAnchor, constant: 12)
        ])
        articleComponents.append(self.articleSource)

        self.articleSourceNameLabel.font = CSS.shared.iPhoneArticle_textFont
        self.articleSourceNameLabel.numberOfLines = 0
        self.articleSourceNameLabel.textAlignment = .left
        self.addSubview(self.articleSourceNameLabel)
        self.articleSourceNameLabel.activateConstraints([
            self.articleSourceNameLabel.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor)
        ])
        self.sourceTime_leading = self.articleSourceNameLabel.leadingAnchor.constraint(equalTo: self.articleSource.trailingAnchor, constant: 4)
        self.sourceTime_leading?.isActive = true
        articleComponents.append(self.articleSourceNameLabel)
        
        self.addSubview(self.openIcon)
        self.openIcon.activateConstraints([
            self.openIcon.widthAnchor.constraint(equalToConstant: 12),
            self.openIcon.heightAnchor.constraint(equalToConstant: 12),
            self.openIcon.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor),
            self.openIcon.leadingAnchor.constraint(equalTo: self.articleSourceNameLabel.trailingAnchor, constant: 0)
        ])
        
        self.articleTimeLabel.font = AILERON(14)
        self.addSubview(self.articleTimeLabel)
        self.articleTimeLabel.activateConstraints([
            self.articleTimeLabel.centerYAnchor.constraint(equalTo: self.articleSourceNameLabel.centerYAnchor),
            self.articleTimeLabel.leadingAnchor.constraint(equalTo: self.openIcon.trailingAnchor, constant: 6)
        ])
        
        
        self.addSubview(self.articleStanceIcon)
        self.articleStanceIcon.activateConstraints([
            self.articleStanceIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleStanceIcon.centerYAnchor.constraint(equalTo: self.articleSourceNameLabel.centerYAnchor)
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
        
        self.openIcon.hide()
        if(article.isStory) {
            self.storyTitleLabel.text = article.title
            
            let numLines = self.storyTitleLabel.calculateHeightFor(width: self.WIDTH) / self.storyTitleLabel.font.lineHeight
            let diff = MAX_NUM_LINES - Int(numLines)
            if(diff>0) {
                for _ in 1...diff {
                    self.storyTitleLabel.text! += "\n"
                }
            }
            
            self.storySources.load(article.storySources)
            self.storyTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
        } else {
            self.articleTitleLabel.text = article.title
            self.articleTitleLabel.setLineSpacing(lineSpacing: 6.0)
            
            let numLines = self.articleTitleLabel.calculateHeightFor(width: self.WIDTH) / self.articleTitleLabel.font.lineHeight
            let diff = MAX_NUM_LINES - Int(numLines)
            if(diff>0) {
                for _ in 1...diff {
                    self.articleTitleLabel.text! += "\n"
                }
            }
            
//            var sourcesArray = [String]()
//            if let _identifier = Sources.shared.search(name: article.source) {
//                sourcesArray.append(_identifier)
//            }

            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: article.source) {
                sourcesArray.append(_identifier)
            }
            self.articleSource.load(sourcesArray)
            
            self.openIcon.show()
            let sourceName = CLEAN_SOURCE(from: article.source).uppercased()
            self.articleSourceNameLabel.text = ""
            self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
//            if(sourceName.count<=10) {
//                self.articleSourceNameLabel.text = sourceName
//                self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
//            } else {
//                self.articleSourceNameLabel.text = sourceName + "\n" + SHORT_TIME(input:FIX_TIME(article.time))
//                self.articleTimeLabel.text = ""
//            }
                        
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
        
//        if(!self.article.isStory) {
//            if(PREFS_SHOW_STANCE_ICONS()) {
//                self.articleStanceIcon.show()
//            } else {
//                self.articleStanceIcon.hide()
//            }
//        }

        if(self.article.isStory) {
//            if(PREFS_SHOW_SOURCE_ICONS()) {
//                self.storySources.show()
//            } else {
//                self.storySources.customHide()
//            }
        } else {
            if(PREFS_SHOW_SOURCE_ICONS()) {
                self.articleSource.show()
                self.sourceTime_leading?.constant = 5
            } else {
                self.articleSource.customHide()
                self.sourceTime_leading?.constant = 0
            }
            
            if(PREFS_SHOW_FLAGS()) {
                self.articleFlag.setFlag(article.country)
                self.articleFlag.customShow()
                self.source_leading?.constant = 2
                if(!PREFS_SHOW_SOURCE_ICONS()) {
                    self.source_leading?.constant = 5
                }
            } else {
                self.articleFlag.customHide()
                self.source_leading?.constant = 0
            }
            
            if(PREFS_SHOW_STANCE_ICONS()) {
                self.articleStanceIcon.show()
            } else {
                self.articleStanceIcon.hide()
            }
        }
        
        if let button = self.viewWithTag(64) {
            if(self.article.isStory) {
                button.hide()
            } else {
                button.show()
            }
        }
        
        self.storyPill.hide()
    }
    
    override func refreshDisplayMode() {
        self.storyTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.storyPill.refreshDisplayMode()
        self.storyTimeLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        
        self.articleTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.articleSourceNameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.articleTimeLabel.textColor = self.articleSourceNameLabel.textColor
        self.articleSource.refreshDisplayMode()
        self.articleStanceIcon.refreshDisplayMode()
    }
    
    // MARK: misc
    private func calculateHeightForStory() -> CGFloat {
        return self.storyTitleLabel.calculateHeightFor(width: self.WIDTH) + 12 + 32
    }
    
    private func calculateHeightForArticle() -> CGFloat {
        return self.articleTitleLabel.calculateHeightFor(width: self.WIDTH) + 12 + 18
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = 0
        var extra: CGFloat = 0
        
        if(self.article != nil) {
            if(self.article.isStory) {
                result += self.calculateHeightForStory()
            } else {
                result += self.calculateHeightForArticle()
            }
            
            if(PREFS_SHOW_FLAGS() || PREFS_SHOW_SOURCE_ICONS()) {
                extra = 10
            }
        }
        
        return result + 25 + extra
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour_old?.cancel()
        
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

extension iPhoneAllNews_vTxtCol_v3_B: StanceIconViewDelegate {
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
