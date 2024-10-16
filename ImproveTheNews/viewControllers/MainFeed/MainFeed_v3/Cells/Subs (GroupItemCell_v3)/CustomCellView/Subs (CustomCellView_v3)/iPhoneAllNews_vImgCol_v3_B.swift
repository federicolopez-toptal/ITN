//
//  iPhoneAllNews_vImgCol_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit

let MAX_NUM_LINES_B = 3

class iPhoneAllNews_vImgCol_v3_B: CustomCellView_v3 {

    var article: MainFeedArticle!
    private var WIDTH: CGFloat = 1
    private var minimumLineNum: Bool = true

    private let imgWidth: CGFloat = 160
    private let imgHeight: CGFloat = 88
    
    let mainImageView = CustomImageView()
    var isContext = false
    var ignoreSearch = false
    
    
    var storyComponents = [UIView]()
        let storyTitleLabel = UILabel()
        let storyPill = StoryPillBigView()
        let storySources = SourceIconsView(size: 28, border: 2, separation: 25)
        let storyTimeLabel = UILabel()

    var articleComponents = [UIView]()
        let articleTitleLabel = UILabel()
        let articleFlag = FlagView(size: 24)
        let articleSource = SourceIconsView(size: 24, border: 2, separation: 15)
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
    
    init(width: CGFloat, minimumLineNum: Bool = true) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.minimumLineNum = minimumLineNum
        
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
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.heightAnchor.constraint(equalToConstant: self.calculateImageViewHeight())
        ])
        self.mainImageView.setSmallLoading()
        
    // Story
        self.storyTitleLabel.numberOfLines = 0
        self.storyTitleLabel.font = DM_SERIF_DISPLAY_resize(24)
        self.addSubview(self.storyTitleLabel)
        self.storyTitleLabel.activateConstraints([
            self.storyTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.storyTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.storyTitleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding)
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
            self.storySources.leadingAnchor.constraint(equalTo: self.storyPill.trailingAnchor,
                constant: CSS.shared.iPhoneSide_padding/2)
        ])
        storyComponents.append(self.storySources)
        
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
        //self.articleTitleLabel.backgroundColor = .red
        self.articleTitleLabel.adjustsFontSizeToFitWidth = false
        self.articleTitleLabel.lineBreakMode = .byTruncatingTail
        self.articleTitleLabel.font = AILERON_resize(20)
        self.addSubview(self.articleTitleLabel)
        self.articleTitleLabel.activateConstraints([
            self.articleTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.articleTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleTitleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding)
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
        
        self.articleTimeLabel.font = self.articleSourceNameLabel.font
        self.addSubview(self.articleTimeLabel)
        self.articleTimeLabel.activateConstraints([
            self.articleTimeLabel.centerYAnchor.constraint(equalTo: self.articleSourceNameLabel.centerYAnchor),
            self.articleTimeLabel.leadingAnchor.constraint(equalTo: self.openIcon.trailingAnchor, constant: 5)
        ])
        
        self.addSubview(self.articleStanceIcon)
        self.articleStanceIcon.activateConstraints([
            self.articleStanceIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.articleStanceIcon.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor)
        ])
        self.articleStanceIcon.delegate = self
        articleComponents.append(self.articleStanceIcon)
        
        let stanceIconButton = UIButton(type: .system)
        //stanceIconButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(stanceIconButton)
        stanceIconButton.activateConstraints([
            stanceIconButton.leadingAnchor.constraint(equalTo: self.articleStanceIcon.leadingAnchor,
                constant: -10),
            stanceIconButton.trailingAnchor.constraint(equalTo: self.articleStanceIcon.trailingAnchor,
                constant: 10),
            stanceIconButton.topAnchor.constraint(equalTo: self.articleStanceIcon.topAnchor,
                constant: -10),
            stanceIconButton.bottomAnchor.constraint(equalTo: self.articleStanceIcon.bottomAnchor,
                constant: 10),
        ])
        stanceIconButton.tag = 64
        stanceIconButton.addTarget(self, action: #selector(stanceIconOnTap(_:)), for: .touchUpInside)
        
        self.refreshDisplayMode()
        // -------------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func stanceIconOnTap(_ sender: UIButton) {
        self.onStanceIconTap(sender: self.articleStanceIcon)
    
    
        //self.articleStanceIcon.viewOnTap(sender: nil)
        
//        let popup = StancePopupView()
//        popup.populate(sourceName: spin.media_name, country: spin.media_country_code,
//            LR: spin.LR, PE: spin.CP)
//        popup.pushFromBottom()
    }
    
    
    // MARK: Overrides
    func populate(story: StorySearchResult) {
        if(story.type == 2) {
            self.isContext = true
            self.storyPill.setAsContext()
        } else {
            self.isContext = false
            self.storyPill.setAsStory()
        }
        
        self.article = MainFeedArticle(story: story)
        self.populate(article)
    }
    
    func populate(article: StoryArticle) {
        //print("from StoryContent/Split & articles")
    
        self.openIcon.show()
        self.article = MainFeedArticle(url: article.url)
        self.article.LR = article.LR
        self.article.PE = article.PE
        self.article.country = article.media_country_code
        self.article.source = article.media_title
        
        self.mainImageView.load(url: article.image)
        self.mainImageView.showCorners(false)
        
        //self.articleTitleLabel.font = CSS.shared.iPhoneStory_titleFont_small
        self.articleTitleLabel.text = article.title
        
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: article.media_title) {
            sourcesArray.append(_identifier)
        }
        self.articleSource.load(sourcesArray)
        
        let sourceName = CLEAN_SOURCE(from: article.media_title).uppercased()
        self.articleSourceNameLabel.text = ""
        self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.timeRelative))
        
//        if(sourceName.count<=10) {
//            self.articleSourceNameLabel.text = sourceName
//            self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.timeRelative))
//        } else {
//            self.articleSourceNameLabel.text = sourceName + "\n" + SHORT_TIME(input:FIX_TIME(article.timeRelative))
//            self.articleTimeLabel.text = ""
//        }
        
        
        self.articleStanceIcon.setValues(article.LR, article.PE)
        
        for V in self.storyComponents {
            V.hide()
        }
        for V in self.articleComponents {
            V.show()
        }
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.articleSource.show()
            self.sourceTime_leading?.constant = 4
        } else {
            self.articleSource.customHide()
            self.sourceTime_leading?.constant = 0
        }
        
        if(PREFS_SHOW_FLAGS()) {
            self.articleFlag.setFlag(article.media_country_code)
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
    
    
    func populate(spin: Spin) {
        //print("from Spin?")
    
        self.openIcon.show()
        self.article = MainFeedArticle(url: spin.url)
        self.article.LR = spin.LR
        self.article.PE = spin.CP
        self.article.country = spin.media_country_code
        self.article.source = spin.media_name
        ///

        self.mainImageView.load(url: spin.image) { (sucess, size) in
            
        }
        self.mainImageView.showCorners(false)
        
        //self.articleTitleLabel.font = CSS.shared.iPhoneStory_titleFont_small
        self.articleTitleLabel.text = spin.subTitle
            
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: spin.media_title) {
            sourcesArray.append(_identifier)
        }
        self.articleSource.load(sourcesArray)
        
        let sourceName = CLEAN_SOURCE(from: article.source).uppercased()
        self.articleSourceNameLabel.text = ""
        self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
        
//        if(sourceName.count<=10) {
//            self.articleSourceNameLabel.text = sourceName
//            self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(article.time))
//        } else {
//            self.articleSourceNameLabel.text = sourceName + "\n" + SHORT_TIME(input:FIX_TIME(article.time))
//            self.articleTimeLabel.text = ""
//        }
        
        
        self.articleStanceIcon.setValues(spin.LR, spin.CP)
        
        for V in self.storyComponents {
            V.hide()
        }
        for V in self.articleComponents {
            V.show()
        }
        
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.articleSource.show()
            self.sourceTime_leading?.constant = 5
        } else {
            self.articleSource.customHide()
            self.sourceTime_leading?.constant = 0
        }
        
        if(PREFS_SHOW_STANCE_ICONS()) {
            self.articleStanceIcon.show()
        } else {
            self.articleStanceIcon.hide()
        }
        
        if(PREFS_SHOW_FLAGS()) {
            self.articleFlag.setFlag(spin.media_country_code)
            self.articleFlag.customShow()
            self.source_leading?.constant = 2
            if(!PREFS_SHOW_SOURCE_ICONS()) {
                self.source_leading?.constant = 5
            }
        } else {
            self.articleFlag.customHide()
            self.source_leading?.constant = 0
        }
        
        if(spin.LR==0 && spin.CP==0) {
            if let button = self.viewWithTag(64) {
                button.hide()
                self.articleStanceIcon.hide()
            }
        }
    }
    
    override func populate(_ article: MainFeedArticle) {
        //print("from MAIN_FEED, SEARCH, ABOUT")
        
        self.openIcon.hide()
        self.isContext = article.isContext
        if(self.isContext) {
            self.storyPill.setAsContext()
        } else {
            self.storyPill.setAsStory()
        }
        
        self.article = article
        
//        if let _videoFile = article.videoFile {
//            if let _url = URL(string: YOUTUBE_GET_THUMB_IMG(id: _videoFile)) {
//                self.mainImageView.sd_setImage(with: _url)
//            }
//        } else {
//            self.mainImageView.load(url: article.imgUrl)
//        }
        
        self.mainImageView.load(url: article.imgUrl)
        
//        if(!self.isContext) {
//            
//        } else {
//            
//        }
        self.mainImageView.showCorners(self.article.isStory)
        
        if(article.isStory) {
            self.storyTitleLabel.text = article.title
            if let _searchTerm = KeywordSearch.searchTerm {
                self.storyTitleLabel.remarkSearchTerm(_searchTerm, color: CSS.shared.displayMode().main_textColor)
            }
            
            if(self.minimumLineNum) {
                let numLines = self.storyTitleLabel.calculateHeightFor(width: self.WIDTH) / self.storyTitleLabel.font.lineHeight
                let diff = MAX_NUM_LINES_B - Int(numLines)
                if(diff>0) {
                    for _ in 1...diff {
                        self.storyTitleLabel.text! += "\n"
                    }
                }
            }
            
            self.storySources.load(article.storySources)
            self.storyTimeLabel.text = SHORT_TIME(input: FIX_TIME(article.time))
        } else {
            self.articleTitleLabel.text = article.title
//            if let _searchTerm = KeywordSearch.searchTerm {
//                self.articleTitleLabel.remarkSearchTerm(_searchTerm, color: CSS.shared.displayMode().sec_textColor)
//            }
            self.articleTitleLabel.setLineSpacing(lineSpacing: 6.0)
                        
            let numLines = self.articleTitleLabel.calculateHeightFor(width: self.WIDTH) / self.articleTitleLabel.font.lineHeight
            let diff = MAX_NUM_LINES_B - Int(numLines)
            
            if(diff>0) {
                for _ in 1...diff {
                    self.articleTitleLabel.text! += "\n"
                }
            }
            
            
            
            
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
            
            
            
            //+ "    " + SHORT_TIME(input:FIX_TIME(article.time))
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
        
        if(self.article.isStory) {
            if(PREFS_SHOW_SOURCE_ICONS()) {
                self.storySources.show()
            } else {
                self.storySources.customHide()
            }
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
                if(article.country != "LINK") {
                    self.articleStanceIcon.show()
                } else {
                    self.articleStanceIcon.hide()
                }
                
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

    }
    
    override func refreshDisplayMode() {
        if(KeywordSearch.searchTerm == nil || self.ignoreSearch) {
            self.storyTitleLabel.textColor = CSS.shared.displayMode().main_textColor
            self.articleTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        }
        
        
        if(!self.isContext) {
            self.storyPill.refreshDisplayMode()
        }
        
        self.storySources.refreshDisplayMode()
        self.storyTimeLabel.textColor = CSS.shared.displayMode().sec_textColor
        
        self.articleSource.refreshDisplayMode()
        self.articleSourceNameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.articleTimeLabel.textColor = self.articleSourceNameLabel.textColor
        self.articleStanceIcon.refreshDisplayMode()
        self.openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        
        self.mainImageView.refreshDisplayMode()
    }
    
    // MARK: misc
    private func calculateHeightForStory() -> CGFloat {
        return self.storyTitleLabel.calculateHeightFor(width: self.WIDTH)
    }
    
    private func calculateHeightForArticle() -> CGFloat {
        return self.articleTitleLabel.calculateHeightFor(width: self.WIDTH)
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding
        if(self.article == nil){ return 0 }
        
        if(self.article.isStory) {
            result += self.calculateHeightForStory()
        } else {
            result += self.calculateHeightForArticle()
        }

        return result + (12 + 32) + 25
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour_old?.cancel()
        if(self.article.isEmpty()) { return }
        
        if(self.article.isStory) {
            let vc = StoryViewController()
            vc.story = self.article
            vc.isContext = self.isContext
            CustomNavController.shared.pushViewController(vc, animated: true)
        } else {
            let vc = ArticleViewController()
            vc.article = article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
}

extension iPhoneAllNews_vImgCol_v3_B: StanceIconViewDelegate {
    
    func onStanceIconTap(sender: StanceIconView) {
//        let info: [String : Any] = [
//            "LR": self.article.LR,
//            "PE": self.article.PE,
//            "source": CLEAN_SOURCE(from: self.article.source),
//            "country": self.article.country
//        ]
//        NOTIFY(Notification_stanceIconTap, userInfo: info)
        
        let popup = StancePopupView()
        let sourceName = CLEAN_SOURCE(from: self.article.source)
        popup.populate(sourceName: sourceName, country: self.article.country,
            LR: self.article.LR, PE: self.article.PE)
        popup.pushFromBottom()
    }
    
}
