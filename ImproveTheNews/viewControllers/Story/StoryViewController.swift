//
//
//  StoryViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import UIKit
import SDWebImage
import WebKit


class StoryViewController: BaseViewController {
    
    var story: MainFeedArticle?
    var storyID: String = ""
    
    var storyData = StoryContent()
    var groupedSources = [(String, String)]()
    
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    var time_leading: NSLayoutConstraint?
    
    var show3 = true
    var facts: [Fact]!
    var spins: [Spin]!
    var articles: [StoryArticle]!
    var controversies: [ControversyListItem]!
    
    var imageHeightConstraint: NSLayoutConstraint? = nil
    
    var imageCreditUrl: String = ""
    var audioPlayer = AudioPlayerView()
    var secondaryAudioPlayer = AudioPlayerView(secondary: true)
    var titleLabelHeight: CGFloat = 0
    var lastSourceIndex = -1
    
    var isContext: Bool = false
    var thirdPillText = ""
    
    var sections_y = [CGFloat]()
    var backGoTo: Int = -1
    var iPad_W: CGFloat = -1
    
    var loadedImage: UIImage? = nil
    var loadedStory: MainFeedStory!
    var deepDive: DeepDiveContent? = nil
    
    var webBrowser: WKWebView? = nil
    var goDeeperStories = [StorySearchResult]()
    var sectionViewHeightConstraint: NSLayoutConstraint? = nil
    
    var upButton = UIButton(type: .custom)
    var upButtonBottomConstraint: NSLayoutConstraint?
    
    var showSplitSource: Bool = false
    var collapsableSources: [CollapsableSources] = []
    
    var deepDiveContent_VStack = UIStackView()
    var mediaList = [String]()
    var cSourcesView: CollapsableSources? = nil
    var deepDiveImageLinks: [String] = []
    var tags: [Tag] = []
    
    
    deinit {
        self.audioPlayer.close()
        self.secondaryAudioPlayer.close()
        
        self.hideLoading()
    }
    
    // MARK: - Init/Start
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.customBack, .headlines, .share])
            if(self.story != nil) {
                self.navBar.setShareUrl(self.story!.url, vc: self)
            }
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.isContext = false
        if let _story = self.story {
            self.isContext = _story.isContext
        }
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
                
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.delegate = self
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -13),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
                
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onCustomBackButtonTap),
            name: Notification_customBackButtonTap, object: nil)
        
        self.scrollView.hide()
        self.refreshDisplayMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
        
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        //DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    }
    
}

// MARK: - Data
extension StoryViewController {
    
    private func loadContent() {
        self.showLoading()

        if(!self.storyID.isEmpty) {
            self.storyData.getStoryData(storyID: self.storyID) { (story, deepDive) in
                if(story == nil) {
                    // Empty story content
                    ALERT(vc: self, title: "Server error",
                    message: "Trouble loading your story,\nplease try again later.", onCompletion: {
                        CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    MAIN_THREAD {
                        self.hideLoading()
                        self.scrollView.show()
                        
                        if let _story = story {                        
                            self.mediaList = _story.mediaList
                            self.story = MainFeedArticle(story: _story)
                        
                            self.loadedStory = _story
                            self.deepDive = deepDive
                            self.addContent(_story, deepDive)
                            
                            DELAY(1.0) {
                                self.calculateSectionsY()
                            }
                        }
                    }
                }
            }
            
        } else {
            ///
            self.storyData.load(url: self.story!.url) { (story, deepDive) in
                if(story == nil) {
                    // Empty story content
                    ALERT(vc: self, title: "Server error",
                    message: "Trouble loading your story,\nplease try again later.", onCompletion: {
                        CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    MAIN_THREAD {
                        self.hideLoading()
                        self.scrollView.show()
                        
                        if let _story = story {
                            self.mediaList = _story.mediaList
                            self.loadedStory = _story
                            self.deepDive = deepDive
                            self.addContent(_story, deepDive)
                            
                            DELAY(1.0) {
                                self.calculateSectionsY()
                            }
                        }
                    }
                }
            }
            ///
        }
    }
    
    private func groupSources() {
        self.groupedSources = [(String, String)]()
        for (i, F) in self.facts.enumerated() {
            var found = false
            for (j, S) in self.groupedSources.enumerated() {
                if(S.0==F.source_title && S.1==F.source_url) {
                    found = true
                    self.facts[i].sourceIndex = j
                    break
                }
            }
            
            if(!found) {
                self.groupedSources.append( (F.source_title, F.source_url) )
                self.facts[i].sourceIndex = self.groupedSources.count-1
            }
        }
    }
    
}

// MARK: - Content
extension StoryViewController {

    func addContent(_ story: MainFeedStory, _ deepDive: DeepDiveContent?) {
        if(self.webBrowser != nil) {
            REMOVE_ALL_CONSTRAINTS(from: self.webBrowser!)
            self.VStack.removeArrangedSubview(self.webBrowser!)
        }
        
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
//        let line2 = UIView()
//        self.VStack.addArrangedSubview(line2)
//        line2.activateConstraints([
//            line2.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        ADD_HDASHES(to: line2)
        
        //self.addPill()
        
        self.thirdPillText = ""
        if(story.goDeeper.count > 0) {
            self.thirdPillText = "Go deeper"
        } else if(story.articles.count > 0) {
            if(!story.splitType.isEmpty) {
                self.thirdPillText = "Split"
            } else {
                self.thirdPillText = "Articles"
            }
        }
        
//        if(story.splitType.isEmpty) {
//            if(self.isContext) {
//                self.thirdPillText = "Go deeper"
//            } else {
//                if(story.articles != nil) {
//                    if(story.articles.count>0) {
//                        self.thirdPillText = "Articles"
//                    }
//                }
//            }
//        } else {
//            self.thirdPillText = "Split"
//        }
        
        if(self.deepDive == nil) {
            self.addTabs()
        }
        
        self.addTitle(text: story.title)
        
        self.addTags(story.tags)
        self.addAudioPlayer(story.audio)
        
        if(self.isContext) {
            if(story.video.isEmpty) {
                self.addImage(imageUrl: story.image_src)
            } else {
                self.story?.videoFile = story.video
                self.addVideo()
            }
        } else {
            self.addImage(imageUrl: story.image_src)
        }
        
//        print(self.story!.time)
//        print(story.time)
        
//        if(!self.story!.time.isEmpty) { // self.story
//            self.addTime(time: self.story!.time)
//        }
//        if(!story.time.isEmpty) { // self.story
//            self.addTime(time: story.time)
//        }
//        
        
        self.addStoryMetaData(figures: story.figures, time: story.time)
        if(!story.image_credit_title.isEmpty && !story.image_credit_url.isEmpty) {
            self.addImageCredit(story.image_credit_title, story.image_credit_url,
                description: story.image_description, time: story.time)
        }
        self.addDeepDiveSections()

//        story.time
//
//        MainFeedArticle
//        MainFeedStory
        
        self.facts = story.facts
        self.groupSources()
        
        if(self.deepDive == nil) {
            self.addFactsStructure()
                //self.facts = story.facts
                //self.groupSources()
                
            if(self.showSplitSource) {
                self.populateFacts_new()
            } else {
                self.populateFacts()    // works with self.facts
            }
        
            if(self.showSplitSource) {
                if(IPHONE()) {
                    self.addSourceSplitGraph(container: self.VStack)
                } else {
                    if let _container = self.view.viewWithTag(555) as? UIStackView {
                        self.addSourceSplitGraph(container: _container)
                    }
                }
            } else {
                self.addSourcesStructure()
                self.populateSources()
            }
        } else {
            self.addDeepDiveContentStructure()
            self.showDeepDiveContent(forIndex: 0)
        }

        if(self.deepDive == nil) {
            self.addSpins(story.spins)
        }
        
        self.addPublicFigures(story.figures)
        self.addControversies(story.controversies)

        if(story.goDeeper.count > 0) {
            self.addGoDeeper(stories: story.goDeeper)
        }
        if(story.articles.count > 0) {
            self.addArticles(story.articles)
        }
        
        if(!story.splitType.isEmpty) {
            if(story.articles.count > 0) {
                self.addSplitArticles(type: story.splitType, story.articles)
            }
        }
        
//        if(story.splitType.isEmpty) {
//            if(self.isContext) {
//                self.addGoDeeper(stories: story.goDeeper)
//            } else {
//                self.addArticles(story.articles)
//            }
//        } else {
//            self.addSplitArticles(type: story.splitType, story.articles)
//        }
        
        if(story.audio != nil) {
            ADD_SPACER(to: VStack, height: 200)
        }
        
        // TMP //------------------------------------------
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.VStack.backgroundColor = .clear

//        DELAY(1.0) {
//            self.scrollToBottom()
//        }
        self.addUpButton(audioFile: story.audio)

    }

    //----
    func addTabs() {
    ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding*1.5)
        let containerView = UIView()
        self.VStack.addArrangedSubview(containerView)
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let W = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding*4))/3
        var val_X: CGFloat = CSS.shared.iPhoneSide_padding
        
        for i in 1...3 {
            let tab = UIView()
            tab.backgroundColor = CSS.shared.displayMode().main_bgColor
            tab.layer.cornerRadius = 20
            tab.layer.borderWidth = 1.0
            tab.layer.borderColor = CSS.shared.displayMode().line_color.cgColor
            
            containerView.addSubview(tab)
            tab.activateConstraints([
                tab.heightAnchor.constraint(equalToConstant: 40),
                tab.widthAnchor.constraint(equalToConstant: W),
                tab.topAnchor.constraint(equalTo: containerView.topAnchor),
                tab.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_X)
            ])
            
            let label = UILabel()
            label.text = "oOoOoOoOo"
            label.font = CSS.shared.topicSelector_font
            label.textColor = CSS.shared.displayMode().sec_textColor
            tab.addSubview(label)
            label.activateConstraints([
                label.centerXAnchor.constraint(equalTo: tab.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: tab.centerYAnchor)
            ])
            
            switch(i) {
                case 1:
                    label.text = "The Facts"
                case 2:
                    label.text = "The Spin"
                case 3:
                    label.text = self.thirdPillText
                
                default:
                    NOTHING()
            }
            
            let button = UIButton(type: .system)
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            tab.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: tab.leadingAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: tab.trailingAnchor, constant: 5),
                button.topAnchor.constraint(equalTo: tab.topAnchor, constant: -5),
                button.bottomAnchor.constraint(equalTo: tab.bottomAnchor, constant: 5)
            ])
            button.tag = 300 + i
            button.addTarget(self, action: #selector(onTabButtonTap(_:)), for: .touchUpInside)
            
            //------------------
            val_X += W + CSS.shared.iPhoneSide_padding
            
            if(i==3 && self.thirdPillText.isEmpty) {
                tab.hide()
            }
        }
        
    ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    @objc func onTabButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        
        var val_Y: CGFloat = 0
        
        var view = UIView()
        switch(tag) {
            case 1:
                if let _view = self.view.viewWithTag(140) {
                    val_Y = -self.contentView.convert(_view.frame.origin, to: _view).y
                }
            case 2:
                if let _view = self.view.viewWithTag(160) {
                    val_Y = self.contentView.convert(_view.frame.origin, to: self.scrollView).y
                }
            case 3:
                if let _view = self.view.viewWithTag(170) {
                    val_Y = self.contentView.convert(_view.frame.origin, to: self.scrollView).y
                }
        
            default:
                NOTHING()
        }
         
        let limit = self.contentView.frame.size.height - self.scrollView.frame.size.height
        if(val_Y > limit){ val_Y = limit }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: val_Y), animated: true)
    }
    
    private func addGoDeeper(stories: [StorySearchResult]) {
        self.goDeeperStories = stories
        if(stories.count==0){ return }
        
        let sectionView = UIView()
        sectionView.tag = 170
        self.VStack.addArrangedSubview(sectionView)
        
        let title = UILabel()
        title.textColor = CSS.shared.displayMode().main_textColor
        //title.backgroundColor = .red.withAlphaComponent(0.3)
        title.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
        title.text = "Go Deeper"
        sectionView.addSubview(title)
        title.activateConstraints([
            title.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15)
        ])
        
        var W: CGFloat = SCREEN_SIZE().width - (15*2)
        var posY: CGFloat = 20 + title.calculateHeightFor(width: W) + 20
        W = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 3))/2
        
        var count = 0
        while(self.goDeeperStories.count>0) {

            let colsHStack = HSTACK(into: sectionView, spacing: CSS.shared.iPhoneSide_padding)
            //colsHStack.backgroundColor = .green
            colsHStack.activateConstraints([
                colsHStack.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor,
                    constant: CSS.shared.iPhoneSide_padding),
                colsHStack.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor,
                    constant: -CSS.shared.iPhoneSide_padding),
                colsHStack.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: posY)
            ])
            
            var H1: CGFloat = 1
            var H2: CGFloat = 1
            let VIEW1 = iPhoneAllNews_vImgCol_v3(width: W, minimumLineNum: false)
            let VIEW2 = iPhoneAllNews_vImgCol_v3(width: W, minimumLineNum: false)
            
            // item 1
            if let _A = self.goDeeperStories.first {
                VIEW1.refreshDisplayMode()
                VIEW1.populate(story: _A)
                if(_A.type == 2){ self.adaptToGoDeeper(view: VIEW1) }
                else if(_A.type == 3){ self.adaptToDeepDive(view: VIEW1) }
//                self.adaptToGoDeeper(view: VIEW1)
                                
                H1 = VIEW1.calculateHeight()
                colsHStack.addArrangedSubview(VIEW1)
                VIEW1.activateConstraints([
                    VIEW1.widthAnchor.constraint(equalToConstant: W)
                ])
                
                self.goDeeperStories.removeFirst()
                count += 1
            } else {
                H1 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            // item 2
            if let _A = self.goDeeperStories.first {
                VIEW2.refreshDisplayMode()
                VIEW2.populate(story: _A)
                if(_A.type == 2){ self.adaptToGoDeeper(view: VIEW2) }
                else if(_A.type == 3){ self.adaptToDeepDive(view: VIEW2) }
//                self.adaptToGoDeeper(view: VIEW2)
                
                H2 = VIEW2.calculateHeight()
                colsHStack.addArrangedSubview(VIEW2)
                VIEW2.activateConstraints([
                    VIEW2.widthAnchor.constraint(equalToConstant: W)
                ])
                
                self.goDeeperStories.removeFirst()
                count += 1
            } else {
                H2 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            let maxH = (H1 > H2) ? H1 : H2
            VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
            VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true

            posY += maxH
            
            if(count >= 20) {
                break
            }
        }
        
        self.sectionViewHeightConstraint = nil
        self.sectionViewHeightConstraint = sectionView.heightAnchor.constraint(equalToConstant: posY)
        self.sectionViewHeightConstraint?.isActive = true
    }

    func adaptToGoDeeper(view _V: iPhoneAllNews_vImgCol_v3) {
        _V.isContext = true
        _V.storyPill.setAsContext()
        _V.storyPill.show()
        
        
//        if(_V.storySources.count <= 1) {
//            _V.storyTimeLeadingConstraint?.constant = 53 + 8
//        } else {
//            _V.storyTimeLeadingConstraint?.constant = 0
//        }
        
        _V.storySources.hide()
        _V.storySources.widthConstraint?.constant = 0
        
        _V.storyTimeLeadingConstraint?.constant = 53 + 8
    }
    
    func adaptToDeepDive(view _V: iPhoneAllNews_vImgCol_v3) {
        _V.isContext = true
        _V.storyPill.setAsDeepDive()
        _V.storyPill.show()
                
        _V.storySources.show()
        _V.storySourcesLeadingConstraint?.constant = 63 + 8
                
        _V.storyTimeLabel.show()
        _V.storyTimeLeadingConstraint?.constant = 8
        _V.showShortestDate()
    }

    // ------------------------------------------
    private func addArticles(_ articles: [StoryArticle]) {
        self.articles = articles
        ADD_SPACER(to: self.VStack, height: 12)
    
        let HStack = HSTACK(into: self.VStack)
        HStack.tag = 170
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
        if(articles.count == 0) {
            let noArticlesLabel = UILabel()
            noArticlesLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noArticlesLabel.text = "No articles available"
            noArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(noArticlesLabel)
        } else {
            let ArticlesLabel = UILabel()
            ArticlesLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            ArticlesLabel.numberOfLines = 0
            ArticlesLabel.text = "Articles on this story"
            if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
            }
            ArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(ArticlesLabel)
            
            ADD_SPACER(to: innerHStack, height: 12)
            //for (i, A) in articles.enumerated() {
            
            let W = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 3))/2
            var artNum = 0
            var completed = false
            while(!completed) {
                let colsHStack = HSTACK(into: innerHStack, spacing: CSS.shared.iPhoneSide_padding)
                
                var H1: CGFloat = 0
                var H2: CGFloat = 0
                var VIEW1: CustomCellView_v3!
                var VIEW2: CustomCellView_v3!
                
                if(TEXT_IMAGES()) {
                    VIEW2 = iPhoneAllNews_vImgCol_v3(width: W)
                } else {
                    VIEW2 = iPhoneAllNews_vTxtCol_v3(width: W)
                }

                let A1 = articles[artNum]
                if(TEXT_IMAGES()) {
                    VIEW1 = iPhoneAllNews_vImgCol_v3(width: W)
                } else {
                    VIEW1 = iPhoneAllNews_vTxtCol_v3(width: W)
                }
                
                VIEW1.refreshDisplayMode()
                if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                    _V1.populate(article: A1)
                    _V1.ignoreSearch = true
                    _V1.refreshDisplayMode()
                } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                    let _A1 = MainFeedArticle(story: A1)
                    _V1.populate(_A1)
                }
                
                if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                    H1 = _V1.calculateHeight()
                } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                    H1 = _V1.calculateHeight()
                }

                colsHStack.addArrangedSubview(VIEW1)
                VIEW1.activateConstraints([
                    VIEW1.widthAnchor.constraint(equalToConstant: W)
                ])
                artNum += 1
                
                if(artNum == articles.count) {
                    H2 = 1
                    ADD_SPACER(to: colsHStack, width: W)
                    completed = true
                } else {
                    let A2 = articles[artNum]
                    VIEW2.refreshDisplayMode()
                    
                    if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                        _V2.populate(article: A2)
                        _V2.ignoreSearch = true
                        _V2.refreshDisplayMode()
                    } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                        let _A2 = MainFeedArticle(story: A2)
                        _V2.populate(_A2)
                    }

                    if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                        H2 = _V2.calculateHeight()
                    } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                        H2 = _V2.calculateHeight()
                    }
                    
                    colsHStack.addArrangedSubview(VIEW2)
                    VIEW2.activateConstraints([
                        VIEW2.widthAnchor.constraint(equalToConstant: W),
                        
                    ])
                    
                    artNum += 1
                    if(artNum == articles.count) {
                        completed = true
                    }
                }
                
                var maxH = (H1 > H2) ? H1 : H2
                VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
                VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true
                
                if(VIEW1 is iPhoneAllNews_vImgCol_v3) {
                    
                }
            }
            // --- //
        }
    }
    
    private func addSplitArticles(type: String, _ articles: [StoryArticle]) {
        self.articles = articles
        ADD_SPACER(to: self.VStack, height: 12)

        let HStack = HSTACK(into: self.VStack)
        HStack.tag = 170
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
       if(articles.count == 0) {
            let noArticlesLabel = UILabel()
            noArticlesLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noArticlesLabel.text = "No articles available"
            noArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(noArticlesLabel)
        } else {
            var H: CGFloat = 0
        
            var title = "Political Split"
            if(type.uppercased() == "PE") {
                title = "Establishment Split"
            }
        
            let ArticlesLabel = UILabel()
            ArticlesLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            ArticlesLabel.text = title
            if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
            }
            ArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(ArticlesLabel)
            ADD_SPACER(to: innerHStack, height: 15)
        
        /// headers
            let headers = UIView()
            //headers.backgroundColor = .red.withAlphaComponent(0.5)
            innerHStack.addArrangedSubview(headers)
            headers.activateConstraints([
                headers.heightAnchor.constraint(equalToConstant: 45)
            ])
            H += 45
            
            var T1 = "LEFT"
            var T2 = "RIGHT"
            if(type.uppercased() == "PE") {
                T1 = "CRITICAL"
                T2 = "PRO"
            }
            
            for i in 1...2 {
                let headerLabel = UILabel()
                headerLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                headerLabel.textColor = CSS.shared.displayMode().header_textColor
                headerLabel.textAlignment = .center
                
                let W = SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding*3)
                
                headers.addSubview(headerLabel)
                headerLabel.activateConstraints([
                    headerLabel.widthAnchor.constraint(equalToConstant: W/2),
                    headerLabel.centerYAnchor.constraint(equalTo: headers.centerYAnchor)
                ])
                
                if(i==1) {
                    headerLabel.leadingAnchor.constraint(equalTo: headers.leadingAnchor).isActive = true
                    headerLabel.text = T1
                } else {
                    headerLabel.leadingAnchor.constraint(equalTo: headers.leadingAnchor,
                        constant: (W/2) + CSS.shared.iPhoneSide_padding).isActive = true
                    headerLabel.text = T2
                }
            }
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding/2)
        /// headers
            
            // Sorting --------------------------------
            var articlesLeft = [StoryArticle]()
            var articlesRight = [StoryArticle]()
            var articlesNeutral = [StoryArticle]()
            
            for A in articles {
                if(!A.image.isEmpty && !A.title.isEmpty && !A.media_title.isEmpty) {
                    var value = 1
                    if(type.uppercased() == "PE") { value = A.PE } else { value = A.LR }
                    
                    if(value < 3) {
                        articlesLeft.append(A)
                    } else if(value > 3) {
                        articlesRight.append(A)
                    } else {
                        articlesNeutral.append(A)
                    }
                }
            }
            
            // Show columns --------------------------------
            var colsHStack = UIStackView()
            let W = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 3))/2
            
            while(articlesLeft.count>0 || articlesRight.count>0) {
                let aLeft = articlesLeft.first
                let aRight = articlesRight.first
                
                colsHStack = HSTACK(into: innerHStack, spacing: CSS.shared.iPhoneSide_padding)
                
                var H1: CGFloat = 1
                var H2: CGFloat = 1
                var VIEW1: CustomCellView_v3!
                var VIEW2: CustomCellView_v3!
                
                if(TEXT_IMAGES()) {
                    VIEW1 = iPhoneAllNews_vImgCol_v3(width: W)
                    VIEW2 = iPhoneAllNews_vImgCol_v3(width: W)
                } else {
                    VIEW1 = iPhoneAllNews_vTxtCol_v3(width: W)
                    VIEW2 = iPhoneAllNews_vTxtCol_v3(width: W)
                }

                // item 1
                if let _A = aLeft {
                    VIEW1.refreshDisplayMode()
                    
                    // Populate
                    if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                        _V1.populate(article: _A)
                    } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                        let _A1 = MainFeedArticle(story: _A)
                        _V1.populate(_A1)
                    }
                    
                    // Height
                    if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                        H1 = _V1.calculateHeight()
                    } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                        H1 = _V1.calculateHeight()
                    }
                    
                    colsHStack.addArrangedSubview(VIEW1)
                    VIEW1.activateConstraints([
                        VIEW1.widthAnchor.constraint(equalToConstant: W)
                    ])
                    articlesLeft.removeFirst()
                } else {
                    H1 = 0
                    ADD_SPACER(to: colsHStack, width: W)
                }
                
                // item 2
                if let _A = aRight {
                    VIEW2.refreshDisplayMode()
                    
                    // Populate
                    if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                        _V2.populate(article: _A)
                    } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                        let _A2 = MainFeedArticle(story: _A)
                        _V2.populate(_A2)
                    }
                    
                    // Height
                    if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                        H2 = _V2.calculateHeight()
                    } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                        H2 = _V2.calculateHeight()
                    }
                    
                    colsHStack.addArrangedSubview(VIEW2)
                    VIEW2.activateConstraints([
                        VIEW2.widthAnchor.constraint(equalToConstant: W)
                    ])
                    articlesRight.removeFirst()
                } else {
                    H2 = 0
                    ADD_SPACER(to: colsHStack, width: W)
                }
                
                let maxH = (H1 > H2) ? H1 : H2
                VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
                VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true
                
                ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
                H += maxH + CSS.shared.iPhoneSide_padding
            }
            
            // Vertical divider --------------------------------
            let line = UIView()
            line.backgroundColor = CSS.shared.displayMode().line_color
            innerHStack.addSubview(line)
            line.activateConstraints([
                line.widthAnchor.constraint(equalToConstant: 1),
                line.centerXAnchor.constraint(equalTo: innerHStack.centerXAnchor),
                line.topAnchor.constraint(equalTo: headers.topAnchor),
                line.bottomAnchor.constraint(equalTo: colsHStack.bottomAnchor)
            ])
            ADD_VDASHES(to: line, height: H)
            
            self.addNeutralArticles(type: type, articlesNeutral)
        }
    }
    
    private func addNeutralArticles(type: String, _ articles: [StoryArticle]) {
        if(articles.count==0){ return }
        
        ADD_SPACER(to: self.VStack, height: 22)
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 12)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 12)
        
        var title = "More neutral "
        if(type.uppercased() == "PE") {
            title += "establishment"
        } else {
            title += "political"
        }
        title += " stance articles"
        
            
        let ArticlesLabel = UILabel()
        ArticlesLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
        ArticlesLabel.numberOfLines = 0
        ArticlesLabel.text = title
        if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
        }
        ArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
        innerHStack.addArrangedSubview(ArticlesLabel)
        ADD_SPACER(to: innerHStack, height: 18)
        
        var articlesCopy = articles
        // Show columns --------------------------------
        let W = (SCREEN_SIZE_iPadSideTab().width - (CSS.shared.iPhoneSide_padding * 3))/2
        
        while(articlesCopy.count>0) {
            let aLeft = articlesCopy.first
            var aRight: StoryArticle? = nil
            if(articlesCopy.count>1){ aRight = articlesCopy[1] }
            
            let colsHStack = HSTACK(into: innerHStack, spacing: CSS.shared.iPhoneSide_padding)
            var H1: CGFloat = 1
            var H2: CGFloat = 1
            var VIEW1: CustomCellView_v3!
            var VIEW2: CustomCellView_v3!
            
            if(TEXT_IMAGES()) {
                VIEW1 = iPhoneAllNews_vImgCol_v3(width: W)
                VIEW2 = iPhoneAllNews_vImgCol_v3(width: W)
            } else {
                VIEW1 = iPhoneAllNews_vTxtCol_v3(width: W)
                VIEW2 = iPhoneAllNews_vTxtCol_v3(width: W)
            }
            
            // item 1
            if let _A = aLeft {
                VIEW1.refreshDisplayMode()
                
                // Populate
                if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                    _V1.populate(article: _A)
                } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                    let _A1 = MainFeedArticle(story: _A)
                    _V1.populate(_A1)
                }
                
                // Height
                if let _V1 = VIEW1 as? iPhoneAllNews_vImgCol_v3 {
                    H1 = _V1.calculateHeight()
                } else if let _V1 = VIEW1 as? iPhoneAllNews_vTxtCol_v3 {
                    H1 = _V1.calculateHeight()
                }
                
                colsHStack.addArrangedSubview(VIEW1)
                VIEW1.activateConstraints([
                    VIEW1.widthAnchor.constraint(equalToConstant: W)
                ])
            } else {
                H1 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            // item 2
            if let _A = aRight {
                VIEW2.refreshDisplayMode()
                
                // Populate
                if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                    _V2.populate(article: _A)
                } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                    let _A2 = MainFeedArticle(story: _A)
                    _V2.populate(_A2)
                }
                
                // Height
                if let _V2 = VIEW2 as? iPhoneAllNews_vImgCol_v3 {
                    H2 = _V2.calculateHeight()
                } else if let _V2 = VIEW2 as? iPhoneAllNews_vTxtCol_v3 {
                    H2 = _V2.calculateHeight()
                }
                
                colsHStack.addArrangedSubview(VIEW2)
                VIEW2.activateConstraints([
                    VIEW2.widthAnchor.constraint(equalToConstant: W)
                ])
            } else {
                H2 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            let maxH = (H1 > H2) ? H1 : H2
            VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
            VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true
            
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
            
//            let hStackColumns = HSTACK(into: innerHStack)
//            hStackColumns.spacing = 20
//            hStackColumns.distribution = .fillEqually
//            
//            hStackColumns.addArrangedSubview(articleColumnView(aLeft))
//            hStackColumns.addArrangedSubview(articleColumnView(aRight))
//            
            if(aLeft != nil){ articlesCopy.removeFirst() }
            if(aRight != nil){ articlesCopy.removeFirst() }
        }
    }
    
    //private func articleColumnView(_ A: StoryArticle, i: Int) -> UIView {
    private func articleColumnView(_ A: StoryArticle?) -> UIView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        
        if(A == nil) {
            //vStack.backgroundColor = .green
            return vStack
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        vStack.addArrangedSubview(imageView)
        imageView.activateConstraints([
            imageView.heightAnchor.constraint(equalToConstant: 98 * 1.1)
        ])
        imageView.sd_setImage(with: URL(string: A!.image))
        ADD_SPACER(to: vStack, height: 8)
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = DM_SERIF_DISPLAY_fixed(14) //MERRIWEATHER_BOLD(14)
        subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.text = A!.title
        vStack.addArrangedSubview(subTitleLabel)
        ADD_SPACER(to: vStack, height: 8)
        
        let HStack_source = HSTACK(into: vStack)
        HStack_source.activateConstraints([
            HStack_source.heightAnchor.constraint(equalToConstant: 28)
        ])
        if(!A!.media_country_code.isEmpty) {
            let VStack_flag = VSTACK(into: HStack_source)
            //VStack_flag.backgroundColor = .green
            let flagImageView = UIImageView()
            
            if let _image = UIImage(named: A!.media_country_code.uppercased() + "64.png") {
                flagImageView.image = _image
            } else {
                flagImageView.image = UIImage(named: "noFlag.png")
            }
            
            ADD_SPACER(to: VStack_flag, height: 4)
            VStack_flag.addArrangedSubview(flagImageView)
            flagImageView.activateConstraints([
                flagImageView.widthAnchor.constraint(equalToConstant: 20),
                flagImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
            ADD_SPACER(to: VStack_flag, height: 4)
            ADD_SPACER(to: HStack_source, width: 2)
        }
        
        let LR = A!.LR
        let PE = A!.PE
        let sourceName = A!.media_title.components(separatedBy: " #").first!
        self.getSourceIcon(name: sourceName) { (icon) in
            if let _icon = icon {
                let sourcesContainer = UIStackView()
                HStack_source.addArrangedSubview(sourcesContainer)
                ADD_SOURCE_ICONS(data: [_icon.identifier],
                    to: sourcesContainer, containerHeight: 28)
                    
//                LR = _icon.LR
//                PE = _icon.PE
            }
        }
        
        let sourceLabel = UILabel()
        sourceLabel.text = sourceName
        sourceLabel.font = ROBOTO(12)
        sourceLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        HStack_source.addArrangedSubview(sourceLabel)
        ADD_SPACER(to: HStack_source, width: 8)

        let stanceIcon = StanceIconView()
        stanceIcon.tag = 767
        HStack_source.addArrangedSubview(stanceIcon)
        stanceIcon.setValues(LR, PE)
        ADD_SPACER(to: HStack_source) // H fill
        ADD_SPACER(to: vStack) // V fill
        
        let mainButton = UIButton(type: .custom)
        mainButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        vStack.addSubview(mainButton)
        mainButton.activateConstraints([
            mainButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            mainButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        mainButton.tag = 300 + A!.tag
        mainButton.addTarget(self, action: #selector(articleOnTap(_:)), for: .touchUpInside)

        let miniButton = UIButton(type: .custom)
        miniButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        vStack.addSubview(miniButton)
        miniButton.activateConstraints([
            miniButton.leadingAnchor.constraint(equalTo: stanceIcon.leadingAnchor),
            miniButton.trailingAnchor.constraint(equalTo: stanceIcon.trailingAnchor),
            miniButton.topAnchor.constraint(equalTo: stanceIcon.topAnchor),
            miniButton.bottomAnchor.constraint(equalTo: stanceIcon.bottomAnchor)
        ])
        miniButton.tag = 400 + A!.tag
        miniButton.addTarget(self, action: #selector(articleStanceIconOnTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: vStack, height: 20) // Space to next item
        return vStack
    }
    
    func publicFigureItem(_ data: PublicFigureListItem) -> UIView {
        let items_DIM: CGFloat = 92
        let imgs_DIM: CGFloat = 66
        let texts_WIDTH: CGFloat = 160
        
        let mainView = UIView()
        mainView.activateConstraints([
            mainView.widthAnchor.constraint(equalToConstant: items_DIM),
            mainView.heightAnchor.constraint(equalToConstant: items_DIM + 40)
        ])
        
        let borderView = UIView()
        mainView.addSubview(borderView)
        borderView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        borderView.activateConstraints([
            borderView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            borderView.topAnchor.constraint(equalTo: mainView.topAnchor),
            borderView.widthAnchor.constraint(equalToConstant: items_DIM),
            borderView.heightAnchor.constraint(equalToConstant: items_DIM)
        ])
        borderView.layer.cornerRadius = items_DIM/2
        
        let imageView = UIImageView()
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        borderView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: imgs_DIM),
            imageView.heightAnchor.constraint(equalToConstant: imgs_DIM),
            imageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
        imageView.layer.cornerRadius = imgs_DIM/2
        imageView.clipsToBounds = true
        let imageUrl = data.image.replacingOccurrences(of: " ", with: "%20")
        imageView.sd_setImage(with: URL(string: imageUrl))
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.font = AILERON_resize(16)
        nameLabel.textColor = CSS.shared.displayMode().main_textColor
        nameLabel.text = data.title
        mainView.addSubview(nameLabel)
        nameLabel.activateConstraints([
            nameLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: texts_WIDTH),
            nameLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor)
        ])
        
        let buttonArea = UIButton(type: .custom)
        //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
        mainView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: mainView.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        buttonArea.tag = data.id
        buttonArea.addTarget(self, action: #selector(publicFigureItemOnTap(_:)), for: .touchUpInside)
        
        return mainView
    }
    
    @objc func publicFigureItemOnTap(_ sender: UIButton?) {
        if let _item = self.loadedStory.figures.first(where: { $0.id == sender!.tag }) {
            let vc = FigureDetailsViewController()
            vc.slug = _item.slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func addPublicFigures(_ figures: [PublicFigureListItem]) {
        if(figures.count==0) {
            return
        }
    
        let line1 = UIView()
        ADD_HDASHES(to: line1)
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.VStack.addArrangedSubview(line1)
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        // --------
        
        let hLocalStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: hLocalStack, width: 16)
        
            let vLocalStack = VSTACK(into: hLocalStack)

            let figuresLabel = UILabel()
            figuresLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ figuresLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
            }
            figuresLabel.text = "Public figures in this story"
            figuresLabel.textColor = CSS.shared.displayMode().main_textColor
            vLocalStack.addArrangedSubview(figuresLabel)
            ADD_SPACER(to: vLocalStack, height: 8)
            
            let scrollview = UIScrollView()
            scrollview.clipsToBounds = false
            scrollview.heightAnchor.constraint(equalToConstant: 92+40).isActive = true
            vLocalStack.addArrangedSubview(scrollview)
            
            let contentView = UIView()
            contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
            scrollview.addSubview(contentView)
            contentView.activateConstraints([
                contentView.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
                contentView.topAnchor.constraint(equalTo: scrollview.topAnchor),
                contentView.heightAnchor.constraint(equalToConstant: 92+40)
            ])
            
            var val_x: CGFloat = 0
            for F in figures {
//            for _ in 1...10 {
//                let F = figures.first!
            
                let figureView = self.publicFigureItem(F)
                contentView.addSubview(figureView)
                figureView.activateConstraints([
                    figureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: val_x),
                    figureView.topAnchor.constraint(equalTo: contentView.topAnchor)
                ])
                
                val_x += 92 + (92/2)
            }
            contentView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
            scrollview.contentSize = CGSize(width: val_x, height: 92+40)
        
        ADD_SPACER(to: hLocalStack, width: 16)
        
        // --------
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        let line2 = UIView()
        ADD_HDASHES(to: line2)
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.VStack.addArrangedSubview(line2)
    }
    
// -----------------------------
    private func addSpins(_ spins: [Spin]) {
        self.spins = spins
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding*2)
    
        let HStack = HSTACK(into: self.VStack)
        HStack.tag = 160
        
        let innerHStack = VSTACK(into: HStack)
        
       if(spins.count == 0) {
            let noSpinsLabel = UILabel()
            noSpinsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noSpinsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noSpinsLabel.text = "    No spin available"
            noSpinsLabel.textColor = CSS.shared.displayMode().main_textColor
            
            innerHStack.addArrangedSubview(noSpinsLabel)
            
            ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        } else {
            let titleHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
            
                let SpinsLabel = UILabel()
                SpinsLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                if(IPAD()){ SpinsLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
                }
                SpinsLabel.text = "The Spin"
                SpinsLabel.textColor = CSS.shared.displayMode().main_textColor
                titleHStack.addArrangedSubview(SpinsLabel)
                self.addInfoButtonNextTo(label: SpinsLabel, index: 2)
                
            ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
            ADD_SPACER(to: innerHStack, height: 12)
            
            if(IPHONE()) {
                self.addSpins_iPhone(spins, innerHStack: innerHStack)
            } else {
                self.addSpins_iPad(spins, innerHStack: innerHStack)
            }
        }
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    func addSpins_iPad(_ spins: [Spin], innerHStack: UIStackView) {
        let M = CSS.shared.iPhoneSide_padding
        let W = ((SCREEN_SIZE_iPadSideTab().width) - (M * 3))/2
        
        var col = 1
        //for i in 1...3 {
        for (i, S) in spins.enumerated() {
            // Metaculus ----------------------------------------
            if(self.metaculus(S)) {
                if let _mUrl = self.getMetaculusUrl(from: S.url) {
                    let natitleHStack = HSTACK(into: innerHStack)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                        let titleLabel = UILabel()
                        titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                        titleLabel.text = "Metaculus Prediction"
                        titleLabel.numberOfLines = 0
                        titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                        natitleHStack.addArrangedSubview(titleLabel)
                        self.addInfoButtonNextTo(label: titleLabel, index: 4)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    ADD_SPACER(to: innerHStack, height: 10)
                    
                    var _W: CGFloat = 0
                    var _side: CGFloat = 0
                    
                    if(UIDevice.current.orientation == .portrait ||  UIDevice.current.orientation == .portraitUpsideDown) {
                        _side = 16
                    } else {
                        _side = 45
                    }
                    
                    _W = SCREEN_SIZE_iPadSideTab().width - (_side*2)
                    
                    let embedUrl = self.getMetaculusUrl(from: S.url)!
                    let naWebHStack = HSTACK(into: innerHStack)
                    naWebHStack.backgroundColor = CSS.shared.displayMode().main_bgColor
                    ADD_SPACER(to: naWebHStack, width: _side)
                    let webView = WKWebView()
                    webView.navigationDelegate = self
                    webView.load(URLRequest(url: URL(string: embedUrl)!))
                    
                    let H: CGFloat = (9 * _W)/16
                    webView.activateConstraints([
                        webView.heightAnchor.constraint(equalToConstant: floor(H))
                    ])
                    
                    naWebHStack.addArrangedSubview(webView)
                    ADD_SPACER(to: naWebHStack, width: _side)
                
                    continue
                }
            }
            // Metaculus ----------------------------------------
        
            var rowView: UIView!
            if(col==1) {
                rowView = UIView()
                ADD_SPACER(to: innerHStack, width: M)
                    innerHStack.addArrangedSubview(rowView)
                ADD_SPACER(to: innerHStack, width: M)
            } else {
                let _i = innerHStack.arrangedSubviews.count-1-1
                if(_i>=0) {
                    rowView = innerHStack.arrangedSubviews[_i]
                }
            }
            
            var offsetX: CGFloat = M
            if(col==2){ offsetX += W+M }
            
            let colVStack = VSTACK(into: rowView)
            colVStack.activateConstraints([
                colVStack.widthAnchor.constraint(equalToConstant: W),
                colVStack.topAnchor.constraint(equalTo: rowView.topAnchor),
                colVStack.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: offsetX),
                colVStack.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
            ])
            
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let titleLabel = UILabel()
            titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            titleLabel.text = _title
            titleLabel.numberOfLines = 0
            titleLabel.textColor = CSS.shared.displayMode().sec_textColor
            colVStack.addArrangedSubview(titleLabel)
            
            ADD_SPACER(to: colVStack, height: 10)
            let descriptionLabel = UILabel()
            descriptionLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = S.description
            descriptionLabel.setLineSpacing(lineSpacing: 7.0)
            descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
            colVStack.addArrangedSubview(descriptionLabel)
            
            ADD_SPACER(to: colVStack, height: CSS.shared.iPhoneSide_padding)

            let spinDataView = UIView()
            spinDataView.backgroundColor = .clear
            colVStack.addArrangedSubview(spinDataView)
            spinDataView.activateConstraints([
                spinDataView.heightAnchor.constraint(equalToConstant: 32)
            ])

        // Source (icon)
            let spinSource = SourceIconsView(size: 30, border: 2, separation: 15)
            spinSource.buildInto(spinDataView)
            spinSource.activateConstraints([
                spinSource.topAnchor.constraint(equalTo: spinDataView.topAnchor),
                spinSource.leadingAnchor.constraint(equalTo: spinDataView.leadingAnchor, constant: 16)
            ])
            
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: S.media_title) {
                sourcesArray.append(_identifier)
            }
            spinSource.load(sourcesArray)
            
        // Source (name)
            let spinName = UILabel()
            spinName.font = CSS.shared.iPhoneArticle_bigTextFont
            spinName.numberOfLines = 0
            spinName.textColor = CSS.shared.displayMode().main_textColor
            spinName.textAlignment = .left
            spinDataView.addSubview(spinName)
            spinName.activateConstraints([
                spinName.leadingAnchor.constraint(equalTo: spinSource.trailingAnchor, constant: 10),
                spinName.centerYAnchor.constraint(equalTo: spinSource.centerYAnchor)
            ])
            let sourceName = CLEAN_SOURCE(from: S.media_title).uppercased()
            spinName.text = sourceName
            
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
            
            spinDataView.addSubview(openIcon)
            openIcon.activateConstraints([
                openIcon.widthAnchor.constraint(equalToConstant: 12),
                openIcon.heightAnchor.constraint(equalToConstant: 12),
                openIcon.centerYAnchor.constraint(equalTo: spinName.centerYAnchor),
                openIcon.leadingAnchor.constraint(equalTo: spinName.trailingAnchor, constant: 6)
            ])
            openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            
        let buttonArea = UIButton(type: .custom)
        buttonArea.tag = 222 + i
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        spinDataView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: spinSource.leadingAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: openIcon.trailingAnchor, constant: 16),
            buttonArea.topAnchor.constraint(equalTo: spinSource.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: spinSource.bottomAnchor)
        ])
        buttonArea.addTarget(self, action: #selector(self.spinButtonAreaOnTap(_:)), for: .touchUpInside)

            ///
            ADD_SPACER(to: colVStack, height: CSS.shared.iPhoneSide_padding*2)
            
            //***
            col += 1
            if(col==3){ col=1 }
        }
        
        return
        
        ////////////////////////////////////////////////
        

        for (i, S) in spins.enumerated() {
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let natitleHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                let titleLabel = UILabel()
                titleLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
                titleLabel.text = _title
                titleLabel.numberOfLines = 0
                titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                natitleHStack.addArrangedSubview(titleLabel)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
            
            ADD_SPACER(to: innerHStack, height: 10)
            let descrHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding)
                let descriptionLabel = UILabel()
                descriptionLabel.font = CSS.shared.iPhoneStoryContent_textFont
                descriptionLabel.numberOfLines = 0
                //descriptionLabel.backgroundColor = .green.withAlphaComponent(0.2)
                descriptionLabel.text = S.description
                descriptionLabel.setLineSpacing(lineSpacing: 7.0)
                descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
                descrHStack.addArrangedSubview(descriptionLabel)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding + 10)
            
        ///
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
            let ART_HStack = HSTACK(into: innerHStack)
            
            let W = SCREEN_SIZE().width //- (CSS.shared.iPhoneSide_padding * 2)
            let ART = iPhoneArticle_vImg_v3(width: W)
            ART.refreshDisplayMode()
            ART.populate(spin: S)
            ART_HStack.addArrangedSubview(ART)
            ART.activateConstraints([
                ART.heightAnchor.constraint(equalToConstant: ART.calculateHeight())
            ])
            
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
        }
    }
    
    func addSpins_iPhone(_ spins: [Spin], innerHStack: UIStackView, margins: Bool = true) {
        for (i, S) in spins.enumerated() {
            // Metaculus ----------------------------------------
            if(self.metaculus(S)) {
                if let _mUrl = self.getMetaculusUrl(from: S.url) {
                    let natitleHStack = HSTACK(into: innerHStack)
                    if(margins) {
                        ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    }
                        let titleLabel = UILabel()
                        titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                        titleLabel.text = "Metaculus Prediction"
                        titleLabel.numberOfLines = 0
                        titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                        natitleHStack.addArrangedSubview(titleLabel)
                        self.addInfoButtonNextTo(label: titleLabel, index: 4)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    ADD_SPACER(to: innerHStack, height: 10)
                    
                    let embedUrl = self.getMetaculusUrl(from: S.url)!
                    let naWebHStack = HSTACK(into: innerHStack)
                    let webView = WKWebView()
                    webView.navigationDelegate = self
                    webView.load(URLRequest(url: URL(string: embedUrl)!))
                    
                    let H: CGFloat = (9 * SCREEN_SIZE().width)/16
                    webView.activateConstraints([
                        webView.heightAnchor.constraint(equalToConstant: floor(H))
                    ])
                    naWebHStack.addArrangedSubview(webView)
                
                
                    continue
                }
            }
            // Metaculus ----------------------------------------
            
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let natitleHStack = HSTACK(into: innerHStack)
            //natitleHStack.backgroundColor = .green.withAlphaComponent(0.2)
            
            if(margins) {
                ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
            }
            
                let titleLabel = UILabel()
                titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                titleLabel.text = _title
                titleLabel.numberOfLines = 0
                titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                natitleHStack.addArrangedSubview(titleLabel)
            
            if(margins) {
                ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
            }
            
            ADD_SPACER(to: innerHStack, height: 10)
            let descrHStack = HSTACK(into: innerHStack)
            
            if(margins) {
                ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding)
            }
            
                let descriptionLabel = UILabel()
                descriptionLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont
                descriptionLabel.numberOfLines = 0
                //descriptionLabel.backgroundColor = .green.withAlphaComponent(0.2)
                descriptionLabel.text = S.description
                descriptionLabel.setLineSpacing(lineSpacing: 7.0)
                descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
                descrHStack.addArrangedSubview(descriptionLabel)
            
            if(margins) {
                ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding + 10)
            }
            
        ///
//            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
//            let ART_HStack = HSTACK(into: innerHStack)
//            
//            let W = SCREEN_SIZE().width //- (CSS.shared.iPhoneSide_padding * 2)
//            let ART = iPhoneArticle_vImg_v3(width: W)
//            ART.refreshDisplayMode()
//            ART.populate(spin: S)
//            ART_HStack.addArrangedSubview(ART)
//            ART.activateConstraints([
//                ART.heightAnchor.constraint(equalToConstant: ART.calculateHeight())
//            ])
//            
//            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)

            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)

            let spinDataView = UIView()
            spinDataView.backgroundColor = .clear
            innerHStack.addArrangedSubview(spinDataView)
            spinDataView.activateConstraints([
                spinDataView.heightAnchor.constraint(equalToConstant: 32)
            ])

        // Source (icon)
            let spinSource = SourceIconsView(size: 30, border: 2, separation: 15)
            spinSource.buildInto(spinDataView)
            spinSource.activateConstraints([
                spinSource.topAnchor.constraint(equalTo: spinDataView.topAnchor),
                spinSource.leadingAnchor.constraint(equalTo: spinDataView.leadingAnchor, constant: margins ? 16 : 0)
            ])
            
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: S.media_title) {
                sourcesArray.append(_identifier)
            }
            spinSource.load(sourcesArray)
            
        // Source (name)
            let spinName = UILabel()
            spinName.font = CSS.shared.iPhoneArticle_bigTextFont
            spinName.numberOfLines = 0
            spinName.textAlignment = .left
            spinName.textColor = CSS.shared.displayMode().main_textColor
            spinDataView.addSubview(spinName)
            spinName.activateConstraints([
                spinName.leadingAnchor.constraint(equalTo: spinSource.trailingAnchor, constant: 10),
                spinName.centerYAnchor.constraint(equalTo: spinSource.centerYAnchor)
            ])
            let sourceName = CLEAN_SOURCE(from: S.media_title).uppercased()
            spinName.text = sourceName
            
            let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
            
            spinDataView.addSubview(openIcon)
            openIcon.activateConstraints([
                openIcon.widthAnchor.constraint(equalToConstant: 12),
                openIcon.heightAnchor.constraint(equalToConstant: 12),
                openIcon.centerYAnchor.constraint(equalTo: spinName.centerYAnchor),
                openIcon.leadingAnchor.constraint(equalTo: spinName.trailingAnchor, constant: 6)
            ])
            openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            
            let buttonArea = UIButton(type: .custom)
            buttonArea.tag = 222 + i
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            spinDataView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: spinSource.leadingAnchor, constant: -5),
                buttonArea.trailingAnchor.constraint(equalTo: openIcon.trailingAnchor, constant: 16),
                buttonArea.topAnchor.constraint(equalTo: spinSource.topAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: spinSource.bottomAnchor)
            ])
            buttonArea.addTarget(self, action: #selector(self.spinButtonAreaOnTap(_:)), for: .touchUpInside)
              
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding*2)
        }
    }
    
    func addSpins_iPad_iframe(_ spins: [Spin], innerHStack: UIStackView) {
        let M = CSS.shared.iPhoneSide_padding
        let W = ((SCREEN_SIZE_iPadSideTab().width) - (M * 3))/2
        
        var col = 1
        //for i in 1...3 {
        for (i, S) in spins.enumerated() {
            // Metaculus ----------------------------------------
            if(self.metaculus(S)) {
//                if let _mUrl = self.getMetaculusUrl(from: S.url) {
                if let _HTML = self.getMetaculusHTML(from: S.url, width: SCREEN_SIZE_iPadSideTab().width - (M*2)) {
                    let natitleHStack = HSTACK(into: innerHStack)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                        let titleLabel = UILabel()
                        titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                        titleLabel.text = "Metaculus Prediction"
                        titleLabel.numberOfLines = 0
                        titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                        natitleHStack.addArrangedSubview(titleLabel)
                        self.addInfoButtonNextTo(label: titleLabel, index: 4)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    ADD_SPACER(to: innerHStack, height: 10)
                    
//                    let embedUrl = self.getMetaculusUrl(from: S.url)!
                    let naWebHStack = HSTACK(into: innerHStack)
                    ADD_SPACER(to: naWebHStack, width: CSS.shared.iPhoneSide_padding)
                    let webView = WKWebView()
//                    webView.navigationDelegate = self
//                    webView.load(URLRequest(url: URL(string: embedUrl)!))
                    webView.loadHTMLString(_HTML, baseURL: nil)
                    
                    let _W = SCREEN_SIZE_iPadSideTab().width - (M*2)
//                    let H: CGFloat = (9 * _W)/16
                    let H = (430 * _W)/550
                    
                    webView.activateConstraints([
                        webView.heightAnchor.constraint(equalToConstant: floor(H))
                    ])
                    
                    naWebHStack.addArrangedSubview(webView)
                    ADD_SPACER(to: naWebHStack, width: CSS.shared.iPhoneSide_padding)
                                
                    continue
                }
            }
            // Metaculus ----------------------------------------
        
            var rowView: UIView!
            if(col==1) {
                rowView = UIView()
                ADD_SPACER(to: innerHStack, width: M)
                    innerHStack.addArrangedSubview(rowView)
                ADD_SPACER(to: innerHStack, width: M)
            } else {
                let _i = innerHStack.arrangedSubviews.count-1-1
                if(_i>=0) {
                    rowView = innerHStack.arrangedSubviews[_i]
                }
            }
            
            var offsetX: CGFloat = M
            if(col==2){ offsetX += W+M }
            
            let colVStack = VSTACK(into: rowView)
            colVStack.activateConstraints([
                colVStack.widthAnchor.constraint(equalToConstant: W),
                colVStack.topAnchor.constraint(equalTo: rowView.topAnchor),
                colVStack.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: offsetX),
                colVStack.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
            ])
            
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let titleLabel = UILabel()
            titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            titleLabel.text = _title
            titleLabel.numberOfLines = 0
            titleLabel.textColor = CSS.shared.displayMode().sec_textColor
            colVStack.addArrangedSubview(titleLabel)
            
            ADD_SPACER(to: colVStack, height: 10)
            let descriptionLabel = UILabel()
            descriptionLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = S.description
            descriptionLabel.setLineSpacing(lineSpacing: 7.0)
            descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
            colVStack.addArrangedSubview(descriptionLabel)
            
            ADD_SPACER(to: colVStack, height: CSS.shared.iPhoneSide_padding)
            ///
//            let ART = iPhoneArticle_vImg_v3(width: W)
//            ART.refreshDisplayMode()
//            ART.populate(spin: S)
//            colVStack.addArrangedSubview(ART)
//            ART.activateConstraints([
//                ART.heightAnchor.constraint(equalToConstant: ART.calculateHeight())
//            ])

            let spinDataView = UIView()
            spinDataView.backgroundColor = .clear
            colVStack.addArrangedSubview(spinDataView)
            spinDataView.activateConstraints([
                spinDataView.heightAnchor.constraint(equalToConstant: 32)
            ])

        // Source (icon)
            let spinSource = SourceIconsView(size: 30, border: 2, separation: 15)
            spinSource.buildInto(spinDataView)
            spinSource.activateConstraints([
                spinSource.topAnchor.constraint(equalTo: spinDataView.topAnchor),
                spinSource.leadingAnchor.constraint(equalTo: spinDataView.leadingAnchor, constant: 16)
            ])
            
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: S.media_title) {
                sourcesArray.append(_identifier)
            }
            spinSource.load(sourcesArray)
            
        // Source (name)
            let spinName = UILabel()
            spinName.font = CSS.shared.iPhoneArticle_bigTextFont
            spinName.numberOfLines = 0
            spinName.textAlignment = .left
            spinDataView.addSubview(spinName)
            spinName.activateConstraints([
                spinName.leadingAnchor.constraint(equalTo: spinSource.trailingAnchor, constant: 10),
                spinName.centerYAnchor.constraint(equalTo: spinSource.centerYAnchor)
            ])
            let sourceName = CLEAN_SOURCE(from: S.media_title).uppercased()
            spinName.text = sourceName
            
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
            
            spinDataView.addSubview(openIcon)
            openIcon.activateConstraints([
                openIcon.widthAnchor.constraint(equalToConstant: 12),
                openIcon.heightAnchor.constraint(equalToConstant: 12),
                openIcon.centerYAnchor.constraint(equalTo: spinName.centerYAnchor),
                openIcon.leadingAnchor.constraint(equalTo: spinName.trailingAnchor, constant: 6)
            ])
            openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            
        let buttonArea = UIButton(type: .custom)
        buttonArea.tag = 222 + i
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        spinDataView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: spinSource.leadingAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: openIcon.trailingAnchor, constant: 16),
            buttonArea.topAnchor.constraint(equalTo: spinSource.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: spinSource.bottomAnchor)
        ])
        buttonArea.addTarget(self, action: #selector(self.spinButtonAreaOnTap(_:)), for: .touchUpInside)

            ///
            ADD_SPACER(to: colVStack, height: CSS.shared.iPhoneSide_padding*2)
            
            
            //***
            col += 1
            if(col==3){ col=1 }
        }
        
        return
        
        ////////////////////////////////////////////////
        

        for (i, S) in spins.enumerated() {
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let natitleHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                let titleLabel = UILabel()
                titleLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
                titleLabel.text = _title
                titleLabel.numberOfLines = 0
                titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                natitleHStack.addArrangedSubview(titleLabel)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
            
            ADD_SPACER(to: innerHStack, height: 10)
            let descrHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding)
                let descriptionLabel = UILabel()
                descriptionLabel.font = CSS.shared.iPhoneStoryContent_textFont
                descriptionLabel.numberOfLines = 0
                //descriptionLabel.backgroundColor = .green.withAlphaComponent(0.2)
                descriptionLabel.text = S.description
                descriptionLabel.setLineSpacing(lineSpacing: 7.0)
                descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
                descrHStack.addArrangedSubview(descriptionLabel)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding + 10)
            
        ///
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
            let ART_HStack = HSTACK(into: innerHStack)
            
            let W = SCREEN_SIZE().width //- (CSS.shared.iPhoneSide_padding * 2)
            let ART = iPhoneArticle_vImg_v3(width: W)
            ART.refreshDisplayMode()
            ART.populate(spin: S)
            ART_HStack.addArrangedSubview(ART)
            ART.activateConstraints([
                ART.heightAnchor.constraint(equalToConstant: ART.calculateHeight())
            ])
            
            ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
        }
    }
    
    func addSpins_iPhone_iframe(_ spins: [Spin], innerHStack: UIStackView) {
        for (i, S) in spins.enumerated() {
            // Metaculus ----------------------------------------
            if(self.metaculus(S)) {
//                if let _mUrl = self.getMetaculusUrl(from: S.url) {
                if let _HTML = self.getMetaculusHTML(from: S.url, width: SCREEN_SIZE().width) {
                    let natitleHStack = HSTACK(into: innerHStack)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                        let titleLabel = UILabel()
                        titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                        titleLabel.text = "Metaculus Prediction"
                        titleLabel.numberOfLines = 0
                        titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                        natitleHStack.addArrangedSubview(titleLabel)
                        self.addInfoButtonNextTo(label: titleLabel, index: 4)
                    ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    ADD_SPACER(to: innerHStack, height: 10)
                    
//                    let embedUrl = self.getMetaculusUrl(from: S.url)!
                    let naWebHStack = HSTACK(into: innerHStack)
                    let webView = WKWebView()
                    //webView.navigationDelegate = self
                    webView.loadHTMLString(_HTML, baseURL: nil)
                    //webView.load(URLRequest(url: URL(string: embedUrl)!))
                    
//                    let H: CGFloat = (9 * SCREEN_SIZE().width)/16
                    let H = (430 * SCREEN_SIZE().width)/550

                    webView.activateConstraints([
                        webView.heightAnchor.constraint(equalToConstant: floor(H))
                    ])
                    naWebHStack.addArrangedSubview(webView)
                
                    continue
                }
            }
            // Metaculus ----------------------------------------
            
            var _title = S.title
            if(_title.isEmpty) {
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                _title = "Narrative " + letters.getCharAt(index: i)!
            }
            
            let natitleHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                let titleLabel = UILabel()
                titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                titleLabel.text = _title
                titleLabel.numberOfLines = 0
                titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                natitleHStack.addArrangedSubview(titleLabel)
            ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
            
            ADD_SPACER(to: innerHStack, height: 10)
            let descrHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding)
                let descriptionLabel = UILabel()
                descriptionLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont
                descriptionLabel.numberOfLines = 0
                //descriptionLabel.backgroundColor = .green.withAlphaComponent(0.2)
                descriptionLabel.text = S.description
                descriptionLabel.setLineSpacing(lineSpacing: 7.0)
                descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
                descrHStack.addArrangedSubview(descriptionLabel)
            ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding + 10)
            
        ///
        ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)

            let spinDataView = UIView()
            spinDataView.backgroundColor = .clear
            innerHStack.addArrangedSubview(spinDataView)
            spinDataView.activateConstraints([
                spinDataView.heightAnchor.constraint(equalToConstant: 32)
            ])

        // Source (icon)
            let spinSource = SourceIconsView(size: 30, border: 2, separation: 15)
            spinSource.buildInto(spinDataView)
            spinSource.activateConstraints([
                spinSource.topAnchor.constraint(equalTo: spinDataView.topAnchor),
                spinSource.leadingAnchor.constraint(equalTo: spinDataView.leadingAnchor, constant: 16)
            ])
            
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: S.media_title) {
                sourcesArray.append(_identifier)
            }
            spinSource.load(sourcesArray)
            
        // Source (name)
            let spinName = UILabel()
            spinName.font = CSS.shared.iPhoneArticle_bigTextFont
            spinName.numberOfLines = 0
            spinName.textAlignment = .left
            spinDataView.addSubview(spinName)
            spinName.activateConstraints([
                spinName.leadingAnchor.constraint(equalTo: spinSource.trailingAnchor, constant: 10),
                spinName.centerYAnchor.constraint(equalTo: spinSource.centerYAnchor)
            ])
            let sourceName = CLEAN_SOURCE(from: S.media_title).uppercased()
            spinName.text = sourceName
            
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
            
            spinDataView.addSubview(openIcon)
            openIcon.activateConstraints([
                openIcon.widthAnchor.constraint(equalToConstant: 12),
                openIcon.heightAnchor.constraint(equalToConstant: 12),
                openIcon.centerYAnchor.constraint(equalTo: spinName.centerYAnchor),
                openIcon.leadingAnchor.constraint(equalTo: spinName.trailingAnchor, constant: 6)
            ])
            openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            
        let buttonArea = UIButton(type: .custom)
        buttonArea.tag = 222 + i
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        spinDataView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: spinSource.leadingAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: openIcon.trailingAnchor, constant: 16),
            buttonArea.topAnchor.constraint(equalTo: spinSource.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: spinSource.bottomAnchor)
        ])
        buttonArea.addTarget(self, action: #selector(self.spinButtonAreaOnTap(_:)), for: .touchUpInside)
          
        ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding*2)
        }
    }
    
    @objc func spinButtonAreaOnTap(_ sender: UIButton?) {
        CustomNavController.shared.tour_old?.cancel()
        
        let spin = self.spins[sender!.tag-222]
        
        var article = MainFeedArticle(url: spin.url)
        article.LR = spin.LR
        article.PE = spin.CP
        article.country = spin.media_country_code
        article.source = spin.media_name
        
        let vc = ArticleViewController()
        vc.article = article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func metaculus(_ spin: Spin) -> Bool {
        var result = false
        if(spin.url.lowercased().contains("metaculus")) {
            result = true
        }
        
        return result
    }
    
    func getMetaculusHTML(from url: String, width: CGFloat) -> String? {
        var result: String? = nil
        
        // Parse URL -------------------------------------
        var parsedUrl = url.replacingOccurrences(of: "questions/", with: "questions/embed/")
        if(parsedUrl.last! == "/") {
            parsedUrl = parsedUrl.subString(from: 0, count: parsedUrl.count-2)!
        }
        
        var lastBar = -1
        for (i, CHR) in parsedUrl.enumerated() {
            if(CHR=="/") { lastBar = i }
        }
        parsedUrl = parsedUrl.subString(from: 0, count: lastBar-1)!
        // -----------------------------------------------
        // iframe original size: 550(w) x 430(h)
        let theme = DARK_MODE() ? "dark" : "light"
        var W = Int(width * UIScreen.main.scale)
        if(IPAD()){ W = Int(width) }
        let H = Int((430 * W)/550)
        
        result = "<iframe src=\"" + parsedUrl + "?theme=" + theme + "&zoom=all\" " +
            "style=\"width:" + String(W) + "px; height:" + String(H) + "px; border:none\"></iframe>"
        
        return result
    }
    
    func getMetaculusUrl(from url: String) -> String? {
        var result: String? = nil
    
        // Example: https://www.metaculus.com/questions/23528/palestine-un-member-state-date/
        var parsed = url.replacingOccurrences(of: "https://www.metaculus.com/questions/", with: "")
        
        if(parsed.contains("https://www.metaculus.com/c/")) {
            /*
                Examples:
                    https://www.metaculus.com/c/future-perfect/
                    https://www.metaculus.com/c/brightlinewatch/
             */
             
             parsed = url.replacingOccurrences(of: "https://www.metaculus.com/c/", with: "")
             
             if(!parsed.isEmpty) {
                for (i, CHR) in parsed.enumerated() {
                    if(CHR=="/") {
                        if let _id_suffix = parsed.subString2(from: i+1, count: i+10) {
                            parsed = _id_suffix
                        }
                        break
                    }
                }
            }
            ///
        }
        
        
        if(!parsed.isEmpty) {
            for (i, CHR) in parsed.enumerated() {
                if(CHR=="/") {
                    if let _id = parsed.subString2(from: 0, count: i-1) {
//                        result = "https://www.improvemynews.com/php/metaculus.php?id=" + _id
                        result = ITN_URL() + "/php/metaculus.php?id=" + _id
//                        result = "https://www.improvemynews.com/php/metaculus.php?id=" + _id
                        
                    }
                    break
                }
            }
        }

        if(result != nil) {
//            result! += "?theme="
//            result! += DARK_MODE() ? "dark" : "light"

            result! += "&mode="
            result! += DARK_MODE() ? "dark" : "light"
        }
        
        print("METACULUS URL", result)
        return result
    }
    
    func getMetaculusUrl_2(from url: String) -> String? {
        var result: String? = nil
    
        var parsed = url.replacingOccurrences(of: "https://www.metaculus.com/questions/", with: "")
        if(!parsed.isEmpty) {
            for (i, CHR) in parsed.enumerated() {
                if(CHR=="/") {
                    if let _id = parsed.subString2(from: 0, count: i-1) {
                        result = "https://www.metaculus.com/questions/question_embed/" + _id + "/"
                    }
                    break
                }
            }
        }
        
        if(result != nil) {
            result! += "?theme="
            result! += DARK_MODE() ? "dark" : "light"
        }
        
        return result
    }
    
// -----------------------------
    
    private func addSpins_old(_ spins: [Spin]) {
        self.spins = spins
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding*2)
    
        let HStack = HSTACK(into: self.VStack)
        HStack.tag = 160
        
        //ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        let innerHStack = VSTACK(into: HStack)
        //innerHStack.backgroundColor = .systemPink
        //ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
       if(spins.count == 0) {
            let noSpinsLabel = UILabel()
            noSpinsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noSpinsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noSpinsLabel.text = "No spin available"
            noSpinsLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(noSpinsLabel)
            
            ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        } else {
            let titleHStack = HSTACK(into: innerHStack)
            ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
            
                let SpinsLabel = UILabel()
                SpinsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
                if(IPAD()){ SpinsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
                }
                SpinsLabel.text = "The Spin"
                SpinsLabel.textColor = CSS.shared.displayMode().main_textColor
                titleHStack.addArrangedSubview(SpinsLabel)
                self.addInfoButtonNextTo(label: SpinsLabel, index: 2)
                
            ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
                
            ADD_SPACER(to: innerHStack, height: 12)
            for (i, S) in spins.enumerated() {
                var _title = S.title
                if(_title.isEmpty) {
                    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    _title = "Narrative " + letters.getCharAt(index: i)!
                }
                
                let natitleHStack = HSTACK(into: innerHStack)
                ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                    let titleLabel = UILabel()
                    titleLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
                    titleLabel.text = _title
                    titleLabel.numberOfLines = 0
                    titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                    natitleHStack.addArrangedSubview(titleLabel)
                ADD_SPACER(to: natitleHStack, width: CSS.shared.iPhoneSide_padding)
                
                ADD_SPACER(to: innerHStack, height: 10)
                let descrHStack = HSTACK(into: innerHStack)
                ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding)
                    let descriptionLabel = UILabel()
                    descriptionLabel.font = CSS.shared.iPhoneStoryContent_textFont
                    descriptionLabel.numberOfLines = 0
                    //descriptionLabel.backgroundColor = .green.withAlphaComponent(0.2)
                    descriptionLabel.text = S.description
                    descriptionLabel.setLineSpacing(lineSpacing: 7.0)
                    descriptionLabel.textColor = CSS.shared.displayMode().main_textColor
                    descrHStack.addArrangedSubview(descriptionLabel)
                ADD_SPACER(to: descrHStack, width: CSS.shared.iPhoneSide_padding + 10)
                
            ///
                ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
                let ART_HStack = HSTACK(into: innerHStack)
                
                let W = SCREEN_SIZE().width //- (CSS.shared.iPhoneSide_padding * 2)
                let ART = iPhoneArticle_vImg_v3(width: W)
                ART.refreshDisplayMode()
                ART.populate(spin: S)
                ART_HStack.addArrangedSubview(ART)
                ART.activateConstraints([
                    ART.heightAnchor.constraint(equalToConstant: ART.calculateHeight())
                ])
                ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)
                
                //ADD_SPACER(to: ART_HStack, width: W/2)
                //ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding)

                
            }
        }
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        
//        let line2 = UIView()
//        self.VStack.addArrangedSubview(line2)
//        line2.activateConstraints([
//            line2.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        ADD_DASHES(to: line2)
//        
//        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    private func addMultipleSourceIcons(withSources sources: [SourceForGraph], into container: UIStackView, factIndex: Int) {
        let newSources = CollapsableSources(buildInto: container, sources: sources)
        self.collapsableSources.append(newSources)
    }
    
    private func addSourceIcon(withSource S: SourceForGraph, into container: UIStackView, factIndex: Int) {
        let resultView = HSTACK(into: container, spacing: 7)
        resultView.backgroundColor = .clear
        resultView.activateConstraints([
            resultView.heightAnchor.constraint(equalToConstant: 31)
        ])
        resultView.tag = factIndex
        
        let imageView = UIImageView()
        resultView.addArrangedSubview(imageView)
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 31),
            imageView.heightAnchor.constraint(equalToConstant: 31),
            imageView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: resultView.topAnchor)
        ])
        
        if let _icon = Sources.shared.search(identifier: S.id), _icon.url != nil {
            if(!_icon.url!.contains(".svg")) {
                imageView.sd_setImage(with: URL(string: _icon.url!))
            } else {
                imageView.image = UIImage(named: _icon.identifier + ".png")
            }
        } else {
            let url = BUILD_LOGO_URL(id: S.name)
            
            imageView.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
                if let _ = error {
                    imageView.image = UIImage(named: "LINK64.png")
                }
            }
        }
        imageView.layer.cornerRadius = 28/2
        imageView.clipsToBounds = true
        
        
        let label = UILabel()
        label.text = S.name
        label.font = AILERON(14)
        label.textColor = CSS.shared.displayMode().main_textColor
        resultView.addArrangedSubview(label)
        
        let openIconVStack = VSTACK(into: resultView)
        ADD_SPACER(to: openIconVStack, height: 9.5)
        
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
        openIconVStack.addArrangedSubview(openIcon)
        openIcon.activateConstraints([
            openIcon.widthAnchor.constraint(equalToConstant: 12),
            openIcon.heightAnchor.constraint(equalToConstant: 12),
            //openIcon.centerYAnchor.constraint(equalTo: spinName.centerYAnchor),
        ])
        openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        
        ADD_SPACER(to: openIconVStack, height: 9.5)
        ADD_SPACER(to: resultView, width: 5)
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        resultView.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            button.topAnchor.constraint(equalTo: resultView.topAnchor),
            button.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: resultView.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(self.sourceButtonOnLinkTap(_:)), for: .touchUpInside)
        button.tag = 0
        
        ADD_SPACER(to: container)
    }
    @objc func sourceButtonOnLinkTap(_ sender: UIButton?) {
        if let _sender = sender, let _sView = _sender.superview {
            let fIndex = _sView.tag
            let sIndex = _sender.tag
            
            let url = self.facts[fIndex].sources[sIndex].url
            
            var article = MainFeedArticle(url: url)
            let vc = ArticleViewController()
            vc.article = article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    
    
    private func populateFacts_new() {
        self.collapsableSources = []
        let VStack = self.view.viewWithTag(140) as! UIStackView
        
        //VStack.backgroundColor = .systemPink
        REMOVE_ALL_SUBVIEWS(from: VStack)
        //ADD_SPACER(to: VStack, height: 20)
        
        ADD_SPACER(to: VStack, height: 2)
        if(self.facts.count==0) {
            let noFactsLabel = UILabel()
            noFactsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noFactsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noFactsLabel.text = "No facts available"
            noFactsLabel.textColor = CSS.shared.displayMode().main_textColor
            VStack.addArrangedSubview(noFactsLabel)
        } else {
            let FactsLabel = UILabel()
            FactsLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            
            //DM_SERIF_DISPLAY_fixed(17) //MERRIWEATHER_BOLD(17)
            if(IPAD()){ FactsLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
            }
            FactsLabel.text = "The Facts"
            FactsLabel.textColor = CSS.shared.displayMode().main_textColor
            //DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(FactsLabel)
            self.addInfoButtonNextTo(label: FactsLabel, index: 1)
            
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            let lineColor: UIColor = CSS.shared.displayMode().factLines_color
            
            self.lastSourceIndex = -1
            for (i, F) in self.facts.enumerated() {
                if(i==0) {
                    let hStackZero = HSTACK(into: VStack)
                    ADD_SPACER(to: hStackZero, height: CSS.shared.iPhoneSide_padding)
                    
                    let vLine = UIView()
                    vLine.backgroundColor = lineColor
                    hStackZero.addSubview(vLine)
                    vLine.activateConstraints([
                        vLine.leadingAnchor.constraint(equalTo: hStackZero.leadingAnchor, constant: 11),
                        vLine.topAnchor.constraint(equalTo: hStackZero.topAnchor),
                        vLine.bottomAnchor.constraint(equalTo: hStackZero.bottomAnchor),
                        vLine.widthAnchor.constraint(equalToConstant: 2.0)
                    ])
                }
                
                let HStack = HSTACK(into: VStack)
                ADD_SPACER(to: HStack, width: 34)

                let dot = UIView()
                dot.backgroundColor = HStack.backgroundColor
                HStack.addSubview(dot)
                dot.activateConstraints([
                    dot.widthAnchor.constraint(equalToConstant: 24),
                    dot.heightAnchor.constraint(equalToConstant: 24),
                    dot.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 0),
                    dot.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 0)
                ])
                dot.layer.cornerRadius = 12
                dot.layer.borderWidth = 2.0
                dot.layer.borderColor = lineColor.cgColor

                let extraH: CGFloat = (CSS.shared.iPhoneSide_padding * 3)
                let vLineBelow = UIView()
                vLineBelow.backgroundColor = lineColor
                HStack.addSubview(vLineBelow)
                vLineBelow.activateConstraints([
                    vLineBelow.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 11),
                    vLineBelow.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 24),
                    vLineBelow.bottomAnchor.constraint(equalTo: HStack.bottomAnchor, constant: extraH),
                    vLineBelow.widthAnchor.constraint(equalToConstant: 2.0)
                ])

                let contentVStack = VSTACK(into: HStack)

                let contentLabel = UILabel()
                contentLabel.numberOfLines = 0
                contentLabel.font = AILERON_resize(15)
                contentLabel.text = F.title
                contentLabel.textColor = CSS.shared.displayMode().main_textColor
                
                //contentLabel.attributedText = self.attrText(F.title, index: F.sourceIndex+1)
                contentLabel.setLineSpacing(lineSpacing: 7.0)
                contentVStack.addArrangedSubview(contentLabel)
                
                ADD_SPACER(to: contentVStack, height: 16)
                
                let sourcesContainer = HSTACK(into: contentVStack)
                //sourcesContainer.backgroundColor = .green.withAlphaComponent(0.1)
               
                if(F.sources.count==1) { // Single source
                    let S = F.sources.first!
                    self.addSourceIcon(withSource: S, into: sourcesContainer, factIndex: i)
                } else { // Multiple sources
                    self.addMultipleSourceIcons(withSources: F.sources, into: sourcesContainer, factIndex: i)
                }

                ADD_SPACER(to: VStack, height: 16*2) // separation from next item
                
                if(self.show3 && i==2) {
                    self.lastSourceIndex =  F.sourceIndex
                    break
                }
            }
            
            //ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            //////////////////////////////////////
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            
            let showMoreLabel = UILabel()
            showMoreLabel.textColor = CSS.shared.orange
            showMoreLabel.textAlignment = .center
            showMoreLabel.font = CSS.shared.iPhoneStoryContent_textFont
            showMoreLabel.text = self.show3 ? "Show More" : "Show Fewer Facts"
            VStack.addArrangedSubview(showMoreLabel)
            
            let showMoreButton = UIButton(type: .custom)
            //showMoreButton.backgroundColor = .red.withAlphaComponent(0.5)
            VStack.addSubview(showMoreButton)
            showMoreButton.activateConstraints([
                showMoreButton.heightAnchor.constraint(equalToConstant: 22),
                showMoreButton.widthAnchor.constraint(equalToConstant: 180),
                showMoreButton.centerXAnchor.constraint(equalTo: showMoreLabel.centerXAnchor),
                showMoreButton.centerYAnchor.constraint(equalTo: showMoreLabel.centerYAnchor)
            ])
            showMoreButton.addTarget(self, action: #selector(showMoreButtonOnTap(_:)), for: .touchUpInside)
            //////////////////////////////////////
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
//            let line = UIView()
//            line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE2E3E3)
//            VStack.addArrangedSubview(line)
//            line.activateConstraints([
//                line.heightAnchor.constraint(equalToConstant: 1)
//            ])
//            ADD_SPACER(to: VStack, height: 20)
            //////////////////////////////////////

            ADD_SPACER(to: VStack, height: 15)
        }
        
        //ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding * 2)
        //print("--------------------")
        
//        let line2 = UIView()
//        self.VStack.addArrangedSubview(line2)
//        line2.activateConstraints([
//            line2.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        ADD_HDASHES(to: line2)
    }
    
    private func populateFacts() {
        let VStack = self.view.viewWithTag(140) as! UIStackView
        
        //VStack.backgroundColor = .systemPink
        REMOVE_ALL_SUBVIEWS(from: VStack)
        //ADD_SPACER(to: VStack, height: 20)
        
        ADD_SPACER(to: VStack, height: 2)
        if(self.facts.count==0) {
            let noFactsLabel = UILabel()
            noFactsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noFactsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noFactsLabel.text = "No facts available"
            noFactsLabel.textColor = CSS.shared.displayMode().main_textColor
            VStack.addArrangedSubview(noFactsLabel)
        } else {
            let FactsLabel = UILabel()
            FactsLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
            
            //DM_SERIF_DISPLAY_fixed(17) //MERRIWEATHER_BOLD(17)
            if(IPAD()){ FactsLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
            }
            
            if(self.deepDive == nil) {
                FactsLabel.text = "The Facts"
            } else {
                FactsLabel.text = "Overview"
            }
            FactsLabel.textColor = CSS.shared.displayMode().main_textColor
            //DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(FactsLabel)
            self.addInfoButtonNextTo(label: FactsLabel, index: 1)
            
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            let lineColor: UIColor = CSS.shared.displayMode().factLines_color
            
            self.lastSourceIndex = -1
            for (i, F) in self.facts.enumerated() {
                if(i==0) {
                    let hStackZero = HSTACK(into: VStack)
                    ADD_SPACER(to: hStackZero, height: CSS.shared.iPhoneSide_padding)
                    
                    let vLine = UIView()
                    vLine.backgroundColor = lineColor
                    hStackZero.addSubview(vLine)
                    vLine.activateConstraints([
                        vLine.leadingAnchor.constraint(equalTo: hStackZero.leadingAnchor, constant: 11),
                        vLine.topAnchor.constraint(equalTo: hStackZero.topAnchor),
                        vLine.bottomAnchor.constraint(equalTo: hStackZero.bottomAnchor),
                        vLine.widthAnchor.constraint(equalToConstant: 2.0)
                    ])
                }
                
                let HStack = HSTACK(into: VStack)
                
                ADD_SPACER(to: HStack, width: 34)

                let dot = UIView()
                dot.backgroundColor = HStack.backgroundColor
                HStack.addSubview(dot)
                dot.activateConstraints([
                    dot.widthAnchor.constraint(equalToConstant: 24),
                    dot.heightAnchor.constraint(equalToConstant: 24),
                    dot.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 0),
                    dot.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 0)
                ])
                dot.layer.cornerRadius = 12
                dot.layer.borderWidth = 2.0
                dot.layer.borderColor = lineColor.cgColor

                let extraH: CGFloat = (CSS.shared.iPhoneSide_padding * 3)
                let vLineBelow = UIView()
                vLineBelow.backgroundColor = lineColor
                HStack.addSubview(vLineBelow)
                vLineBelow.activateConstraints([
                    vLineBelow.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 11),
                    vLineBelow.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 24),
                    vLineBelow.bottomAnchor.constraint(equalTo: HStack.bottomAnchor, constant: extraH),
                    vLineBelow.widthAnchor.constraint(equalToConstant: 2.0)
                ])

                let contentLabel = UILabel()
                contentLabel.numberOfLines = 0
                contentLabel.font = AILERON_resize(16)
                
                //CSS.shared.iPhoneStoryContent_textFont
                //CSS.shared.iPhoneStoryContent_textFont
                //contentLabel.text = F.title
                contentLabel.attributedText = self.attrText(F.title, index: F.sourceIndex+1)
                contentLabel.setLineSpacing(lineSpacing: 7.0)
                HStack.addArrangedSubview(contentLabel)
                
                let numberButton = UIButton(type: .custom)
                numberButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                HStack.addSubview(numberButton)
                numberButton.activateConstraints([
                    numberButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
                    numberButton.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
                    numberButton.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor),
                    numberButton.heightAnchor.constraint(equalToConstant: 25)
                ])
                numberButton.tag = 77 + F.sourceIndex
                numberButton.addTarget(self, action: #selector(numberButtonOnTap(_:)), for: .touchUpInside)
                
                ADD_SPACER(to: VStack, height: (CSS.shared.iPhoneSide_padding * 3)) // separation from next item
                
                if(self.show3 && i==2) {
                    self.lastSourceIndex =  F.sourceIndex
                    break
                }
            }
            
            //ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            //////////////////////////////////////
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
            
            let showMoreLabel = UILabel()
            showMoreLabel.textColor = CSS.shared.orange
            showMoreLabel.textAlignment = .center
            showMoreLabel.font = CSS.shared.iPhoneStoryContent_textFont
            showMoreLabel.text = self.show3 ? "Show More" : "Show Fewer Facts"
            VStack.addArrangedSubview(showMoreLabel)
            
            let showMoreButton = UIButton(type: .custom)
            //showMoreButton.backgroundColor = .red.withAlphaComponent(0.5)
            VStack.addSubview(showMoreButton)
            showMoreButton.activateConstraints([
                showMoreButton.heightAnchor.constraint(equalToConstant: 22),
                showMoreButton.widthAnchor.constraint(equalToConstant: 180),
                showMoreButton.centerXAnchor.constraint(equalTo: showMoreLabel.centerXAnchor),
                showMoreButton.centerYAnchor.constraint(equalTo: showMoreLabel.centerYAnchor)
            ])
            showMoreButton.addTarget(self, action: #selector(showMoreButtonOnTap(_:)), for: .touchUpInside)
            //////////////////////////////////////
            ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
//            let line = UIView()
//            line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE2E3E3)
//            VStack.addArrangedSubview(line)
//            line.activateConstraints([
//                line.heightAnchor.constraint(equalToConstant: 1)
//            ])
//            ADD_SPACER(to: VStack, height: 20)
            //////////////////////////////////////

            ADD_SPACER(to: VStack, height: 15)
        }
        
        //ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding * 2)
        //print("--------------------")
        
//        let line2 = UIView()
//        self.VStack.addArrangedSubview(line2)
//        line2.activateConstraints([
//            line2.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        ADD_HDASHES(to: line2)
    }
    
    func populateSources() {
        let VStack = self.view.viewWithTag(150) as! UIStackView
        REMOVE_ALL_SUBVIEWS(from: VStack)
        
        let SourcesLabel = UILabel()
        SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(17) //MERRIWEATHER_BOLD(17)
        if(IPAD()){ SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
        }
        SourcesLabel.text = "Sources"
        SourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        VStack.addArrangedSubview(SourcesLabel)
        self.addInfoButtonNextTo(label: SourcesLabel, index: 3)
        ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
        
        let HStack_sources = HSTACK(into: VStack)
        //HStack_sources.backgroundColor = .green
        ADD_SPACER(to: HStack_sources, width: 8)
        
        let VStack_sources = VSTACK(into: HStack_sources)
        VStack_sources.spacing = CSS.shared.iPhoneSide_padding + 8
        //VStack_sources.backgroundColor = .blue
        
        ADD_SPACER(to: HStack_sources, width: 8)
        //------------------------------------------
        let HSep: CGFloat = 12
        let W: CGFloat = SCREEN_SIZE().width - 12 - 12 - 13 - 13 - 8 - 8 - HSep
        var sourceHeight: CGFloat = 18
        
        let tmpLabel = UILabel()
        tmpLabel.font = AILERON_resize(16)
        tmpLabel.text = "ABC"
        sourceHeight = tmpLabel.calculateHeightFor(width: SCREEN_SIZE().width/2)
        
        var row = 1
        var val_X: CGFloat = 0
        //------------------------------------------
        var groupedSourcesCopy = [(String, String)]()
        let letters = "abcdefghijklmnopqrstuvwxyz"
        
        for S in self.groupedSources {
            var total = 0
            var current = -1
            for _tmp in self.groupedSources {
                if(_tmp.0 == S.0) {
                    if(_tmp.1 == S.1) {
                        current = total
                    }
                    total += 1
                }
            }
            
            var title = S.0
            let url = S.1
            
            if(total>1) {
                title = S.0 + " (" + letters.getCharAt(index: current)! + ")"
            }
            groupedSourcesCopy.append( (title, url) )
        }
        
        for (i, S) in groupedSourcesCopy.enumerated() {
            let sourceLabel = UILabel()
            sourceLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont //ROBOTO(15)
            //sourceLabel.backgroundColor = .blue
            sourceLabel.textColor = CSS.shared.orange
            sourceLabel.text = "[" + String(i+1) + "] " + S.0
            //print("SOURCE:", sourceLabel.text)
            
            sourceLabel.heightAnchor.constraint(equalToConstant: sourceHeight).isActive = true
            let labelWidth = sourceLabel.calculateWidthFor(height: sourceHeight)
            sourceLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            
            var limit = val_X + labelWidth
            if(val_X > 0) { limit += HSep }
            if(limit > W) {
                let HStack_row =  VStack_sources.arrangedSubviews[row-1] as! UIStackView
                ADD_SPACER(to: HStack_row)
                
                row += 1
                val_X = 0
            } else {
                if(val_X == 0) {
                    val_X += labelWidth
                } else {
                    val_X += HSep + labelWidth
                }
            }
            
            var HStack_row: UIStackView
            if(VStack_sources.arrangedSubviews.count < row) {
                HStack_row = HSTACK(into: VStack_sources)
                HStack_row.spacing = HSep
                //HStack_row.backgroundColor = .yellow
                
                if(row>1) {
                    val_X += labelWidth
                }
            } else {
                HStack_row =  VStack_sources.arrangedSubviews[row-1] as! UIStackView
            }
            
            HStack_row.addArrangedSubview(sourceLabel)
            
            var isLast = false
            //if(self.show3 && i==self.lastSourceIndex){ isLast = true }
            if( (i+1 == self.groupedSources.count) || isLast) { // last item
                ADD_SPACER(to: HStack_row)
            }
            
            let sourceButton = UIButton(type: .system)
            //sourceLabel.backgroundColor = .blue.withAlphaComponent(0.3)
            HStack_row.addSubview(sourceButton)
            sourceButton.activateConstraints([
                sourceButton.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
                sourceButton.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor),
                sourceButton.topAnchor.constraint(equalTo: sourceLabel.topAnchor),
                sourceButton.bottomAnchor.constraint(equalTo: sourceLabel.bottomAnchor)
            ])
            sourceButton.tag = 200 + i
            sourceButton.addTarget(self, action: #selector(sourceButtonOnTap(_:)), for: .touchUpInside)
            
            if(isLast) {
                break
            }
        }
    }
    
    @objc func numberButtonOnTap(_ sender: UIButton) {
        let index = sender.tag-77
        let tmpButton = UIButton(type: .custom)
        tmpButton.tag = 200+index
        self.sourceButtonOnTap(tmpButton)
    }
    
    private func addFactsStructure() {
        var useNewUI = false
        if(IPAD() && self.showSplitSource){
            useNewUI = true
        }
        
        if(!useNewUI) { // OLD
            ADD_SPACER(to: self.VStack, height: 1)
        
            let HStack = HSTACK(into: self.VStack)
            //HStack.backgroundColor = .green
            ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
            let VStack_borders = VSTACK(into: HStack)
            ADD_SPACER(to: HStack, width: 16)
            //VStack_borders.layer.borderWidth = 8.0
            //VStack_borders.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x28282D).cgColor : UIColor(hex: 0xE1E3E3).cgColor

            VStack_borders.backgroundColor = self.view.backgroundColor
            let innerHStack = HSTACK(into: VStack_borders)
            //innerHStack.backgroundColor = .blue
            //ADD_SPACER(to: innerHStack, width: 13)
            let innerVStack = VSTACK(into: innerHStack)
            innerVStack.tag = 140
            //ADD_SPACER(to: innerHStack, width: 13)
        } else { // NEW
            ADD_SPACER(to: self.VStack, height: 1)
        
            let HStack = HSTACK(into: self.VStack)
            //HStack.backgroundColor = .green
            ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
            let VStack_borders = VSTACK(into: HStack)
            ADD_SPACER(to: HStack, width: 35)
            
            //VStack_borders.layer.borderWidth = 8.0
            //VStack_borders.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x28282D).cgColor : UIColor(hex: 0xE1E3E3).cgColor

            VStack_borders.backgroundColor = self.view.backgroundColor
            
            let innerHStack = HSTACK(into: VStack_borders)
            //innerHStack.backgroundColor = .blue
            //ADD_SPACER(to: innerHStack, width: 13)
            
            let innerVStack = VSTACK(into: innerHStack)
//            innerVStack.backgroundColor = .yellow
            innerVStack.tag = 140
            
                ADD_SPACER(to: innerHStack, width: 25)
                let innerVStack2 = VSTACK(into: innerHStack)
                innerVStack2.widthAnchor.constraint(equalToConstant: 360).isActive = true
                //innerVStack2.backgroundColor = .green
                innerVStack2.tag = 555
            
            //ADD_SPACER(to: innerHStack, width: 13)
        }
    }
    
    private func addSourcesStructure() {
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        let VStack_borders = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)

        VStack_borders.backgroundColor = self.view.backgroundColor
        let innerHStack = HSTACK(into: VStack_borders)
        //innerHStack.backgroundColor = .blue
        //ADD_SPACER(to: innerHStack, width: 13)
        let innerVStack = VSTACK(into: innerHStack)
        innerVStack.tag = 150
        //ADD_SPACER(to: innerHStack, width: 13)
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding*2)
        
        let line2 = UIView()
        self.VStack.addArrangedSubview(line2)
        line2.activateConstraints([
            line2.heightAnchor.constraint(equalToConstant: 1),
        ])
        //ADD_HDASHES(to: line2)
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    
    private func addImageCredit(_ title: String, _ url: String, description: String, time: String) {
        let vLine = UIView()
        vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x424345) : UIColor(hex: 0xD6D6D6)
        vLine.widthAnchor.constraint(equalToConstant: 2).isActive = true

        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(vLine)
        ADD_SPACER(to: HStack, width: 13)
        
        let infoLabel = UILabel()
        infoLabel.font = ROBOTO_resize(14)
        infoLabel.textColor = CSS.shared.displayMode().sec_textColor
        infoLabel.numberOfLines = 0
        
        var textToShow = ""
        
        if(!description.isEmpty) {
            textToShow += "Above: " + description
        }
        textToShow += "Image copyright: " + title
        
        self.setLabelAsImageCredit(infoLabel, text: textToShow, boldText: title)
        
        let VStackLabels = VSTACK(into: HStack)
        VStackLabels.addArrangedSubview(infoLabel)
        
        var timeText = ""
        if(self.deepDive == nil) { timeText = "Story" }
        else { timeText = "DeepDive" }
        timeText += " last updated " + time
        
        let timeLabel = UILabel()
        timeLabel.font = ROBOTO_ITALIC(14)
        timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        timeLabel.text = timeText
                
        ADD_SPACER(to: VStackLabels, height: 4)
        VStackLabels.addArrangedSubview(timeLabel)
        
        ///
        let creditButton = UIButton(type: .system)
        creditButton.backgroundColor = .clear // .red.withAlphaComponent(0.5)
        VStackLabels.addSubview(creditButton)
        creditButton.activateConstraints([
            creditButton.leadingAnchor.constraint(equalTo: VStackLabels.leadingAnchor),
            creditButton.trailingAnchor.constraint(equalTo: VStackLabels.trailingAnchor),
            creditButton.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            creditButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        creditButton.addTarget(self, action: #selector(onImageCreditButtonTap(_:)), for: .touchUpInside)
        
        self.imageCreditUrl = url
        ///
        
        
        ADD_SPACER(to: HStack, width: 13)
        ADD_SPACER(to: self.VStack, height: 16)
    }
    
    private func addImageCredit_2(_ title: String, _ url: String, description: String) {
        if(!description.isEmpty) {
            let descrLabel = UILabel()
            descrLabel.font = ROBOTO_resize(14)
            descrLabel.textColor = CSS.shared.displayMode().sec_textColor
            descrLabel.numberOfLines = 0
            descrLabel.text = "Above: " + description
            if(IPHONE()){ descrLabel.text! += "\n" }
            
            let HStack = HSTACK(into: self.VStack)
            ADD_SPACER(to: HStack, width: 13)
            HStack.addArrangedSubview(descrLabel)
            ADD_SPACER(to: HStack, width: 13)
        }
        
        let prefix = "Image copyright: "
        let creditLabel = UILabel()
        creditLabel.numberOfLines = 0
        creditLabel.font = ROBOTO_resize(14)
        creditLabel.text = prefix + title
        creditLabel.setAsImageCreditWith(prefix: prefix)
        //creditLabel.addUnderline()
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(creditLabel)
        ADD_SPACER(to: HStack, width: 13)
        
        let creditButton = UIButton(type: .system)
        HStack.addSubview(creditButton)
        creditButton.activateConstraints([
            creditButton.leadingAnchor.constraint(equalTo: creditLabel.leadingAnchor),
            creditButton.trailingAnchor.constraint(equalTo: creditLabel.trailingAnchor),
            creditButton.topAnchor.constraint(equalTo: creditLabel.topAnchor),
            creditButton.bottomAnchor.constraint(equalTo: creditLabel.bottomAnchor)
        ])
        creditButton.addTarget(self, action: #selector(onImageCreditButtonTap(_:)), for: .touchUpInside)
        
        self.imageCreditUrl = url
        ADD_SPACER(to: self.VStack, height: 12)
    }
    
    private func addTime(time: String) {
        let updatedLabel = UILabel()
        updatedLabel.font = ROBOTO(14)
        updatedLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x93A0B4)
        updatedLabel.text = "Updated " + time
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(updatedLabel)
        ADD_SPACER(to: HStack, width: 13)
    }
    
    private func addVideo() {
        if(self.webBrowser == nil) {
            self.webBrowser = WKWebView()
            
            let videoURL = URL(string: "https://www.youtube.com/embed/" + self.story!.videoFile!)!
            let request = URLRequest(url: videoURL)
            self.webBrowser!.load(request)
        }
            
        let H = (SCREEN_SIZE().width * 9)/16
        self.VStack.addArrangedSubview(self.webBrowser!)
        self.webBrowser!.activateConstraints([
            self.webBrowser!.heightAnchor.constraint(equalToConstant: H)
        ])
        
        ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
    }

    private func addImage(imageUrl: String) {
        let imageView = CustomImageView()
        //imageView.backgroundColor = .darkGray
        
        if(IPAD()) {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let HStack = HSTACK(into: self.VStack)
            ADD_SPACER(to: HStack, width: 13)
            HStack.addArrangedSubview(imageView)
            ADD_SPACER(to: HStack, width: 13)
                    
            self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
            self.imageHeightConstraint?.isActive = true
            
            imageView.sd_setImage(with: URL(string: imageUrl)) { (img, error, cacheType, url) in
                if let _img = img {
                    self.loadedImage = _img
                
                    let imgWidth: CGFloat = 16
                    let imgHeight: CGFloat = 7.4
                    let W: CGFloat = SCREEN_SIZE().width - 26
                    var H = (imgHeight * W)/imgWidth
                    //if(H>450){ H = 450 }
                    
                    self.imageHeightConstraint?.constant = H
                }
            }
        } else {
            self.VStack.addArrangedSubview(imageView)
            //self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
            
            let H: CGFloat = (213 * SCREEN_SIZE().width)/370
            self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: H)
            self.imageHeightConstraint?.isActive = true
            
            imageView.showCorners(true)
            imageView.load(url: imageUrl)

//            imageView.load(url: imageUrl) { (success, imgSize) in
//                if success, let _imgSize = imgSize {
//                    let compW = SCREEN_SIZE().width
//                    let compH = (_imgSize.height * compW)/_imgSize.width
//                    self.imageHeightConstraint?.constant = compH
//                }
//            }
            
            imageView.refreshDisplayMode()
            
//            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .retryFailed) { (img, error, cacheType, url) in
//                if let _img = img {
//                    let W: CGFloat = SCREEN_SIZE().width
//                    let H = (_img.size.height * W)/_img.size.width
//                    self.imageHeightConstraint?.constant = H
//                } else if(error != nil) {
//                    imageView.image = nil
//                }
//            }

            ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
        }
        
        //ADD_SPACER(to: self.VStack, height: 4)
    }

    private func addAudioPlayer(_ audioFile: AudioFile?) {
        if let _audioFile = audioFile {
            self.audioPlayer.buildInto(self.VStack, file: _audioFile)
            
            self.secondaryAudioPlayer.buildInto(self.view, file: _audioFile)
            self.secondaryAudioPlayer.delegate = self
            
            //self.secondaryAudioPlayer.customHide()
            self.secondaryAudioPlayer.customShow()
        }
    }

    //private func addStoryMetaData(figures: [PublicFigureListItem], time: String, created: String = "") {
    private func addStoryMetaData(figures: [PublicFigureListItem], time: String) {
        if(IPAD()) { ADD_SPACER(to: self.VStack, height: 16) }
        
        let rowView = UIView()
        rowView.activateConstraints([
            rowView.heightAnchor.constraint(equalToConstant: 36)
        ])
        rowView.backgroundColor = self.view.backgroundColor //.green.withAlphaComponent(0.25)
        self.VStack.addArrangedSubview(rowView)
        
        var val_x: CGFloat = 16
        var limit = 3
        
        if(figures.count>0) {
            var count = 0
            let size: CGFloat = 32
            let border: CGFloat = 3
            
            for F in figures {
                let figureView = UIView()
                figureView.backgroundColor = CSS.shared.displayMode().main_bgColor
                rowView.addSubview(figureView)
                figureView.activateConstraints([
                    figureView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
                    figureView.topAnchor.constraint(equalTo: rowView.topAnchor),
                    figureView.widthAnchor.constraint(equalToConstant: size+(border*2)),
                    figureView.heightAnchor.constraint(equalToConstant: size+(border*2))
                ])
                figureView.layer.cornerRadius = (size+(border*2))/2
                
                let imageView = UIImageView()
                rowView.addSubview(imageView)
                imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
                imageView.activateConstraints([
                    imageView.widthAnchor.constraint(equalToConstant: size),
                    imageView.heightAnchor.constraint(equalToConstant: size),
                    imageView.centerXAnchor.constraint(equalTo: figureView.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: figureView.centerYAnchor)
                ])
                
                if(!F.image.isEmpty) {
                    imageView.sd_setImage(with: URL(string: F.image)) { (image, error, cacheType, url) in
                    }
                }
                imageView.layer.cornerRadius = size/2
                imageView.clipsToBounds = true
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                rowView.addSubview(button)
                button.activateConstraints([
                    button.centerXAnchor.constraint(equalTo: figureView.centerXAnchor),
                    button.centerYAnchor.constraint(equalTo: figureView.centerYAnchor),
                    button.widthAnchor.constraint(equalTo: figureView.widthAnchor),
                    button.heightAnchor.constraint(equalTo: figureView.heightAnchor)
                ])
                button.tag = count
                button.addTarget(self, action: #selector(figureOnButtonTap(_:)), for: .touchUpInside)
                
                val_x += 28-border
                
                count += 1
                if(count == limit) { break }
            }
            
            val_x += 16
            if(figures.count>limit) {
                let moreLabel = UILabel()
                moreLabel.textColor = CSS.shared.displayMode().sec_textColor
                moreLabel.font = AILERON(12)
                moreLabel.text = "+" + String(figures.count-3)
                rowView.addSubview(moreLabel)
                moreLabel.activateConstraints([
                    moreLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
                    moreLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
                ])
                
                val_x += moreLabel.calculateWidthFor(height: 24) + 12
            } else {
                val_x += 6
            }
        }
        
        let timeLabel = UILabel()
        timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        timeLabel.font = AILERON(12)
        timeLabel.text = FIX_TIME(time).uppercased()
        rowView.addSubview(timeLabel)
        timeLabel.activateConstraints([
            timeLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
        ])
        
        ///////////////////////////////
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    @objc func figureOnButtonTap(_ sender: UIButton?) {
        if let _sender = sender {
            let index = _sender.tag
            let slug = self.loadedStory.figures[index].slug
            
            let vc = FigureDetailsViewController()
            vc.slug = slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }

    private func addStoryMetaData_2(figures: [PublicFigureListItem], time: String, created: String = "") {
        let rowView = UIView()
        rowView.activateConstraints([
            rowView.heightAnchor.constraint(equalToConstant: 31)
        ])
        rowView.clipsToBounds = false
        rowView.backgroundColor = .green //self.view.backgroundColor
    
        if(IPAD()) {
            ADD_SPACER(to: self.VStack, height: 10)
        }
    
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        HStack.addArrangedSubview(rowView)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
//        let pill = StoryPillView()
//        pill.buildInto(rowView)
//        pill.activateConstraints([
//            pill.topAnchor.constraint(equalTo: rowView.topAnchor),
//            pill.leadingAnchor.constraint(equalTo: rowView.leadingAnchor)
//        ])
//        if(self.isContext) {
//            pill.setAsContext()
//        }
        
        let imageView = UIImageView()
        rowView.addSubview(imageView)
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 31),
            imageView.heightAnchor.constraint(equalToConstant: 31),
            imageView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: rowView.topAnchor)
        ])
        
//        var sources: SourceIconsView!
//        if(PREFS_SHOW_SOURCE_ICONS()) {
//            sources = SourceIconsView()
//            sources.buildInto(rowView)
//            sources.activateConstraints([
//                sources.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
//                sources.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding)
//            ])
//            sources.load(self.story!.storySources)
//            sources.refreshDisplayMode()
//        }

//        let timeLabel = UILabel()
//        timeLabel.font = CSS.shared.iPhoneStory_textFont
//        timeLabel.textAlignment = .left
//        
//        timeLabel.numberOfLines = 0
//        if(!created.isEmpty) {
//            timeLabel.text = "PUBLISHED " + created.uppercased() + "\n" + "UPDATED " + FIX_TIME(time).uppercased()
//        } else {
//            timeLabel.text = "UPDATED " + FIX_TIME(time).uppercased()
//        }
//        
//        timeLabel.textColor = CSS.shared.displayMode().sec_textColor
//        rowView.addSubview(timeLabel)
//        timeLabel.activateConstraints([
//            timeLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
//        ])
//        
//        if(PREFS_SHOW_SOURCE_ICONS()) {
//            timeLabel.leadingAnchor.constraint(equalTo: sources.trailingAnchor, constant: 8).isActive = true
//        } else {
//            timeLabel.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding).isActive = true
//        }
        
        
        
//        self.time_leading = timeLabel.leadingAnchor.constraint(equalTo: sources.trailingAnchor, constant: 8)
//        self.time_leading?.isActive = true
        
        //self.timeLabel.text = article.time.uppercased()
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    private func addTitle(text: String) {
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY_resize(23)
        //CSS.shared.iPhoneStoryContent_titleFont //DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        //DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        HStack.addArrangedSubview(titleLabel)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
        ADD_SPACER(to: self.VStack, height: 1)
        
        let W: CGFloat = SCREEN_SIZE().width - ( CSS.shared.iPhoneSide_padding * 2)
        self.titleLabelHeight = titleLabel.calculateHeightFor(width: W)
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }

    private func addPill() {
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 10)
        
        let storyPillLabel = UILabel()
        storyPillLabel.backgroundColor = (self.isContext) ? UIColor(hex: 0x3FBC04) : UIColor(hex: 0xDA4933)
        storyPillLabel.textColor = .white
        storyPillLabel.text = (self.isContext) ? "CONTEXT" : "STORY"
        storyPillLabel.textAlignment = .center
        storyPillLabel.font = AILERON_BOLD(11)
        storyPillLabel.layer.masksToBounds = true
        storyPillLabel.layer.cornerRadius = 10
        storyPillLabel.addCharacterSpacing(kernValue: 1.0)
        
        var W: CGFloat = 60
        if(self.isContext){ W = 80 }
        HStack.addArrangedSubview(storyPillLabel)
        storyPillLabel.activateConstraints([
            storyPillLabel.widthAnchor.constraint(equalToConstant: W),
            storyPillLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        ADD_SPACER(to: HStack)
        ADD_SPACER(to: self.VStack, height: 0)
    }

    func addUpButton(audioFile: AudioFile?) {
        self.upButton.setImage(UIImage(named: DisplayMode.imageName("storyBackToTop")), for: .normal)
        //self.upButton.backgroundColor = .yellow.withAlphaComponent(0.5)
        self.view.addSubview(self.upButton)
        self.upButton.activateConstraints([
            self.upButton.widthAnchor.constraint(equalToConstant: 60),
            self.upButton.heightAnchor.constraint(equalToConstant: 60),
            self.upButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: IPAD_sideOffset(multiplier: 0.5))
        ])
        
        if(IPHONE()) {
            if(audioFile == nil) {
                self.upButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10).isActive = true
            } else {
                self.upButtonBottomConstraint = self.upButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor,
                constant: -10-75)
                
                self.upButtonBottomConstraint?.isActive = true
            }
        } else {
            // IPAD
            self.upButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -16).isActive = true
        }
                
        self.upButton.addTarget(self, action: #selector(upButtonOnTap(_:)), for: .touchUpInside)
        self.upButton.hide()
    }
    
    @objc func upButtonOnTap(_ sender: UIButton?) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.upButton.alpha = 0
        } completion: { _ in
            self.upButton.hide()
        }

    }


    func addControversies(_ controversies: [ControversyListItem]) {
        self.controversies = controversies
        if(controversies.count==0) {
            return
        }
        
        let vMainContainer = VSTACK(into: self.VStack)
        vMainContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        // ------------------------
        let hTitleContainer = HSTACK(into: vMainContainer)
        ADD_SPACER(to: hTitleContainer, width: 16)
        
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
        if(IPAD()){ titleLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
        }
        titleLabel.text = "The Controversies"
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        hTitleContainer.addArrangedSubview(titleLabel)
        
        ADD_SPACER(to: hTitleContainer, width: 16)
        if(IPAD()){ ADD_SPACER(to: vMainContainer, height: 10) }
        // ------------------------
        let middleOrangeView = UIView()
        middleOrangeView.backgroundColor = CSS.shared.displayMode().main_bgColor // .orange
        vMainContainer.addArrangedSubview(middleOrangeView)
        
        let claimsContainerView = UIView()
        claimsContainerView.backgroundColor = CSS.shared.displayMode().main_bgColor
        middleOrangeView.addSubview(claimsContainerView)
        claimsContainerView.activateConstraints([
            claimsContainerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            claimsContainerView.centerXAnchor.constraint(equalTo: middleOrangeView.centerXAnchor)
        ])
        
        
        //if(IPHONE()) {
            
//        } else {
//            let hstack = HSTACK(into: vMainContainer)
//            ADD_SPACER(to: hstack, width: 16)
//            hstack.addArrangedSubview(claimsContainerView)
//        }
        
        let M: CGFloat = CSS.shared.iPhoneSide_padding
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        var col1: CGFloat = 0
        var col2: CGFloat = 0
        var index: Int = 0
        
        for (_, CO) in controversies.enumerated() {
            let controView = ControversyCellView(width: item_W)
            controView.buttonArea.hide()
            controView.tag = 600 + index
            if(claimsContainerView.subviews.count==0 && index==0 && IPHONE()){ controView.hideTopLine() }
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ControversyCellView? = nil
            if(index>0) {
                if(IPHONE()) {
                    prev = (claimsContainerView.subviews.last as! ControversyCellView)
                } else { // IPAD
                    if(index==1) {
                        prev = (claimsContainerView.subviews.first as! ControversyCellView)
                    } else {
                        prev = (claimsContainerView.subviews[index-2] as! ControversyCellView)
                    }
                }
            }
            
            claimsContainerView.addSubview(controView)
            controView.activateConstraints([
                controView.leadingAnchor.constraint(equalTo: claimsContainerView.leadingAnchor, constant: val_x),
                controView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(index==0) {
                controView.topAnchor.constraint(equalTo: claimsContainerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(index==1) { // col2
                        let first = claimsContainerView.subviews.first as! ControversyCellView
                        controView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        controView.topAnchor.constraint(equalTo: prev!.bottomAnchor, constant: 0).isActive = true
                    }
                }
            }
            controView.populate(with: CO)
            
            if(col==0) {
                col1 += controView.calculateHeight()
            } else {
                col2 += controView.calculateHeight()
            }
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += controView.calculateHeight()
                }
            } else {
                val_y += controView.calculateHeight()
            }
            
            if(index==controversies.count-1 && IPAD() && col==1) {
                val_y += controView.calculateHeight()
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controversyOnTap(_:)))
            controView.addGestureRecognizer(tapGesture)
            
            index += 1
        }
        
        if(IPAD()) {
            val_y = (col1 > col2) ? col1 : col2
        }
        
        middleOrangeView.heightAnchor.constraint(equalToConstant: val_y).isActive = true
        claimsContainerView.heightAnchor.constraint(equalToConstant: val_y).isActive = true
        
        ADD_SPACER(to: self.VStack, height: 16*2)
            let hLine = UIView()
            
            if(IPHONE()) {
                self.VStack.addArrangedSubview(hLine)
            } else {
                let hstack = HSTACK(into: self.VStack)
                ADD_SPACER(to: hstack, width: 16)
                hstack.addArrangedSubview(hLine)
                ADD_SPACER(to: hstack, width: 16)
            }
            
            hLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
            ADD_HDASHES(to: hLine)
        
        if(IPHONE()) {
            ADD_SPACER(to: self.VStack, height: 16/2)
        } else {
            ADD_SPACER(to: self.VStack, height: 16*2)
        }
    }

    @objc func controversyOnTap(_ gesture: UITapGestureRecognizer) {
        if let _view = gesture.view as? ControversyCellView {
            let index = _view.tag - 600
            
            let vc = ControDetailViewController()
            vc.slug = self.controversies[index].slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }

    func W() -> CGFloat {
        let M: CGFloat = CSS.shared.iPhoneSide_padding
        
        if(IPHONE()) {
            return SCREEN_SIZE().width - (M*2)
        } else {
            if(self.iPad_W == -1) {
                var value: CGFloat = 0
                let w = SCREEN_SIZE().width
                let h = SCREEN_SIZE().height
                
                if(w<h){ value = w }
                else{ value = h }
                self.iPad_W = value - IPAD_sideOffset() - 32 //- 74
            }
        
            return self.iPad_W
        }
    }

}

// MARK: - misc + Utils
extension StoryViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func attrText(_ text: String, index: Int) -> NSAttributedString {
        let font = AILERON_resize(15) //UIFont(name: "Aileron-Regular", size: 15)
        let fontItalic = AILERON_resize(15) //UIFont(name: "Aileron-Regular", size: 15)
        //let fontItalic = UIFont(name: "Merriweather-LightItalic", size: 14)
        let extraText = "[" + String(index) + "]"
        let mText = text + " " + extraText
        
        let attr = prettifyText(fullString: mText as NSString, boldPartsOfString: [],
            font: font, boldFont: font, paths: [], linkedSubstrings: [], accented: [])
        
        let mAttr = NSMutableAttributedString(attributedString: attr)
        
        var range = NSRange(location: 0, length: attr.string.count)
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: CSS.shared.displayMode().main_textColor,
            range: range)
        
        range = NSRange(location: attr.string.count - extraText.count, length: extraText.count)
        
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: CSS.shared.orange,
            range: range)
        mAttr.addAttribute(NSAttributedString.Key.font,
            value: fontItalic,
            range: range)
            
            
        return mAttr
    }
    
    private func prettifyText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, paths: [String], linkedSubstrings: [String], accented: [String]) -> NSAttributedString {

        let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font!, NSAttributedString.Key.foregroundColor: UIColor.label]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let accentedAttribute:  [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xD3592D), NSAttributedString.Key.strokeWidth: -5]
        
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        for l in 0..<paths.count {
            let sbstrRange = fullString.range(of: linkedSubstrings[l])
            boldString.addAttribute(.link, value: paths[l], range: sbstrRange)
        }
        for a in 0..<accented.count {
            let sbstrRange = fullString.range(of: accented[a])
            
            boldString.addAttributes(accentedAttribute, range: sbstrRange)
        }
        return boldString
    }
    
    func getSourceIcon(name: String, callback: @escaping (SourceIcon?) -> ()) {
        Sources.shared.checkIfLoaded { _ in // load sources (if needed)
            let id = Sources.shared.search(name: name)
            if let _id = id {
                let obj = Sources.shared.search(identifier: _id)
                if let _obj = obj {
                    callback(_obj)
                }
            }
            
            callback(nil)
        }
    }
    
}

// MARK: - Event(s)
extension StoryViewController {
    @objc func sourceButtonOnTap(_ sender: UIButton) {
        let tag = sender.tag - 200
        let url = self.groupedSources[tag].1
        
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: url)
        vc.showComponentsOnClose = false
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func showMoreButtonOnTap(_ sender: UIButton) {
        self.show3 = !self.show3
        
        if(self.showSplitSource) {
            self.populateFacts_new()
        } else {
            self.populateFacts()
        }
        
        //self.populateSources()
    }
    
    @objc func spinOnTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        let spin = self.spins[tag]
        
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: spin.url)
        vc.showComponentsOnClose = false
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func spinStanceIconOnTap(_ sender: UIButton) {
        let tag = sender.tag - 400
        let spin = self.spins[tag]
        
        let popup = StancePopupView()
        popup.populate(sourceName: spin.media_name, country: spin.media_country_code,
            LR: spin.LR, PE: spin.CP)
        popup.pushFromBottom()
    }
    
    @objc func articleOnTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        let article = self.articles[tag]
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: article.url)
        vc.showComponentsOnClose = false
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func articleStanceIconOnTap(_ sender: UIButton) {
        let tag = sender.tag - 400
        let article = self.articles[tag]
        
        var LR = 1
        var PE = 2
        if let stanceView = sender.superview?.viewWithTag(767) as? StanceIconView {
            LR = stanceView.getValues().0
            PE = stanceView.getValues().1
        }
        
        
        let popup = StancePopupView()
        let sourceName = article.media_title.components(separatedBy: " #").first!
        popup.populate(sourceName: sourceName, country: article.media_country_code, LR: LR, PE: PE)
        popup.pushFromBottom()
    }
    
    @objc func onImageCreditButtonTap(_ sender: UIButton?) {
        if(!self.imageCreditUrl.isEmpty){
            OPEN_URL(self.imageCreditUrl)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension StoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let extraMargin: CGFloat = 15
//        let playerHeight: CGFloat = self.audioPlayer.getHeight()
//        let playerBottom: CGFloat = 20 + 23 + 16 + self.titleLabelHeight + 16 + playerHeight
//        
//        if(scrollView.contentOffset.y > playerBottom) {
//            self.secondaryAudioPlayer.customShow()
//        } else {
//            self.secondaryAudioPlayer.customHide()
//        }


//        if(self.loadedStory.audio != nil && IPHONE()) {
//            self.upButton.hide()
//            return
//        }


        let posY = scrollView.contentOffset.y
        
        if(posY >= 100) {
            self.upButton.alpha = 1
            self.upButton.show()
        } else {
            self.upButton.hide()
        }
    }
     
    func calculateSectionsY() {
        self.sections_y = [CGFloat]()
        self.sections_y.append(0)
        
        for i in 1...3 {
            switch(i) {
                case 1:
                    if let _targetView = self.view.viewWithTag(140) {
                        let value = -self.contentView.convert(_targetView.frame.origin, to: _targetView).y
                        self.sections_y.append(value)
                    }
                case 2:
                    if let _targetView = self.view.viewWithTag(160) {
                        let value = self.contentView.convert(_targetView.frame.origin, to: self.scrollView).y
                        self.sections_y.append(value)
                    }
                case 3:
                    if let _targetView = self.view.viewWithTag(170) {
                        let value = self.contentView.convert(_targetView.frame.origin, to: self.scrollView).y
                        self.sections_y.append(value)
                    }
                default:
                    NOTHING()
            }
        }
    }
    
    @objc func onCustomBackButtonTap(_ notification: Notification) {
        let currentOffsetY = self.scrollView.contentOffset.y
        if(currentOffsetY <= 30) {
            CustomNavController.shared.popViewController(animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
            
    }
    
    @objc func onCustomBackButtonTap_2(_ notification: Notification) {
        //print("------------------------------")
        let currentOffsetY = self.scrollView.contentOffset.y
        //print("sections_y", self.sections_y)
        //print("currentOffsetY", currentOffsetY)
        
        for i in 1...4 {
            let section_y = self.sections_y[i-1]
            //print("Compare", Int(currentOffsetY), Int(section_y) )
            if(Int(currentOffsetY) > Int(section_y)) {
                //print("yep")
                self.backGoTo = i-1
            }
        }
        //print("calculated backGoTo", self.backGoTo)
        
        switch(self.backGoTo) {
            case -1:
                CustomNavController.shared.popViewController(animated: true)
                
            default:
                let destination_y = self.sections_y[self.backGoTo]
                if(destination_y == 0){ self.backGoTo = -1 }
                self.scrollView.setContentOffset(CGPoint(x: 0, y: destination_y), animated: true)
                
                //print("destination_y", destination_y)
                //print("final backGoTo", self.backGoTo)
        }
        
    }
    
    
}

/*
@objc func onTabButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        
        var val_Y: CGFloat = 0
        
        var view = UIView()
        switch(tag) {
            case 1:
                let view = self.view.viewWithTag(140)!
                val_Y = -self.contentView.convert(view.frame.origin, to: view).y
            case 2:
                view = self.view.viewWithTag(160)!
                val_Y = self.contentView.convert(view.frame.origin, to: self.scrollView).y
            case 3:
                view = self.view.viewWithTag(170)!
                val_Y = self.contentView.convert(view.frame.origin, to: self.scrollView).y
        
            default:
                NOTHING()
        }
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: val_Y), animated: true)
    }
 */

extension StoryViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if(self.loadedImage != nil) {
            let imgWidth: CGFloat = 16
            let imgHeight: CGFloat = 7.4
                    
            let W: CGFloat = SCREEN_SIZE().width - 26
            let H = (imgHeight * W)/imgWidth
            
            self.imageHeightConstraint?.constant = H
        }
        
        if let _content = self.view.viewWithTag(170) {
            _content.removeFromSuperview()
            self.addContent(self.loadedStory, self.deepDive)
        }
        

    }
    
}

extension StoryViewController {

    func addInfoButtonNextTo(label: UILabel, index: Int) {
        //label.text! += "(i)"
        
        if let _superview = label.superview {
            let label2 = UILabel()
            label2.text = label.text
            label2.font = label.font
            label2.textColor = .clear
            _superview.addSubview(label2)
            label2.activateConstraints([
                label2.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                label2.topAnchor.constraint(equalTo: label.topAnchor)
            ])
        
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: DisplayMode.imageName("storyInfo"))
            _superview.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 5),
                iconImageView.centerYAnchor.constraint(equalTo: label2.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 72/3),
                iconImageView.heightAnchor.constraint(equalToConstant: 72/3)
            ])
            
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            _superview.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -5),
                button.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
                button.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5)
            ])
            button.tag = index
            button.addTarget(self, action: #selector(infoButtonOnTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc func infoButtonOnTap(_ sender: UIButton?) {
        if let _sender = sender {
            let index = _sender.tag
            
            let popup = StoryInfoPopupView(title: self.getTitleFrom(index: index),
                    description: self.getDescriptionFrom(index: index),
                    linkedTexts: self.getLinkedTextsFrom(index: index),
                    links: self.getLinksFrom(index: index), height: self.getHeightFor(index: index))
                
            popup.pushFromBottom()
        }
    }
    
    func getHeightFor(index: Int) -> CGFloat {
        var result: CGFloat = 0
        
        switch(index) {
            case 1:
                return 280
                
            case 2:
                return 340
                
            case 3:
                return 310
                
            case 4:
                return 300
                
            default:
                NOTHING()
        }
        
        return result
    }
    
    func getLinksFrom(index: Int) -> [String] {
        switch(index) {
            case 3:
                return ["https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0271947"]
            case 4:
                return ["https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0271947"]
                
            default:
                return []
        }
    }
    
    func getLinkedTextsFrom(index: Int) -> [String] {
        switch(index) {
            case 3:
                return ["study"]
            case 4:
                return ["Metaculus"]
                
            default:
                return []
        }
    }
    
    func getDescriptionFrom(index: Int) -> String {
        var descr = ""
        
        switch(index) {
            case 1:
                descr = """
        We select the key facts for each story as agreed upon by a wide variety of outlets. Our sources include mainstream and establishment-critical media, public figure posts, and academic publications, among others. Our facts are carefully curated to provide the most important context, stripped of narrative and bias. These are thoroughly fact-checked against the sources by a dedicated team to ensure accuracy.
        """
        
            case 2:
                descr = """
        We neutrally provide the main arguments — or “narratives” — from different sides of the controversy, so you can make up your own mind on an issue and keep tabs on varying points of view. Depending on the topic, the narrative splits can be left v. right, Democratic v. Republican, pro-establishment (i.e. what all big US/Western parties and powers agree on) v. establishment critical, etc. Finally, for our readers interested in probability, we also strive to include a “Metaculus predictions” with a related prediction from the Metaculus community where possible.
        """
            case 3:
                descr = """
        We source our facts from a wide range of news outlets across the political and establishment spectrum, as well as supplementary primary sources (e.g. academic publications, social media posts by public figures, think tanks, NGOs, databases, etc.) where possible. We classify sources as left/right and pro-establishment/establishment-critical based on an MIT [0] on media bias conducted by Max Tegmark and Samantha D’Alonzo.
        """
            case 4:
                descr = """
        For those readers more interested in probability, we strive to include “Metaculus predictions” where possible. These provide forecasts of the most likely outcome of an event, according to the [0] prediction platform and aggregation engine. Framed as an interactive chart, you can further see how these predictions have changed over time by hovering over various points of the graph.
        """
        
            default:
                NOTHING()
        }
        
        
        return descr
    }
    
    func getTitleFrom(index: Int) -> String {
        switch(index) {
            case 1:
                return "The Facts"
            case 2:
                return "The Spin"
            case 3:
                return "Sources"
            case 4:
                return "Metaculus Prediction"
                
            default:
                return ""
        }
    }

}

extension StoryViewController: AudioPlayerViewDelegate {
    
    func AudioPlayerViewOnHeightChanged(sender: AudioPlayerView, height: CGFloat) {
        self.upButtonBottomConstraint?.constant = -10-height
    }
    
}

extension StoryViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.mainDocumentURL?.absoluteString {
            if(url.contains("metaculus.php")) {
                decisionHandler(.allow)
            } else if(url.contains("metaculus.com")) {
                let vc = ArticleViewController()
                vc.article = MainFeedArticle(url: url)
                vc.showComponentsOnClose = false
                vc.altTitle = "Metaculus"
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                decisionHandler(.cancel)
            }
            
            
        
//        if let url = navigationAction.request.url?.absoluteString {
//            print("URL", url)
            
            
            
            
//            if(url.contains("metaculus.php") || url.contains("question_embed")) {
//                decisionHandler(.allow)
//            } else {
//                //OPEN_URL(url)
//                
//                let vc = ArticleViewController()
//                vc.article = MainFeedArticle(url: url)
//                vc.showComponentsOnClose = false
//                vc.altTitle = "Metaculus"
//                CustomNavController.shared.pushViewController(vc, animated: true)
//                
//                decisionHandler(.cancel)
//            }
        }
    }
}

extension StoryViewController {
    
    func addSourceSplitGraph(container mainContainer: UIStackView) {
        let squareSize: CGFloat = 40
        let squareSep: CGFloat = 5
        let squareCount: CGFloat = 5
        let offset_x: CGFloat = 40
        let offset_y: CGFloat = 22

        let size = (squareSize * squareCount) + (squareSep * (squareCount-1))
        
        let containerView = UIView()
        containerView.backgroundColor = CSS.shared.displayMode().main_bgColor
        if(mainContainer == self.VStack) {
            containerView.activateConstraints([
                containerView.heightAnchor.constraint(equalToConstant: 330)
            ])
        }
//        self.VStack.addArrangedSubview(containerView)
        mainContainer.addArrangedSubview(containerView)
        
        let mTitleLabel = UILabel()
        mTitleLabel.font = DM_SERIF_DISPLAY_fixed_resize(17)
        if(IPAD()){ mTitleLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) }
        mTitleLabel.text = "Sources Split"
        mTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        containerView.addSubview(mTitleLabel)
        mTitleLabel.activateConstraints([
            mTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            mTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ])
        self.addInfoButtonNextTo(label: mTitleLabel, index: 3)
        
        let centeredView = UIView()
        centeredView.backgroundColor = CSS.shared.displayMode().main_bgColor
        containerView.addSubview(centeredView)
        centeredView.activateConstraints([
            centeredView.widthAnchor.constraint(equalToConstant: size + offset_x),
            centeredView.heightAnchor.constraint(equalToConstant: size + offset_y),
            centeredView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            centeredView.topAnchor.constraint(equalTo: mTitleLabel.bottomAnchor, constant: 30)
        ])
        
    // Squares ----------------------------------------------
        var pos_x: CGFloat = offset_x
        var pos_y: CGFloat = offset_y
        
        for _ in 1...Int(squareCount) {
            for _ in 1...Int(squareCount) {
                let squareView = UIView()
                squareView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xe3e3e3)
                squareView.layer.cornerRadius = 8
                centeredView.addSubview(squareView)
                squareView.activateConstraints([
                    squareView.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor, constant: pos_x),
                    squareView.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: pos_y),
                    squareView.widthAnchor.constraint(equalToConstant: squareSize),
                    squareView.heightAnchor.constraint(equalToConstant: squareSize),
                ])
                
                pos_x += squareSize + squareSep
            }
            
            pos_y += squareSize + squareSep
            pos_x = offset_x
        }
        
    // Vertical labels ----------------------------------------------
        let vOffsets: [CGFloat] = [30, 128, 210]
        let vTexts = ["ESTAB\nCRIT", "CENTER", "PRO\nESTAB"]
        let vAligns: [NSTextAlignment] = [.right, .center, .left]
        
        for i in 1...3 {
            let vLabel = UILabel()
            vLabel.numberOfLines = 2
            vLabel.font = AILERON_SEMIBOLD(11)
            vLabel.text = vTexts[i-1]
            vLabel.textAlignment = vAligns[i-1]
            vLabel.textColor = CSS.shared.displayMode().sec_textColor
            
            centeredView.addSubview(vLabel)
            vLabel.activateConstraints([
                vLabel.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor, constant: 0),
                vLabel.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: vOffsets[i-1])
            ])
            
            vLabel.transform = CGAffineTransform(rotationAngle: -(.pi/2)) // 90 degrees rotation
        }
        
    // Horizontal labels ----------------------------------------------
        let hOffsets: [CGFloat] = [40, 128, 226]
        let hTexts = ["LEFT", "CENTER", "RIGHT"]
        let hAligns: [NSTextAlignment] = [.left, .center, .right]
    
        for i in 1...3 {
            let hLabel = UILabel()
            hLabel.numberOfLines = 1
            hLabel.font = AILERON_SEMIBOLD(11)
            hLabel.text = hTexts[i-1]
            hLabel.textAlignment = vAligns[i-1]
            hLabel.textColor = CSS.shared.displayMode().sec_textColor
            
            centeredView.addSubview(hLabel)
            hLabel.activateConstraints([
                hLabel.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor, constant: hOffsets[i-1]),
                hLabel.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: 0)
            ])
        }
        
    // Sources -------------------------------------------------------
        var alreadyLoaded = [String]()
        
        for F in self.facts {
            for S in F.sources {
                if(!S.id.isEmpty && S.LR != -1 && S.CP != -1) {
                    if(!alreadyLoaded.contains(S.id)) {
                        let _pos_x: CGFloat = offset_x + ((CGFloat(S.LR)-1) * (squareSize + squareSep))
                        let _pos_y: CGFloat = offset_y + ((CGFloat(S.CP)-1) * (squareSize + squareSep))
                        
                        let newIcon = UIImageView()
                        newIcon.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
                        centeredView.addSubview(newIcon)
                        newIcon.activateConstraints([
                            newIcon.widthAnchor.constraint(equalToConstant: 28),
                            newIcon.heightAnchor.constraint(equalToConstant: 28),
                            newIcon.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: _pos_y+6),
                            newIcon.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor, constant: _pos_x+6)
                        ])
                        
                        if let _icon = Sources.shared.search(identifier: S.id), _icon.url != nil {
                            if(!_icon.url!.contains(".svg")) {
                                newIcon.sd_setImage(with: URL(string: _icon.url!))
                            } else {
                                newIcon.image = UIImage(named: _icon.identifier + ".png")
                            }
                        } else {
                            let url = BUILD_LOGO_URL(id: S.name)
                            
                            newIcon.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
                                if let _ = error {
                                    newIcon.image = UIImage(named: "LINK64.png")
                                } else {
                                    newIcon.superview?.bringSubviewToFront(newIcon)
                                }
                            }
                        }
                        
                        newIcon.layer.cornerRadius = 28/2
                        newIcon.clipsToBounds = true
                        
                        ///////////
                        alreadyLoaded.append(S.id)
                    }
                }
            }
        }
        
        
    }
    
    func addTags(_ tags: [Tag]) {
        self.tags = tags
        if(tags.count == 0){ return }
        
        let hStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: hStack, width: 16)
        
        let mainContainer = VSTACK(into: hStack, spacing: 6)
        mainContainer.backgroundColor = .clear
        
        let tagHeight: CGFloat = 24
        let limit = SCREEN_SIZE().width-32
        
        var val_x: CGFloat = 0

        for (i, T) in tags.enumerated() {
            let tagLabel = UILabel()
            tagLabel.backgroundColor = .clear
            tagLabel.text = "#" + T.name.uppercased()
            tagLabel.textColor = CSS.shared.displayMode().sec_textColor
            tagLabel.font = AILERON(12)
    
            let tagWidth = tagLabel.calculateWidthFor(height: tagHeight)+16
        
            var createRow = false
            if(val_x == 0) {
                createRow = true
            } else if(val_x + tagWidth > limit) {
                createRow = true
            }
            
            var rowView: UIView
            if(createRow) {
                val_x = 0
            
                rowView = UIView()
                rowView.backgroundColor = .clear
                rowView.heightAnchor.constraint(equalToConstant: tagHeight).isActive = true
                mainContainer.addArrangedSubview(rowView)
            } else {
                rowView = mainContainer.arrangedSubviews.last!
            }
            
             let tagView = UIView()
            tagView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xe3e3e3)
            tagView.layer.cornerRadius = 6.0
            rowView.addSubview(tagView)
            tagView.activateConstraints([
                tagView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
                tagView.topAnchor.constraint(equalTo: rowView.topAnchor),
                tagView.heightAnchor.constraint(equalToConstant: tagHeight),
                tagView.widthAnchor.constraint(equalToConstant: tagWidth)
            ])
            
            tagView.addSubview(tagLabel)
            tagLabel.activateConstraints([
                tagLabel.centerXAnchor.constraint(equalTo: tagView.centerXAnchor),
                tagLabel.centerYAnchor.constraint(equalTo: tagView.centerYAnchor)
            ])

            let buttonArea = UIButton(type: .system)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            tagView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: tagView.leadingAnchor),
                buttonArea.topAnchor.constraint(equalTo: tagView.topAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: tagView.trailingAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: tagView.bottomAnchor)
            ])
            buttonArea.tag = i
            buttonArea.addTarget(self, action: #selector(self.onTagTap(_:)), for: .touchUpInside)

            val_x += tagWidth + 6
        }
        
        ADD_SPACER(to: hStack, width: 16)
        ADD_SPACER(to: self.VStack, height: 16)
    }
    
    @objc func onTagTap(_ sender: UIButton?) {
        let index = sender!.tag
        let T = self.tags[index].id
        
        if(IPHONE()) {
            let vc = MainFeed_v3_viewController()
            vc.topic = T
            vc.reloadOnError = false
            CustomNavController.shared.pushViewController(vc, animated: true)
        } else {
            let vc = MainFeediPad_v3_viewController()
            vc.topic = T
            vc.reloadOnError = false
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
        
        
    }

}
