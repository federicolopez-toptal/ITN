//
//  StoryViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import UIKit
import SDWebImage


class StoryViewController: BaseViewController {
    
    var story: MainFeedArticle?
    var storyData = StoryContent()
    var groupedSources = [(String, String)]()
    
    let navBar = NavBarView()
    let line = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    var show3 = true
    var facts: [Fact]!
    var spins: [Spin]!
    var articles: [StoryArticle]!
    var imageHeightConstraint: NSLayoutConstraint? = nil
    
    deinit {
        self.hideLoading()
    }
    
    // MARK: - Init/Start
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.backToFeed])
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.line)
        self.line.backgroundColor = .red
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.line.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
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
        self.VStack.spacing = 8
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -13),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
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
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
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
                message: "There was an error while retrieving your story. Please try again later", onCompletion: {
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
                        self.addContent(_story)
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
        
        self.addPill()
        self.addTitle(text: story.title)
        self.addImage(imageUrl: story.image_src)
        
//        print(self.story!.time)
//        print(story.time)
        
//        if(!self.story!.time.isEmpty) { // self.story
//            self.addTime(time: self.story!.time)
//        }
        if(!story.time.isEmpty) { // self.story
            self.addTime(time: story.time)
        }
        
        self.addFactsStructure()
            self.facts = story.facts
            self.groupSources()     // works with self.facts
            self.populateFacts()    // works with self.facts
        
        self.addSpins(story.spins)
        
        self.addArticles(story.articles)
//        if(story.splitType.isEmpty) {
//            self.addArticles(story.articles)
//        } else {
//            self.addSplitArticles(type: story.splitType, story.articles)
//        }
        
        // TMP //------------------------------------------
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.VStack.backgroundColor = .clear

//        DELAY(1.0) {
//            self.scrollToBottom()
//        }
    }

    // ------------------------------------------
    private func addArticles(_ articles: [StoryArticle]) {
        self.articles = articles
        ADD_SPACER(to: self.VStack, height: 12)
    
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 12)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 12)
        
       if(articles.count == 0) {
            let noArticlesLabel = UILabel()
            noArticlesLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ noArticlesLabel.font = MERRIWEATHER_BOLD(19) }
            noArticlesLabel.text = "No articles available"
            noArticlesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(noArticlesLabel)
        } else {
            let ArticlesLabel = UILabel()
            ArticlesLabel.font = MERRIWEATHER_BOLD(17)
            ArticlesLabel.text = "Articles on this story"
            if(IPAD()){ ArticlesLabel.font = MERRIWEATHER_BOLD(19) }
            ArticlesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(ArticlesLabel)
            
            ADD_SPACER(to: innerHStack, height: 12)
            for (i, A) in articles.enumerated() {
                if(!A.image.isEmpty && !A.title.isEmpty && !A.media_title.isEmpty) {
                    ADD_SPACER(to: innerHStack, height: 16)
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
                    imageView.sd_setImage(with: URL(string: A.image))
                    ADD_SPACER(to: VStack_image) // V fill

                    ADD_SPACER(to: HStack_image, width: 12)

                    let VStack_data = VSTACK(into: HStack_image)
                    //VStack_data.backgroundColor = .green
                    let subTitleLabel = UILabel()
                    subTitleLabel.font = MERRIWEATHER_BOLD(14)
                    subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
                    subTitleLabel.numberOfLines = 0
                    subTitleLabel.text = A.title
                    VStack_data.addArrangedSubview(subTitleLabel)
                    ADD_SPACER(to: VStack_data, height: 8)
                    
                    let HStack_source = HSTACK(into: VStack_data)
                    HStack_source.activateConstraints([
                        HStack_source.heightAnchor.constraint(equalToConstant: 28)
                    ])
                    //HStack_source.backgroundColor = .systemPink

                    if(!A.media_country_code.isEmpty) {
                        let VStack_flag = VSTACK(into: HStack_source)
                        //VStack_flag.backgroundColor = .green
                        let flagImageView = UIImageView()
                        
                        if let _image = UIImage(named: A.media_country_code.uppercased() + "64.png") {
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
                         
                    var LR = 0
                    var PE = 0
                         
                    let sourceName = A.media_title.components(separatedBy: " #").first!
                    self.getSourceIcon(name: sourceName) { (icon) in
                        if let _icon = icon {
                            let sourcesContainer = UIStackView()
                            HStack_source.addArrangedSubview(sourcesContainer)
                            ADD_SOURCE_ICONS(data: [_icon.identifier],
                                to: sourcesContainer, containerHeight: 28)
                                
                            LR = _icon.LR
                            PE = _icon.PE
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
                    stanceIcon.alpha = 1
                    if(LR==0 || PE==0) {
                        stanceIcon.alpha = 0
                    }
                    
                    ADD_SPACER(to: HStack_source) // H fill

                    if(!A.timeRelative.isEmpty) {
                        let timeLabel = UILabel()
                        timeLabel.text = "updated " + A.timeRelative
                        timeLabel.font = ROBOTO(12)
                        timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
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
                    mainButton.addTarget(self, action: #selector(articleOnTap(_:)), for: .touchUpInside)

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
                    miniButton.addTarget(self, action: #selector(articleStanceIconOnTap(_:)), for: .touchUpInside)
//
                    ADD_SPACER(to: innerHStack, height: 20) // Space to next item
//                    let line = UIView()
//                    //line.backgroundColor = .black
//                    innerHStack.addArrangedSubview(line)
//                    line.activateConstraints([
//                        line.heightAnchor.constraint(equalToConstant: 2.0)
//                    ])
//                        // Dashes
//                        line.clipsToBounds = true
//                        let dash_long: CGFloat = 5
//                        let dash_sep: CGFloat = 2
//                        var val_x: CGFloat = 0
//                        let dash_color = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
//                        while(val_x < SCREEN_SIZE().width) {
//                            let dash = UIView()
//                            dash.backgroundColor = dash_color
//                            line.addSubview(dash)
//                            dash.frame = CGRect(x: val_x, y: 0, width: dash_long, height: 2.0)
//
//                            val_x += dash_long + dash_sep
//                        }
//
//                    ADD_SPACER(to: innerHStack, height: 20) // Space to next item
                }
            }
            // --- //
        }
    }
    
    private func addSplitArticles(type: String, _ articles: [StoryArticle]) {
        self.articles = articles
        ADD_SPACER(to: self.VStack, height: 12)

        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 12)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 12)
        
       if(articles.count == 0) {
            let noArticlesLabel = UILabel()
            noArticlesLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ noArticlesLabel.font = MERRIWEATHER_BOLD(19) }
            noArticlesLabel.text = "No articles available"
            noArticlesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(noArticlesLabel)
        } else {
            var title = "Political split"
            if(type.uppercased() == "PE") {
                title = "Establishment split"
            }
        
            let ArticlesLabel = UILabel()
            ArticlesLabel.font = MERRIWEATHER_BOLD(17)
            ArticlesLabel.text = title
            if(IPAD()){ ArticlesLabel.font = MERRIWEATHER_BOLD(19) }
            ArticlesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(ArticlesLabel)
            ADD_SPACER(to: innerHStack, height: 15)
            
            let headers = HSTACK(into: innerHStack)
            headers.spacing = 20
            headers.backgroundColor = .clear //.orange
            headers.distribution = .fillEqually
            for i in 1...2 {
                var text = ""
                if(type.uppercased() == "PE") {
                    if(i==1) { text = "CRITICAL" }
                    else { text = "PRO" }
                } else {
                    if(i==1) { text = "LEFT" }
                    else { text = "RIGHT" }
                }
                
                let headerLabel = UILabel()
                headerLabel.text = text
                headerLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
                headerLabel.font = ROBOTO_BOLD(14)
                headers.addArrangedSubview(headerLabel)
            }
            innerHStack.addArrangedSubview(headers)
            
            var column = 1
            for (i, A) in articles.enumerated() {
                if(!A.image.isEmpty && !A.title.isEmpty && !A.media_title.isEmpty) {
                    if(column==1){
                        ADD_SPACER(to: innerHStack, height: 16)
                    }
                    
                    let hStackColumns: UIStackView!
                    if(column == 1) {
                        hStackColumns = HSTACK(into: innerHStack)
                        hStackColumns.spacing = 20
                        hStackColumns.distribution = .fillEqually
                    } else {
                        hStackColumns = innerHStack.arrangedSubviews.last as! UIStackView
                    }
                    
                    let newItem = articleColumnView(A, i: i)
                    hStackColumns.addArrangedSubview(newItem)
                    
                    column += 1
                    if(column == 3){
                        column = 1
                    }
                    
                    if(i==articles.count-1) {
                        let line = UIView()
                        line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
                        innerHStack.addSubview(line)
                        line.activateConstraints([
                            line.widthAnchor.constraint(equalToConstant: 1.5),
                            line.centerXAnchor.constraint(equalTo: innerHStack.centerXAnchor),
                            line.topAnchor.constraint(equalTo: headers.topAnchor),
                            line.bottomAnchor.constraint(equalTo: newItem.bottomAnchor)
                        ])
                    }
                    
                    
                }
            }
        }
    }
    
    private func articleColumnView(_ A: StoryArticle, i: Int) -> UIView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        vStack.addArrangedSubview(imageView)
        imageView.activateConstraints([
            imageView.heightAnchor.constraint(equalToConstant: 98 * 0.8)
        ])
        imageView.sd_setImage(with: URL(string: A.image))
        ADD_SPACER(to: vStack, height: 8)
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = MERRIWEATHER_BOLD(14)
        subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.text = A.title
        vStack.addArrangedSubview(subTitleLabel)
        ADD_SPACER(to: vStack, height: 8)
        
        let HStack_source = HSTACK(into: vStack)
        HStack_source.activateConstraints([
            HStack_source.heightAnchor.constraint(equalToConstant: 28)
        ])
        if(!A.media_country_code.isEmpty) {
            let VStack_flag = VSTACK(into: HStack_source)
            //VStack_flag.backgroundColor = .green
            let flagImageView = UIImageView()
            
            if let _image = UIImage(named: A.media_country_code.uppercased() + "64.png") {
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
        
        var LR = 1
        var PE = 1
                    
        let sourceName = A.media_title.components(separatedBy: " #").first!
        self.getSourceIcon(name: sourceName) { (icon) in
            if let _icon = icon {
                let sourcesContainer = UIStackView()
                HStack_source.addArrangedSubview(sourcesContainer)
                ADD_SOURCE_ICONS(data: [_icon.identifier],
                    to: sourcesContainer, containerHeight: 28)
                    
                LR = _icon.LR
                PE = _icon.PE
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
        mainButton.tag = 300+i
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
        miniButton.tag = 400+i
        miniButton.addTarget(self, action: #selector(articleStanceIconOnTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: vStack, height: 20) // Space to next item
        return vStack
    }
    
    private func addSpins(_ spins: [Spin]) {
        self.spins = spins
        ADD_SPACER(to: self.VStack, height: 12)
    
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 12)
        let innerHStack = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 12)
        
       if(spins.count == 0) {
            let noSpinsLabel = UILabel()
            noSpinsLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ noSpinsLabel.font = MERRIWEATHER_BOLD(19) }
            noSpinsLabel.text = "No spin available"
            noSpinsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(noSpinsLabel)
        } else {
            let SpinsLabel = UILabel()
            SpinsLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ SpinsLabel.font = MERRIWEATHER_BOLD(19) }
            SpinsLabel.text = "Spin"
            SpinsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            innerHStack.addArrangedSubview(SpinsLabel)
            
            ADD_SPACER(to: innerHStack, height: 12)
            for (i, S) in spins.enumerated() {
                var _title = S.title
                if(_title.isEmpty) {
                    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    _title = "Narrative " + letters.getCharAt(index: i)!
                }
                
                let titleLabel = UILabel()
                titleLabel.font = MERRIWEATHER_BOLD(17)
                titleLabel.text = _title
                titleLabel.numberOfLines = 0
                titleLabel.textColor = UIColor(hex: 0xFF643C)
                innerHStack.addArrangedSubview(titleLabel)
                
                ADD_SPACER(to: innerHStack, height: 10)
                let descriptionLabel = UILabel()
                descriptionLabel.font = ROBOTO(14)
                descriptionLabel.numberOfLines = 0
                descriptionLabel.text = S.description
                descriptionLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
                innerHStack.addArrangedSubview(descriptionLabel)
                
                if(!S.image.isEmpty && !S.subTitle.isEmpty && !S.media_title.isEmpty) {
                    ADD_SPACER(to: innerHStack, height: 16)
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
                    imageView.sd_setImage(with: URL(string: S.image))
                    ADD_SPACER(to: VStack_image) // V fill

                    ADD_SPACER(to: HStack_image, width: 12)

                    let VStack_data = VSTACK(into: HStack_image)
                    //VStack_data.backgroundColor = .green
                    let subTitleLabel = UILabel()
                    subTitleLabel.font = MERRIWEATHER_BOLD(13)
                    subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
                    subTitleLabel.numberOfLines = 0
                    subTitleLabel.text = S.subTitle
                    VStack_data.addArrangedSubview(subTitleLabel)
                    ADD_SPACER(to: VStack_data, height: 8)
                    
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
                    sourceLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
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
                        timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
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
                        // Dashes
                        line.clipsToBounds = true
                        let dash_long: CGFloat = 5
                        let dash_sep: CGFloat = 2
                        var val_x: CGFloat = 0
                        let dash_color = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
                        
                        var maxDim = SCREEN_SIZE().width
                        if(SCREEN_SIZE().height > maxDim){ maxDim = SCREEN_SIZE().height }
                        
                        while(val_x < maxDim) {
                            let dash = UIView()
                            dash.backgroundColor = dash_color
                            line.addSubview(dash)
                            dash.frame = CGRect(x: val_x, y: 0, width: dash_long, height: 2.0)
                            
                            val_x += dash_long + dash_sep
                        }
                    
                    ADD_SPACER(to: innerHStack, height: 20) // Space to next item
                }
                
            }
        }
    }
    
    private func populateFacts() {
        let VStack = self.view.viewWithTag(140) as! UIStackView
        //VStack.backgroundColor = .systemPink
        REMOVE_ALL_SUBVIEWS(from: VStack)
        ADD_SPACER(to: VStack, height: 20)
        
        if(self.facts.count==0) {
            let noFactsLabel = UILabel()
            noFactsLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ noFactsLabel.font = MERRIWEATHER_BOLD(19) }
            noFactsLabel.text = "  No facts available"
            noFactsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(noFactsLabel)
        } else {
            let FactsLabel = UILabel()
            FactsLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ FactsLabel.font = MERRIWEATHER_BOLD(19) }
            FactsLabel.text = "  Facts"
            FactsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(FactsLabel)
            
            ADD_SPACER(to: VStack, height: 16)
            
            var lastSourceIndex = -1
            for (i, F) in self.facts.enumerated() {
                let HStack = HSTACK(into: VStack)
                //HStack.backgroundColor = .green
                
                ADD_SPACER(to: HStack, width: 20)

                let dot = UIView()
                dot.backgroundColor = UIColor(hex: 0xFF643C)
                HStack.addSubview(dot)
                dot.activateConstraints([
                    dot.widthAnchor.constraint(equalToConstant: 8),
                    dot.heightAnchor.constraint(equalToConstant: 8),
                    dot.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 4),
                    dot.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 5)
                ])

                let contentLabel = UILabel()
                contentLabel.numberOfLines = 0
                contentLabel.font = MERRIWEATHER(12)
                //contentLabel.text = F.title
                contentLabel.attributedText = self.attrText(F.title, index: F.sourceIndex+1)
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
                
                ADD_SPACER(to: VStack, height: 15) // separation from next item
                
                if(self.show3 && i==2) {
                    lastSourceIndex =  F.sourceIndex
                    break
                }
            }
            
            ADD_SPACER(to: VStack, height: 20)
            //////////////////////////////////////
            let showMoreLabel = UILabel()
            showMoreLabel.textColor = UIColor(hex: 0xFF643C)
            showMoreLabel.textAlignment = .center
            showMoreLabel.font = ROBOTO(15)
            showMoreLabel.text = self.show3 ? "Show more" : "Show fewer facts"
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
            ADD_SPACER(to: VStack, height: 30)
            let line = UIView()
            line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
            VStack.addArrangedSubview(line)
            line.activateConstraints([
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_SPACER(to: VStack, height: 20)
            //////////////////////////////////////
            let SourcesLabel = UILabel()
            SourcesLabel.font = MERRIWEATHER_BOLD(17)
            if(IPAD()){ SourcesLabel.font = MERRIWEATHER_BOLD(19) }
            SourcesLabel.text = "  Sources"
            SourcesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(SourcesLabel)
            ADD_SPACER(to: VStack, height: 15)
            
            let HStack_sources = HSTACK(into: VStack)
            //HStack_sources.backgroundColor = .green
            ADD_SPACER(to: HStack_sources, width: 8)
            
            let VStack_sources = VSTACK(into: HStack_sources)
            VStack_sources.spacing = 10
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
                sourceLabel.font = ROBOTO(15)
                //sourceLabel.backgroundColor = .blue
                sourceLabel.textColor = UIColor(hex: 0xFF643C)
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
                if(self.show3 && i==lastSourceIndex){ isLast = true }
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

            ADD_SPACER(to: VStack, height: 15)
        }
        
        ADD_SPACER(to: VStack, height: 15)
        //print("--------------------")
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
        ADD_SPACER(to: HStack, width: 12)
        let VStack_borders = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 12)
        VStack_borders.layer.borderWidth = 8.0
        VStack_borders.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x1D2530).cgColor : UIColor(hex: 0xE1E3E3).cgColor

        let innerHStack = HSTACK(into: VStack_borders)
        //innerHStack.backgroundColor = .blue
        ADD_SPACER(to: innerHStack, width: 13)
        let innerVStack = VSTACK(into: innerHStack)
        innerVStack.tag = 140
        ADD_SPACER(to: innerHStack, width: 13)
    }
    
    private func addTime(time: String) {
        let updatedLabel = UILabel()
        updatedLabel.font = ROBOTO(14)
        updatedLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        updatedLabel.text = "Updated " + time
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(updatedLabel)
        ADD_SPACER(to: HStack, width: 13)
    }

    private func addImage(imageUrl: String) {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        
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
                    let W: CGFloat = SCREEN_SIZE().width - 26
                    var H = (_img.size.height * W)/_img.size.width
                    if(H>450){ H = 450 }
                    
                    self.imageHeightConstraint?.constant = H
                }
            }
        } else {
            self.VStack.addArrangedSubview(imageView)
            self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
            self.imageHeightConstraint?.isActive = true
            
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .retryFailed) { (img, error, cacheType, url) in
                if let _img = img {
                    let W: CGFloat = SCREEN_SIZE().width
                    let H = (_img.size.height * W)/_img.size.width
                    self.imageHeightConstraint?.constant = H
                } else if(error != nil) {
                    imageView.image = nil
                }
            }
        }
        
        ADD_SPACER(to: self.VStack, height: 4)
    }

    private func addTitle(text: String) {
        let titleLabel = UILabel()
        titleLabel.font = MERRIWEATHER_BOLD(19)
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(titleLabel)
        ADD_SPACER(to: HStack, width: 13)
        
        ADD_SPACER(to: self.VStack, height: 1)
    }

    private func addPill() {
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 10)
        
        let storyPillLabel = UILabel()
        storyPillLabel.backgroundColor = UIColor(hex: 0xFF643C)
        storyPillLabel.textColor = .white
        storyPillLabel.text = "STORY"
        storyPillLabel.textAlignment = .center
        storyPillLabel.font = ROBOTO_BOLD(11)
        storyPillLabel.layer.masksToBounds = true
        storyPillLabel.layer.cornerRadius = 12
        storyPillLabel.addCharacterSpacing(kernValue: 1.0)
        HStack.addArrangedSubview(storyPillLabel)
        storyPillLabel.activateConstraints([
            storyPillLabel.widthAnchor.constraint(equalToConstant: 65),
            storyPillLabel.heightAnchor.constraint(equalToConstant: 23)
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
        let font = UIFont(name: "Merriweather", size: 13)
        let fontItalic = UIFont(name: "Merriweather-Italic", size: 13)
        //let fontItalic = UIFont(name: "Merriweather-LightItalic", size: 14)
        let extraText = "[" + String(index) + "]"
        let mText = text + " " + extraText
        
        let attr = prettifyText(fullString: mText as NSString, boldPartsOfString: [],
            font: font, boldFont: font, paths: [], linkedSubstrings: [], accented: [])
        
        let mAttr = NSMutableAttributedString(attributedString: attr)
        
        var range = NSRange(location: 0, length: attr.string.count)
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F),
            range: range)
        
        range = NSRange(location: attr.string.count - extraText.count, length: extraText.count)
        
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: UIColor(hex: 0xFF643C),
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
}
