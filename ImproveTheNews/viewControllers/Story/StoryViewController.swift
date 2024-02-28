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
    var imageHeightConstraint: NSLayoutConstraint? = nil
    
    var imageCreditUrl: String = ""
    var audioPlayer = AudioPlayerView()
    var secondaryAudioPlayer = AudioPlayerView(secondary: true)
    var titleLabelHeight: CGFloat = 0
    var lastSourceIndex = -1
    
    var isContext: Bool = false
    var thirdPillText = "Articles"
    
    var sections_y = [CGFloat]()
    var backGoTo: Int = -1
    
    var loadedImage: UIImage? = nil
    var loadedStory: MainFeedStory!
    
    
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
            self.navBar.setShareUrl(self.story!.url, vc: self)
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollView.delegate = self
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .green
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
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
        self.storyData.load(url: self.story!.url) { (story) in
            if(story == nil) {
                // Empty story content
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading your story,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
//                    DELAY(1.0) {
//                        self.loadContent()
//                    }
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    self.scrollView.show()
                    
                    if let _story = story {
                        self.loadedStory = _story
                        self.addContent(_story)
                        
                        DELAY(1.0) {
                            self.calculateSectionsY()
                        }
                    }
                }
            }
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

    func addContent(_ story: MainFeedStory) {
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
//        let line2 = UIView()
//        self.VStack.addArrangedSubview(line2)
//        line2.activateConstraints([
//            line2.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        ADD_HDASHES(to: line2)
        
        //self.addPill()
        if(story.splitType.isEmpty) {
            if(self.isContext) {
                self.thirdPillText = "Go deeper"
            } else {
                self.thirdPillText = "Articles"
            }
        } else {
            self.thirdPillText = "Split"
        }
        
        
        self.addTabs()
        self.addTitle(text: story.title)
        self.addAudioPlayer(story.audio)
        
        if(self.isContext) {
            self.story?.videoFile = story.video
            self.addVideo()
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
        
        self.addStoryMetaData(time: story.time)

        if(!story.image_credit_title.isEmpty && !story.image_credit_url.isEmpty) {
            self.addImageCredit(story.image_credit_title, story.image_credit_url)
        }

//        story.time
//
//        MainFeedArticle
//        MainFeedStory
        
        self.addFactsStructure()
            self.facts = story.facts
            self.groupSources()     // works with self.facts
            self.populateFacts()    // works with self.facts
        
        self.addSpins(story.spins)
        
        self.addSourcesStructure()
            self.populateSources()

        if(story.splitType.isEmpty) {
            if(self.isContext) {
                self.addGoDeeper(stories: story.goDeeper)
            } else {
                self.addArticles(story.articles)
            }
        } else {
            self.addSplitArticles(type: story.splitType, story.articles)
        }
        
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
    }

    //----
    func addTabs() {
    ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding*1.5)
        let containerView = UIView()
        self.VStack.addArrangedSubview(containerView)
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding*4))/3
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
        }
        
    ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
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
    
    private func addGoDeeper(stories: [StorySearchResult]) {
        if(stories.count==0){ return }
        
        let sectionView = UIView()
        sectionView.tag = 170
        //sectionView.backgroundColor = .yellow.withAlphaComponent(0.3)
        //ADD_SPACER(to: self.VStack, height: 10)
        self.VStack.addArrangedSubview(sectionView)
        
        let title = UILabel()
        title.textColor = CSS.shared.displayMode().main_textColor
        //title.backgroundColor = .red.withAlphaComponent(0.3)
        title.font = CSS.shared.iPhoneStoryContent_subTitleFont
        title.text = "Go Deeper"
        sectionView.addSubview(title)
        title.activateConstraints([
            title.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15)
        ])
        
        var W: CGFloat = SCREEN_SIZE().width - (15*2)
        var posY: CGFloat = 20 + title.calculateHeightFor(width: W) + 20
        W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 3))/2
        
        var storiesCopy = stories
        while(storiesCopy.count>0) {

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
            let VIEW1 = iPhoneAllNews_vImgCol_v3(width: W)
            let VIEW2 = iPhoneAllNews_vImgCol_v3(width: W)
            
            // item 1
            if let _A = storiesCopy.first {
                VIEW1.refreshDisplayMode()
                VIEW1.populate(story: _A)
                H1 = VIEW1.calculateHeight()
                colsHStack.addArrangedSubview(VIEW1)
                VIEW1.activateConstraints([
                    VIEW1.widthAnchor.constraint(equalToConstant: W)
                ])
                
                storiesCopy.removeFirst()
            } else {
                H1 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            // item 2
            if let _A = storiesCopy.first {
                VIEW2.refreshDisplayMode()
                VIEW2.populate(story: _A)
                H2 = VIEW2.calculateHeight()
                colsHStack.addArrangedSubview(VIEW2)
                VIEW2.activateConstraints([
                    VIEW2.widthAnchor.constraint(equalToConstant: W)
                ])
                
                storiesCopy.removeFirst()
            } else {
                H2 = 0
                ADD_SPACER(to: colsHStack, width: W)
            }
            
            let maxH = (H1 > H2) ? H1 : H2
            VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
            VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true

            posY += maxH
        }
        
        
//        var col = 1
//        var prevH: CGFloat = 0
//        for (i, ST) in stories.enumerated() {
//            let storyView = FAQ_normalStoryView()
//            sectionView.addSubview(storyView)
//            storyView.activateConstraints([
//                storyView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: (col == 1) ? 15 : (15+columnW+15)),
//                storyView.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: posY),
//                storyView.widthAnchor.constraint(equalToConstant: columnW)
//            ])
//            
//            storyView.populate(MainFeedArticle(story: ST))
//            storyView.refreshDisplayMode()
//            
//            let H = storyView.getHeight(forColumnWidth: columnW)
//            storyView.heightAnchor.constraint(equalToConstant: H).isActive = true
//            
//            if(col==1) {
//                prevH = H
//            }
//            
//            col += 1
//            if(col == 3) {
//                col = 1
//                var max = H
//                if(prevH > max){ max = prevH }
//                posY += max + 15
//            } else if(i == stories.count-1) {
////                var max = H
////                if(prevH > max){ max = prevH }
////                posY += max + 15
//
//                posY += H + 15
//            }
//        }
        
        sectionView.activateConstraints([
            sectionView.heightAnchor.constraint(equalToConstant: posY)
        ])
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
            noArticlesLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noArticlesLabel.text = "No articles available"
            noArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(noArticlesLabel)
        } else {
            let ArticlesLabel = UILabel()
            ArticlesLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            ArticlesLabel.text = "Articles on this story"
            if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            ArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
            innerHStack.addArrangedSubview(ArticlesLabel)
            
            ADD_SPACER(to: innerHStack, height: 12)
            
            //for (i, A) in articles.enumerated() {
            
            let W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 3))/2
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
            noArticlesLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
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
            ArticlesLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            ArticlesLabel.text = title
            if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
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
                headerLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
                headerLabel.textColor = CSS.shared.displayMode().header_textColor
                headerLabel.textAlignment = .center
                
                let W = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding*3)
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
            let W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 3))/2
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
        ArticlesLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
        ArticlesLabel.text = title
        if(IPAD()){ ArticlesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
        }
        ArticlesLabel.textColor = CSS.shared.displayMode().main_textColor
        innerHStack.addArrangedSubview(ArticlesLabel)
        ADD_SPACER(to: innerHStack, height: 18)
        
        var articlesCopy = articles
        // Show columns --------------------------------
        let W = (SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 3))/2
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
    
    private func addSpins(_ spins: [Spin]) {
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
                SpinsLabel.text = "Spin"
                SpinsLabel.textColor = CSS.shared.displayMode().main_textColor
                titleHStack.addArrangedSubview(SpinsLabel)
                
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
            ///
                
                
                continue
                
                //if(!S.image.isEmpty && !S.subTitle.isEmpty && !S.media_title.isEmpty) {
                if(!S.image.isEmpty && !S.media_title.isEmpty) {
                    ADD_SPACER(to: innerHStack, height: CSS.shared.iPhoneSide_padding * 2)
                    let HStack_image = HSTACK(into: innerHStack)
                    //HStack_image.backgroundColor = .orange

                    let VStack_image = VSTACK(into: HStack_image)
                    //VStack_image.backgroundColor = .yellow
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.backgroundColor = .darkGray
                    VStack_image.addArrangedSubview(imageView)
                    imageView.activateConstraints([
                        imageView.widthAnchor.constraint(equalToConstant: 146 * 0.8),
                        imageView.heightAnchor.constraint(equalToConstant: 98 * 0.8)
                    ])
                    
                    imageView.sd_setImage(with: URL(string: S.image), placeholderImage: nil, options: .retryFailed) { (img, error, cacheType, url) in
                        if(error != nil) {
                            print("IMG ERROR", error?.localizedDescription)
                            imageView.image = nil
                            
                            let imgIcon = UIImageView(image: UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate))
                            imgIcon.tintColor = .white.withAlphaComponent(0.5)
                            
                            imageView.addSubview(imgIcon)
                            imgIcon.activateConstraints([
                                imgIcon.widthAnchor.constraint(equalToConstant: 40),
                                imgIcon.heightAnchor.constraint(equalToConstant: 30),
                                imgIcon.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                                imgIcon.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
                            ])
                        }
                    }
                    //imageView.sd_setImage(with: URL(string: S.image))
                    ADD_SPACER(to: VStack_image) // V fill

                    ADD_SPACER(to: HStack_image, width: 12)

                    let VStack_data = VSTACK(into: HStack_image)
                    //VStack_data.backgroundColor = .green
                    let subTitleLabel = UILabel()
                    subTitleLabel.font = DM_SERIF_DISPLAY_fixed(13) //MERRIWEATHER_BOLD(13)
                    subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
                    subTitleLabel.numberOfLines = 0
                    subTitleLabel.text = S.subTitle
                    VStack_data.addArrangedSubview(subTitleLabel)
                    ADD_SPACER(to: VStack_data, height: CSS.shared.iPhoneSide_padding)
                    
                    let HStack_source = HSTACK(into: VStack_data)
                    HStack_source.activateConstraints([
                        HStack_source.heightAnchor.constraint(equalToConstant: 28)
                    ])
                    //HStack_source.backgroundColor = .systemPink

                    if(!S.media_country_code.isEmpty) {
                        let VStack_flag = VSTACK(into: HStack_source)
                        //VStack_flag.backgroundColor = .green
                        let flagImageView = UIImageView()
                        
                        if let _image = UIImage(named: S.media_country_code.uppercased() + "64.png") {
                            flagImageView.image = _image
                        } else {
                            flagImageView.image = UIImage(named: "noFlag.png")
                        }
                        
                        ADD_SPACER(to: VStack_flag, height: 5)
                        VStack_flag.addArrangedSubview(flagImageView)
                        flagImageView.activateConstraints([
                            flagImageView.widthAnchor.constraint(equalToConstant: 18),
                            flagImageView.heightAnchor.constraint(equalToConstant: 18)
                        ])
                        ADD_SPACER(to: VStack_flag, height: 5)
                        
                        ADD_SPACER(to: HStack_source, width: 6)
                    }
                    
                    if(!S.media_label.isEmpty) {
                        let sourcesContainer = UIStackView()
                        HStack_source.addArrangedSubview(sourcesContainer)
                        ADD_SOURCE_ICONS(data: [S.media_label], to: sourcesContainer, containerHeight: 28)
                    }

                    let sourceLabel = UILabel()
                    sourceLabel.text = S.media_name
                    sourceLabel.font = ROBOTO(12)
                    sourceLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
                    HStack_source.addArrangedSubview(sourceLabel)
                    ADD_SPACER(to: HStack_source, width: 8)
                    
                    let stanceIcon = StanceIconView()
                    HStack_source.addArrangedSubview(stanceIcon)
                    stanceIcon.setValues(S.LR, S.CP)
                    
                    stanceIcon.alpha = 1
                    if(S.LR==0 || S.CP==0) {
                        stanceIcon.alpha = 0
                    }
                    
                    ADD_SPACER(to: HStack_source) // H fill
                    
                    if(!S.timeRelative.isEmpty) {
                        let timeLabel = UILabel()
                        timeLabel.text = "updated " + S.timeRelative
                        timeLabel.font = ROBOTO(12)
                        timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
                        VStack_data.addArrangedSubview(timeLabel)
                    }
                    ADD_SPACER(to: VStack_data) // V fill
                    
                    let mainButton = UIButton(type: .custom)
                    //mainButton.backgroundColor = .red.withAlphaComponent(0.25)
                    HStack_image.addSubview(mainButton)
                    mainButton.activateConstraints([
                        mainButton.leadingAnchor.constraint(equalTo: HStack_image.leadingAnchor),
                        mainButton.trailingAnchor.constraint(equalTo: HStack_image.trailingAnchor),
                        mainButton.topAnchor.constraint(equalTo: HStack_image.topAnchor),
                        mainButton.bottomAnchor.constraint(equalTo: HStack_image.bottomAnchor)
                    ])
                    mainButton.tag = 300+i
                    mainButton.addTarget(self, action: #selector(spinOnTap(_:)), for: .touchUpInside)
                    
                    let miniButton = UIButton(type: .custom)
                    //miniButton.backgroundColor = .red.withAlphaComponent(0.25)
                    HStack_image.addSubview(miniButton)
                    miniButton.activateConstraints([
                        miniButton.leadingAnchor.constraint(equalTo: stanceIcon.leadingAnchor),
                        miniButton.trailingAnchor.constraint(equalTo: stanceIcon.trailingAnchor),
                        miniButton.topAnchor.constraint(equalTo: stanceIcon.topAnchor),
                        miniButton.bottomAnchor.constraint(equalTo: stanceIcon.bottomAnchor)
                    ])
                    miniButton.tag = 400+i
                    miniButton.addTarget(self, action: #selector(spinStanceIconOnTap(_:)), for: .touchUpInside)
                    
                    ADD_SPACER(to: innerHStack, height: 20) // Space to next item
                    let line = UIView()
                    line.backgroundColor = .clear //.systemPink
                    innerHStack.addArrangedSubview(line)
                    line.activateConstraints([
                        line.heightAnchor.constraint(equalToConstant: 2.0)
                    ])
                    
//                    if(i < spins.count-1) {
//                        // Dashes
//                        line.clipsToBounds = true
//                        let dash_long: CGFloat = 5
//                        let dash_sep: CGFloat = 2
//                        var val_x: CGFloat = 0
//                        let dash_color = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0x1D242F).withAlphaComponent(0.2)
//                        
//                        var maxDim = SCREEN_SIZE().width
//                        if(SCREEN_SIZE().height > maxDim){ maxDim = SCREEN_SIZE().height }
//                        
//                        while(val_x < maxDim) {
//                            let dash = UIView()
//                            dash.backgroundColor = dash_color
//                            line.addSubview(dash)
//                            dash.frame = CGRect(x: val_x, y: 0, width: dash_long, height: 2.0)
//                            
//                            val_x += dash_long + dash_sep
//                        }
//                        
//                        ADD_SPACER(to: innerHStack, height: 20) // Space to next item
//                    } else {
//                        ADD_SPACER(to: innerHStack, height: 1) // Space to next item
//                    }
                    
                    
                }
                
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
            FactsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            
            //DM_SERIF_DISPLAY_fixed(17) //MERRIWEATHER_BOLD(17)
            if(IPAD()){ FactsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            FactsLabel.text = "The Facts"
            FactsLabel.textColor = CSS.shared.displayMode().main_textColor
            //DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(FactsLabel)
            
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
                contentLabel.font = CSS.shared.iPhoneStoryContent_textFont
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
        SourcesLabel.font = DM_SERIF_DISPLAY_fixed(17) //MERRIWEATHER_BOLD(17)
        if(IPAD()){ SourcesLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
        }
        SourcesLabel.text = "Sources"
        SourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        VStack.addArrangedSubview(SourcesLabel)
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
        let sourceHeight: CGFloat = 18
        
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
            sourceLabel.font = CSS.shared.iPhoneStoryContent_textFont //ROBOTO(15)
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
        innerVStack.tag = 140
        //ADD_SPACER(to: innerHStack, width: 13)
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
    
    
    private func addImageCredit(_ title: String, _ url: String) {
        let prefix = "Photo: "
        let creditLabel = UILabel()
        creditLabel.numberOfLines = 0
        creditLabel.font = ROBOTO(14)
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
        let webBrowser = WKWebView()
        
        let H = (SCREEN_SIZE().width * 9)/16
        self.VStack.addArrangedSubview(webBrowser)
        webBrowser.activateConstraints([
            webBrowser.heightAnchor.constraint(equalToConstant: H)
        ])
        
        let videoURL = URL(string: "https://www.youtube.com/embed/" + self.story!.videoFile!)!
        let request = URLRequest(url: videoURL)
        webBrowser.load(request)
        
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
            //self.secondaryAudioPlayer.customHide()
            self.secondaryAudioPlayer.customShow()
        }
    }

    private func addStoryMetaData(time: String) {
        let rowView = UIView()
        rowView.activateConstraints([
            rowView.heightAnchor.constraint(equalToConstant: 24)
        ])
        rowView.clipsToBounds = false
        rowView.backgroundColor = self.view.backgroundColor
    
        if(IPAD()) {
            ADD_SPACER(to: self.VStack, height: 10)
        }
    
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        HStack.addArrangedSubview(rowView)
        ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
        
        let pill = StoryPillView()
        pill.buildInto(rowView)
        pill.activateConstraints([
            pill.topAnchor.constraint(equalTo: rowView.topAnchor),
            pill.leadingAnchor.constraint(equalTo: rowView.leadingAnchor)
        ])
        if(self.isContext) {
            pill.setAsContext()
        }
        
        var sources: SourceIconsView!
        if(PREFS_SHOW_SOURCE_ICONS()) {
            sources = SourceIconsView()
            sources.buildInto(rowView)
            sources.activateConstraints([
                sources.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
                sources.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding)
            ])
            sources.load(self.story!.storySources)
            sources.refreshDisplayMode()
        }

        let timeLabel = UILabel()
        timeLabel.font = CSS.shared.iPhoneStory_textFont
        timeLabel.textAlignment = .right
        timeLabel.text = FIX_TIME(time).uppercased()
        timeLabel.textColor = CSS.shared.displayMode().sec_textColor
        rowView.addSubview(timeLabel)
        timeLabel.activateConstraints([
            timeLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
        ])
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            timeLabel.leadingAnchor.constraint(equalTo: sources.trailingAnchor, constant: 8).isActive = true
        } else {
            timeLabel.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: CSS.shared.iPhoneSide_padding).isActive = true
        }
        
        
        
//        self.time_leading = timeLabel.leadingAnchor.constraint(equalTo: sources.trailingAnchor, constant: 8)
//        self.time_leading?.isActive = true
        
        //self.timeLabel.text = article.time.uppercased()
        
        ADD_SPACER(to: self.VStack, height: CSS.shared.iPhoneSide_padding)
    }
    
    private func addTitle(text: String) {
        let titleLabel = UILabel()
        titleLabel.font = CSS.shared.iPhoneStoryContent_titleFont //DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
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
        let font = UIFont(name: "Aileron-Regular", size: 15)
        let fontItalic = UIFont(name: "Aileron-Regular", size: 15)
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
            value: fontItalic!,
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
        self.populateFacts()
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
    }
     
    func calculateSectionsY() {
        self.sections_y = [CGFloat]()
        self.sections_y.append(0)
        
        for i in 1...3 {
            switch(i) {
                case 1:
                    let targetView = self.view.viewWithTag(140)!
                    let value = -self.contentView.convert(targetView.frame.origin, to: targetView).y
                    self.sections_y.append(value)
                case 2:
                    let targetView = self.view.viewWithTag(160)!
                    let value = self.contentView.convert(targetView.frame.origin, to: self.scrollView).y
                    self.sections_y.append(value)
                case 3:
                    let targetView = self.view.viewWithTag(170)!
                    let value = self.contentView.convert(targetView.frame.origin, to: self.scrollView).y
                    self.sections_y.append(value)
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
            
            self.addContent(self.loadedStory)
        }

    }
    
}

