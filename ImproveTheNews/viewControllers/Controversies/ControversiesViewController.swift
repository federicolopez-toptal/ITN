//
//
//  ControversiesViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import UIKit
import WebKit
import SDWebImage


class ControversiesViewController: BaseViewController {

    static var topic = ""

    let M: CGFloat = CSS.shared.iPhoneSide_padding
    var GRAPH_WIDTH: CGFloat = 320
    let GRAPH_HEIGHT: CGFloat = 400
    let GRAPH_URL = "/election-results?theme="
    
    var iPad_W: CGFloat = -1
    
    var page: Int = 0
    
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!
    
    var portalInfoView = UIStackView()
    var portalInfoViewHeightConstraint: NSLayoutConstraint? = nil
    
    var items: [ControversyListItem] = []
    var containerViewHeightConstraint: NSLayoutConstraint?
    var showMoreViewHeightConstraint: NSLayoutConstraint?
    var tmpContainer2HeightConstraint: NSLayoutConstraint?
    
    var currentTopic = -1
    var currentSubTopic = -1
    var topics = [SimpleTopic]()
    var subtopics = [SimpleTopic]()
    let topicsContainer = UIView()
    let subtopicsContainer = UIView()
    var storiesContainer = UIStackView()
    var storiesShowMore = UIView()
    
    var loadsCount = 0
    
    var twitterText: String = ""
    var twitterUrl: String = ""
    var figureSlugs: [String] = []
    
    var isSubTopic: Bool = false
    
    var stories: [StorySearchResult] = []
    var storiesTotal: Int = 0
    var storiesPage: Int = 1
        
    var candidates: [FigureForPortalGraph] = []
    var graphHeight: CGFloat = 360
    var mediaItems: [MediaItemForElectionResult] = []
    var mediaItemsHeight: CGFloat = 0
    var yetToCallWinnerHeight: CGFloat = 0
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(IPAD()) {
            self.GRAPH_WIDTH = 400
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            //self.navBar.addComponents([.back, .title])
            
            if(IPHONE()) {
                self.navBar.addComponents([.menuIcon, .title, .share])
            } else {
                self.navBar.addComponents([.menuIcon, .title, .share, .question])
            }
            
            self.navBar.setTitle("Controversies")
            self.navBar.addInfoButton()
            self.navBar.addBottomLine()
            
            self.navBar.onInfoButtonTap {
                let popup = StoryInfoPopupView(title: "Controversies",
                    description: """
                    Our Controversies compare the claims made by key public figures on a wide range of issues in today’s media.
                    """,
                    linkedTexts: [], links: [],
                    height: 160)
                    
                popup.pushFromBottom()
            }
            
            // ------------------------------
            self.navBar.onQuestionButtonTap {
                let vc = FAQViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                let _topic = self.topics[self.currentTopic]
                if(_topic.slug == "us-election-2024") {
                    DELAY(0.4) {
                        vc.scrollToEstablishmentBias()
                    }
                } else {
                    DELAY(0.4) {
                        vc.scrollToControversies()
                    }
                }
            }
            
            // -----------------------------
            //self.navBar.setShareUrl(ITN_URL() + "/controversies", vc: self)
            
//            self.navBar.onShareButtonTap {
//                let popup = SharePopupView(text: "Share Controversies",
//                    height: 200,
//                    url: ITN_URL() + "/controversies",
//                    shareText: "Controversies")
//                popup.pushFromBottom()
//            }
            

            self.buildContent()
        }
    }
        
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        //self.scrollView.backgroundColor = .systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        //self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0 ),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        var extraOffset: CGFloat = 0
        if(IPAD()) { extraOffset = 30 }
        
        self.vStack = VSTACK(into: self.contentView)
        //self.vStack.backgroundColor = .yellow
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: IPHONE() ? -16 : 0),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: extraOffset),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
            
        // -------------------------------------- //
        // Container / Structure
        ADD_SPACER(to: self.vStack, height: 16)
        
        let tmpContainer = UIView()
        tmpContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.vStack.addArrangedSubview(tmpContainer)
        tmpContainer.activateConstraints([
            tmpContainer.heightAnchor.constraint(equalToConstant: 40+16)
        ])
        
        //ADD_SPACER(to: self.vStack, height: 16)
        let extraWidth: CGFloat = IPHONE() ? 32 : 0
        
        tmpContainer.addSubview(self.topicsContainer)
        self.topicsContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.topicsContainer.activateConstraints([
            self.topicsContainer.topAnchor.constraint(equalTo: tmpContainer.topAnchor),
            self.topicsContainer.heightAnchor.constraint(equalToConstant: 40+16),
            
        ])
    
        if(IPHONE()) {
            self.topicsContainer.widthAnchor.constraint(equalToConstant: self.W()+extraWidth-16-32-16).isActive = true
            self.topicsContainer.leadingAnchor.constraint(equalTo: tmpContainer.leadingAnchor).isActive = true
            
            // QUESTION
            let questionImageView = UIImageView(image: UIImage(named: DisplayMode.imageName("question")))
            tmpContainer.addSubview(questionImageView)
            questionImageView.activateConstraints([
                questionImageView.widthAnchor.constraint(equalToConstant: 32),
                questionImageView.heightAnchor.constraint(equalToConstant: 32),
                questionImageView.topAnchor.constraint(equalTo: tmpContainer.topAnchor, constant: 4),
                questionImageView.trailingAnchor.constraint(equalTo: tmpContainer.trailingAnchor, constant: -16)
            ])
            
            let questionButton = UIButton(type: .custom)
            questionButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            tmpContainer.addSubview(questionButton)
            questionButton.activateConstraints([
                questionButton.leadingAnchor.constraint(equalTo: questionImageView.leadingAnchor),
                questionButton.trailingAnchor.constraint(equalTo: questionImageView.trailingAnchor),
                questionButton.topAnchor.constraint(equalTo: questionImageView.topAnchor),
                questionButton.bottomAnchor.constraint(equalTo: questionImageView.bottomAnchor)
            ])
            questionButton.addTarget(self, action: #selector(questionButtonOnTap(_:)), for: .touchUpInside)
        } else {
            self.topicsContainer.widthAnchor.constraint(equalToConstant: self.W()+extraWidth).isActive = true
            self.topicsContainer.centerXAnchor.constraint(equalTo: tmpContainer.centerXAnchor).isActive = true
        }
    
        self.portalInfoView = VSTACK(into: self.vStack)
        self.portalInfoView.backgroundColor = .clear //.orange
        self.portalInfoViewHeightConstraint = self.portalInfoView.heightAnchor.constraint(equalToConstant: 50)
        self.portalInfoViewHeightConstraint?.isActive = true
        self.portalInfoView.hide()
        
        
        let tmpContainer2 = UIView()
        tmpContainer2.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.vStack.addArrangedSubview(tmpContainer2)
        self.tmpContainer2HeightConstraint = tmpContainer2.heightAnchor.constraint(equalToConstant: 0)
        self.tmpContainer2HeightConstraint?.isActive = true
        
        tmpContainer2.addSubview(self.subtopicsContainer)
        self.subtopicsContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.subtopicsContainer.activateConstraints([
            self.subtopicsContainer.topAnchor.constraint(equalTo: tmpContainer2.topAnchor),
            self.subtopicsContainer.heightAnchor.constraint(equalToConstant: IPHONE() ? 93 : 108),
            self.subtopicsContainer.widthAnchor.constraint(equalToConstant: self.W()+extraWidth),
            self.subtopicsContainer.centerXAnchor.constraint(equalTo: tmpContainer2.centerXAnchor)
        ])
        
        let mainView = self.createContainerView()
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .orange
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)            
        ])
        containerView.tag = 555
        
        self.containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 200)
        self.containerViewHeightConstraint!.isActive = true
        
        // More
        let moreView = UIView()
        mainView.addSubview(moreView)
        moreView.backgroundColor = CSS.shared.displayMode().main_bgColor
        moreView.activateConstraints([
            moreView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            moreView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            moreView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        moreView.tag = 556
        self.showMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
        self.showMoreViewHeightConstraint?.isActive = true
        
        if(IPHONE()) {
            let line = UIView()
            line.tag = 444
            line.backgroundColor = .green
            moreView.addSubview(line)
            line.activateConstraints([
                line.leadingAnchor.constraint(equalTo: moreView.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: moreView.trailingAnchor),
                line.topAnchor.constraint(equalTo: moreView.topAnchor),
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_HDASHES(to: line)
        }
        
        let button = UIButton(type: .custom)
        moreView.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
        ])
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        button.titleLabel?.font = AILERON(15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
        button.addTarget(self, action: #selector(loadMoreOnTap(_:)), for: .touchUpInside)
        
        self.showMoreButton(false)
        mainView.bottomAnchor.constraint(equalTo: moreView.bottomAnchor, constant: M).isActive = true
        
        // --------------------------------------
        if(IPHONE()) {
            self.storiesContainer = VSTACK(into: self.vStack)
            self.storiesContainer.backgroundColor = .clear
            self.storiesContainer.activateConstraints([
                self.storiesContainer.leadingAnchor.constraint(equalTo: self.vStack.leadingAnchor, constant: 16),
                self.storiesContainer.trailingAnchor.constraint(equalTo: self.vStack.trailingAnchor, constant: -16),
            ])
        } else {
            let hstack = HSTACK(into: self.vStack)
            hstack.backgroundColor = .clear
        
            let W: CGFloat = self.W()
        
            ADD_SPACER(to: hstack)
            self.storiesContainer = VSTACK(into: hstack)
            self.storiesContainer.backgroundColor = .clear
            self.storiesContainer.activateConstraints([
                self.storiesContainer.widthAnchor.constraint(equalToConstant: W),
                self.storiesContainer.centerXAnchor.constraint(equalTo: hstack.centerXAnchor)
            ])
            ADD_SPACER(to: hstack)
        }

        self.storiesContainer.hide()
        // --------------------------------------
        self.refreshDisplayMode_local()
    }
    @objc func questionButtonOnTap(_ sender: UIButton?) {
        let vc = FAQViewController()
        CustomNavController.shared.pushViewController(vc, animated: true)
        
        let _topic = self.topics[self.currentTopic]
        if(_topic.slug == "us-election-2024") {
            DELAY(0.4) {
                vc.scrollToEstablishmentBias()
            }
        } else {
            DELAY(0.4) {
                vc.scrollToControversies()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            self.page = 1
            self.items = []
            
            self.loadsCount = 0
            self.isSubTopic = false
            self.loadContent(page: self.page)
        }
    }
    
    func refreshDisplayMode_local() {
        self.navBar.refreshDisplayMode()
        
        let C = CSS.shared.displayMode().main_bgColor
        
        self.view.backgroundColor = C
        self.scrollView.backgroundColor = C
        self.contentView.backgroundColor = C
        self.vStack.backgroundColor = C
    }
    
    override func refreshDisplayMode() {
        self.refreshDisplayMode_local()
        
        let containerView = self.view.viewWithTag(555)!
        REMOVE_ALL_SUBVIEWS(from: containerView)
        
        let moreView = self.view.viewWithTag(556)!
        moreView.backgroundColor = self.view.backgroundColor
        moreView.hide()
        
        self.storiesShowMore.backgroundColor = CSS.shared.displayMode().main_bgColor
        if let _moreButton = self.storiesShowMore.subviews.first as? UIButton {
            _moreButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
            _moreButton.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        }
        
        for sView in moreView.subviews {
            if(sView.tag == 444) {
                ADD_HDASHES(to: sView)
            } else {
                if let _button = sView as? UIButton {
                    _button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
                    _button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
                }
            }
        }
        
        self.refreshDisplayModeForTopics()
        
        self.page = 1
        self.items = []
        self.loadsCount = 0
        
        self.loadContent(page: self.page) //
        
        
//        self.scrollView.backgroundColor = .systemPink
//        self.contentView.backgroundColor = .yellow

//        self.vStack.backgroundColor = .green
        //self.topicsContainer.backgroundColor = .orange
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.page += 1
        self.storiesPage = self.page
        self.loadsCount = 0
        
        self.loadContent(page: self.page) //
    }
    
}

// MARK: misc
extension ControversiesViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: Data
extension ControversiesViewController {
    
    private func loadContent(page P: Int) {
        if(self.topics.count==0) {
            self.topicsContainer.hide()
        }
        
        if(!self.isSubTopic) {
            self.portalInfoView.hide()
            self.subtopicsContainer.hide()
            self.tmpContainer2HeightConstraint?.constant = 0
        }
        
        //if(self.storiesContainer.subviews.count == 0) {
            self.storiesContainer.hide()
        //}
        
        self.showMoreButton(false)
        
        var T = ""
        if(!ControversiesViewController.topic.isEmpty) {
            T = ControversiesViewController.topic
        } else {
            if(!self.isSubTopic) {
                if(self.topics.count>0 && self.currentTopic != -1) {
                    T = self.topics[self.currentTopic].slug
                    if(T == "all"){ T = "" }
                }
            } else {
                if(self.subtopics.count>0 && self.currentSubTopic != -1) {
                    T = self.subtopics[self.currentSubTopic].slug
                    if(T == "all"){
                         //T = ""
                         if(self.topics.count>0 && self.currentTopic != -1) {
                            T = self.topics[self.currentTopic].slug
                            if(T == "all"){ T = "" }
                        }
                    }
                }
            }
        }
        
        self.showLoading()
        self.loadsCount += 1
            
        if(T == "us-election-2024") {
            self.navBar.setShareUrl(ITN_URL() + "/controversies/us-election-2024", vc: self)
        } else {
            self.navBar.setShareUrl(ITN_URL() + "/controversies", vc: self)
        }
                            
        print("LOAD CONTROVERSY \(self.loadsCount)")
        ControversiesData.shared.loadList(topic: T, page: P) { (error, total, list, topics, subtopics, controData, storiesCount, stories) in

            self.hideLoading()
            if let _ = error {
                if(self.loadsCount >= 3) {
                    ALERT(vc: self, title: "Server error",
                        message: "Trouble loading Controversies,\nplease try again later.", onCompletion: {
                            CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    print("Loading again...")
                    DELAY(0.5) {
                        self.loadContent(page: self.page) //
                    }
                }
            } else {
                MAIN_THREAD {
                    if let _n = total, let _L = list, let _T = topics {
                        self.fillContent(total: _n, items: _L, topics: _T, subtopics: subtopics,
                            controData: controData, storiesTotal: storiesCount, stories: stories)
                    }
                }
            }
        }
                
    }
    
    func fillContent(total: Int, items: [ControversyListItem], topics: [SimpleTopic],
        subtopics: [SimpleTopic]?, controData: ControversyPortalData?, storiesTotal: Int?, stories: [StorySearchResult]?) {
    
        var subTitle = "Controversies"
        let containerView = self.view.viewWithTag(555)!
        
        if(!self.isSubTopic) {
            if(self.topics.count==0) {
                self.addTopics(topics)
            }
        }
        
        if(!ControversiesViewController.topic.isEmpty) {
            for (i, _T) in self.topics.enumerated() {
//                print(_T.name, ControversiesViewController.topic)
                if(_T.slug == ControversiesViewController.topic) {
                    self.currentTopic = i
                    self.selectTopic_iPhone(index: i, mustLoad: false)
                    ControversiesViewController.topic = ""
                    break
                }
            }
        }
            
    let topicName = self.topics[self.currentTopic].name
    if(topicName.lowercased() == "all") {
        self.navBar.setTitle("Controversies")
    } else {
        self.navBar.setTitle(topicName)
    }
            
        /* Portal stuff */
    if(!self.isSubTopic) {
        REMOVE_ALL_SUBVIEWS(from: self.portalInfoView)
        if let _controData = controData {
            let _W: CGFloat = IPHONE() ? (SCREEN_SIZE().width-32) : self.W()
            
            var _slug = ""
            if(self.topics.count>0 && self.currentTopic != -1) {
                _slug = self.topics[self.currentTopic].slug
            }
            self.twitterText = "Where do you stand on this: " + _controData.title
            self.twitterUrl = ITN_URL() + "/controversies/" + _slug

            let portalView = UIView()
            portalView.backgroundColor = .clear
            portalView.activateConstraints([
                portalView.widthAnchor.constraint(equalToConstant: _W)
            ])
            
            //self.navBar.setTitle(_controData.title)
            
//            let titleLabel = UILabel()
//            titleLabel.numberOfLines = 0
//            titleLabel.font = DM_SERIF_DISPLAY_resize(22)
//            titleLabel.textColor = CSS.shared.displayMode().main_textColor
//            titleLabel.text = _controData.title
            
            let descrLabel = UILabel()
            descrLabel.numberOfLines = 0
            descrLabel.font = AILERON(14)
            descrLabel.textColor = CSS.shared.displayMode().sec_textColor
            descrLabel.text = _controData.description
            descrLabel.setLineSpacing(lineSpacing: 6.0)
            
            subTitle = _controData.subTitle
            
            var graphView: UIView = UIView()
            if let _graphData = _controData.graph {
                graphView = self.createGraphView(data: _graphData)
            }
            
            if(IPHONE()) {
                let innerVStack = VSTACK(into: portalView)
                innerVStack.backgroundColor = .clear
                innerVStack.activateConstraints([
                    innerVStack.topAnchor.constraint(equalTo: portalView.topAnchor, constant: 12),
                    innerVStack.leadingAnchor.constraint(equalTo: portalView.leadingAnchor),
                    innerVStack.trailingAnchor.constraint(equalTo: portalView.trailingAnchor)
                ])
                
//                innerVStack.addArrangedSubview(titleLabel)
//                ADD_SPACER(to: innerVStack, height: 8)
                innerVStack.addArrangedSubview(descrLabel)
                ADD_SPACER(to: innerVStack, height: 24)
                self.createTwitterButton(into: innerVStack)
                ADD_SPACER(to: innerVStack, height: 24)
                
                let graphContainerView = UIView()
                graphContainerView.backgroundColor = .clear
                innerVStack.addArrangedSubview(graphContainerView)
                graphContainerView.activateConstraints([
                    graphContainerView.heightAnchor.constraint(equalToConstant: self.graphSize().height)
                ])
                
                graphContainerView.addSubview(graphView)
                graphView.activateConstraints([
                    graphView.centerXAnchor.constraint(equalTo: graphContainerView.centerXAnchor)
                ])

            } else {
                let innerHStack = HSTACK(into: portalView)
                innerHStack.backgroundColor = .clear
                innerHStack.activateConstraints([
                    innerHStack.topAnchor.constraint(equalTo: portalView.topAnchor, constant: 12),
                    innerHStack.leadingAnchor.constraint(equalTo: portalView.leadingAnchor),
                    innerHStack.trailingAnchor.constraint(equalTo: portalView.trailingAnchor)
                ])
                
                let innerVStack = VSTACK(into: innerHStack)
                innerVStack.backgroundColor = .clear
//                innerVStack.addArrangedSubview(titleLabel)
//                ADD_SPACER(to: innerVStack, height: 8)
                innerVStack.addArrangedSubview(descrLabel)
                ADD_SPACER(to: innerVStack)
                
                ADD_SPACER(to: innerHStack, width: 16)
                innerHStack.addArrangedSubview(graphView)
            }
            
            // --------
            var H: CGFloat = 0
            
            if(IPHONE()) {
                H = 12 + //titleLabel.calculateHeightFor(width: _W) + 8 +
                descrLabel.calculateHeightFor(width: _W) + 24 +
                40 + 24 + self.graphSize().height
            } else {
                let _w: CGFloat = self.W() - 16 - self.GRAPH_WIDTH
                
                let _h = 12 + //titleLabel.calculateHeightFor(width: _w) + 8 +
                descrLabel.calculateHeightFor(width: _w)
                
                if(_h > (self.graphSize().height+12)) {
                    H = _h
                } else {
                    H = (self.graphSize().height+12)
                }
                H += 16
            }
            H += 16

            self.portalInfoView.addSubview(portalView)
            portalView.activateConstraints([
                portalView.heightAnchor.constraint(equalToConstant: H),
                portalView.centerXAnchor.constraint(equalTo: self.portalInfoView.centerXAnchor)
            ])
            self.portalInfoViewHeightConstraint?.constant = H
            self.portalInfoView.show()
            /* Portal stuff */
        } else {
            self.portalInfoView.hide()
        }
    
        // Subcategories
        if let _subtopics = subtopics, _subtopics.count>0, !self.isSubTopic {
            self.addSubTopics(_subtopics, title: subTitle)
        } else {
            self.subtopicsContainer.hide()
            self.tmpContainer2HeightConstraint?.constant = 0
        }
    }
    
        let _items = items
//        for _ in 1...1 {
//            _items.remove(at: _items.count-1)
//        }
        
        for CO in _items {
            self.items.append(CO)
        }
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        var col1: CGFloat = 0
        var col2: CGFloat = 0
        
        var index: Int = 0
        if(containerView.subviews.count > 0) {
            for V in containerView.subviews {
                if let _subView = V as? ControversyCellView {
                    if(IPHONE()) {
                        val_y += _subView.calculateHeight()
                        index += 1
                    } else {
                        if(col == 0) {
                            col1 += _subView.calculateHeight()
                        } else {
                            col2 += _subView.calculateHeight()
                        }
                        index += 1
                    
                        col += 1
                        if(col == 2) {
                            col = 0
                        }
                    }
                }
            }
            
            if(IPAD()) {
                val_y = (col1 > col2) ? col1 : col2
            }
        }
        
        
        for (_, CO) in _items.enumerated() {
            let controView = ControversyCellView(width: item_W)
            controView.buttonArea.hide()
            controView.tag = 600 + index
            if(containerView.subviews.count==0 && index==0 && IPHONE()){ controView.hideTopLine() }
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ControversyCellView? = nil
            if(index>0) {
                if(IPHONE()) {
                    prev = (containerView.subviews.last as! ControversyCellView)
                } else { // IPAD
                    if(index==1) {
                        prev = (containerView.subviews.first as! ControversyCellView)
                    } else {
                        prev = (containerView.subviews[index-2] as! ControversyCellView)
                    }
                }
            }
            
            containerView.addSubview(controView)
            controView.activateConstraints([
                controView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                controView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(index==0) {
                controView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(index==1) { // col2
                        let first = containerView.subviews.first as! ControversyCellView
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
            
            if(index==self.items.count-1 && IPAD() && col==1) {
                val_y += controView.calculateHeight()
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controversyOnTap(_:)))
            controView.addGestureRecognizer(tapGesture)
            
            index += 1
        }
        
        if(IPAD()) {
            val_y = (col1 > col2) ? col1 : col2
        }
        
        
        // Show more --------------
        if(self.items.count < total) {
            self.showMoreButton(true)
        } else {
            self.showMoreButton(false)
        }

//        // stories
//        self.stories = []
//        self.storiesTotal = 0
//        self.storiesPage = 1
//        REMOVE_ALL_SUBVIEWS(from: self.storiesContainer)
//        self.storiesContainer.hide()
        
        var storiesToAdd: [StorySearchResult] = []
        if let _stories = stories {
            storiesToAdd = _stories
        }
        if let _storiesTotal = storiesTotal {
            self.storiesTotal = _storiesTotal
        }
        self.updateStories(adding: storiesToAdd)
        
        // Finally
        self.containerViewHeightConstraint?.constant = val_y
        self.topicsContainer.show()
    }
    @objc func controversyOnTap(_ gesture: UITapGestureRecognizer) {
        if let _view = gesture.view as? ControversyCellView {
            let index = _view.tag - 600
            
            let vc = ControDetailViewController()
            vc.slug = self.items[index].slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    
}


// MARK: - Extras
extension ControversiesViewController {

    func createContainerView(bgColor: UIColor = .clear, height: CGFloat? = nil) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = bgColor
        self.vStack.addArrangedSubview(containerView)
        
        if let _H = height {
            containerView.heightAnchor.constraint(equalToConstant: _H).isActive = true
        }
        
        return containerView
    }
    
    func W() -> CGFloat {
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
    
    func showMoreButton(_ visible: Bool) {
        if let moreView = self.view.viewWithTag(556) {
            if(visible) {
                self.showMoreViewHeightConstraint?.constant = 88
                moreView.show()
            } else {
                self.showMoreViewHeightConstraint?.constant = 0
                moreView.hide()
            }
        }
    }
    
}


extension ControversiesViewController {
    
    func addTopics(_ topics: [SimpleTopic]) {
        self.topics = topics
        
        let H: CGFloat = 40.0
        REMOVE_ALL_SUBVIEWS(from: self.topicsContainer)

        var _m: CGFloat = 0
        if(IPAD()) {
            _m = (SCREEN_SIZE_iPadSideTab().width - W())/2
        }
        
        let innerScrollView = UIScrollView()
        innerScrollView.showsHorizontalScrollIndicator = false
        innerScrollView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.topicsContainer.addSubview(innerScrollView)
        innerScrollView.activateConstraints([
            innerScrollView.leadingAnchor.constraint(equalTo: self.topicsContainer.leadingAnchor, constant: 0),
            innerScrollView.trailingAnchor.constraint(equalTo: self.topicsContainer.trailingAnchor, constant: 0),
            innerScrollView.topAnchor.constraint(equalTo: self.topicsContainer.topAnchor),
            innerScrollView.bottomAnchor.constraint(equalTo: self.topicsContainer.bottomAnchor)
        ])
        
        let innerContentView = UIView()
        innerContentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        innerScrollView.addSubview(innerContentView)
        innerContentView.activateConstraints([
            innerContentView.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor),
            innerContentView.topAnchor.constraint(equalTo: innerScrollView.topAnchor),
            innerContentView.heightAnchor.constraint(equalToConstant: H)
            //,innerContentView.widthAnchor.constraint(equalToConstant: 500)
        ])
        innerContentView.tag = 333
    
        let SEP: CGFloat = 8.0
        var val_x: CGFloat = IPHONE() ? M : 0
        for (i, T) in topics.enumerated() {
            let label = UILabel()
            label.font = AILERON(15)
            label.textColor = CSS.shared.displayMode().sec_textColor
            label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
            label.textAlignment = .center
            label.text = T.name
            label.layer.cornerRadius = 20
            label.layer.borderWidth = 1.0
            label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
            label.clipsToBounds = true
            
            let _W = label.calculateWidthFor(height: H) + 42
            
            innerContentView.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: innerContentView.topAnchor),
                label.widthAnchor.constraint(equalToConstant: _W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 400 + i
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            innerContentView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(topicButton_iPhoneOnTap(_:)), for: .touchUpInside)
            
            val_x += SEP + _W
        }

//        if(IPHONE()) {
//            val_x += M
//        }

        innerContentView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
        innerScrollView.contentSize = CGSize(width: val_x, height: H)
        
        ADD_SPACER(to: self.vStack, height: M*2)
        self.selectTopic_iPhone(index: 0, mustLoad: false)
    }
    @objc func topicButton_iPhoneOnTap(_ sender: UIButton) {
        let i = sender.tag - 400
        self.selectTopic_iPhone(index: i)
    }
    
    func selectTopic_iPhone(index: Int, mustLoad: Bool = true) {
        self.currentTopic = index
        
        if let containerView = self.view.viewWithTag(333) {
            var i = -1
            for V in containerView.subviews {
                if let label = V as? UILabel {
                    i += 1
                    if(i == index) {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                        label.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                        label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor 
                    }
                }
            }
        }
        
        if(mustLoad) {
            //self.topics = []
            let containerView = self.view.viewWithTag(555)!
            REMOVE_ALL_SUBVIEWS(from: containerView)
            
            self.page = 1
            self.items = []
            self.loadsCount = 0
            self.isSubTopic = false
            
            // stories
            self.stories = []
            self.storiesTotal = 0
            self.storiesPage = 1
            REMOVE_ALL_SUBVIEWS(from: self.storiesContainer)
            self.storiesContainer.hide()
            
            self.loadContent(page: self.page)
        }
    }
    
    func refreshDisplayModeForTopics() {
        let C = CSS.shared.displayMode().main_bgColor
        
        self.topicsContainer.superview!.backgroundColor = C
        self.topicsContainer.backgroundColor = C
        let scrollview = self.topicsContainer.subviews.first!
        scrollview.backgroundColor = C
        let contentView = scrollview.subviews.first!
        contentView.backgroundColor = C
        
        var count = 0
        for _v in contentView.subviews {
            if let _label = _v as? UILabel {
                _label.textColor = CSS.shared.displayMode().sec_textColor
                if(count == self.currentTopic) {
                    _label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                    _label.layer.borderColor = UIColor.clear.cgColor
                } else {
                    _label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                    _label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
                }
                
                count += 1
            }
        }
    }
    
}

extension ControversiesViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        CustomNavController.shared.tour.rotate()
    }

}

extension ControversiesViewController {
    
    func createTwitterButton(into containerView: UIStackView) {
        
        let resultView = HSTACK(into: containerView)
        let resultButton = UIButton(type: .custom)
        resultButton.backgroundColor = CSS.shared.cyan
        resultView.addArrangedSubview(resultButton)
        resultButton.activateConstraints([
            resultButton.widthAnchor.constraint(equalToConstant: 138),
            resultButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        resultButton.titleLabel?.font = AILERON(16)
        resultButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        resultButton.setTitle("Share on       ", for: .normal)
        resultButton.layer.cornerRadius = 8
        resultButton.addTarget(self, action: #selector(self.twitterButtonOnTap(_:)), for: .touchUpInside)
        
        let logoImageView = UIImageView(image: UIImage(named: "twitter_X_logo"))
        resultButton.addSubview(logoImageView)
        logoImageView.activateConstraints([
            logoImageView.widthAnchor.constraint(equalToConstant: 15),
            logoImageView.heightAnchor.constraint(equalToConstant: 15),
            logoImageView.centerYAnchor.constraint(equalTo: resultButton.centerYAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: resultButton.trailingAnchor, constant: -20)
        ])
        
        ADD_SPACER(to: resultView)
    }
    
    func graphSize() -> CGSize {
//        var _W: CGFloat = 360
//        if(IPHONE()) {
//            _W = SCREEN_SIZE().width - 16
//        } else {
//            _W = 400
//        }
//        
//        let _H: CGFloat = (_W * 450)/540
//        
//        return CGSize(width: _W, height: _H)

        return CGSize(width: 360, height: self.graphHeight)
    }
    
    func createGraphView(data: controversyPortalGraph) -> UIView {
        self.mediaItems = data.mediaItems
        self.mediaItemsHeight = 0
        
        self.candidates = []
        if let _data = data.figures.first(where: { $0.id == 3 }) { // Trump (id: 3)
            self.candidates.append(_data)
        }
        if let _data = data.figures.first(where: { $0.id == 19 }) { // Kamala Harris (id: 19)
            self.candidates.append(_data)
        }
        
        // -----------------------------------------
        let resultView = UIView()
        resultView.backgroundColor = .clear //.systemPink
        
        let _W: CGFloat = 360
                
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: _W)
        ])
        
        for i in 1...2 {
            let sideView = UIView()
            sideView.backgroundColor = .clear
            resultView.addSubview(sideView)
            sideView.activateConstraints([
                sideView.topAnchor.constraint(equalTo: resultView.topAnchor),
                sideView.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
                sideView.widthAnchor.constraint(equalToConstant: _W/2)
            ])
            
            let candidateView = candidateView(dataIndex: i-1)
            sideView.addSubview(candidateView)
            candidateView.activateConstraints([
                candidateView.centerXAnchor.constraint(equalTo: sideView.centerXAnchor),
                candidateView.topAnchor.constraint(equalTo: sideView.topAnchor)
            ])
            
            let mediaItemsView = mediaItemsView(forCandidateIndex: i-1)
            sideView.addSubview(mediaItemsView)
            mediaItemsView.activateConstraints([
                mediaItemsView.topAnchor.constraint(equalTo: candidateView.bottomAnchor, constant: 12),
                mediaItemsView.centerXAnchor.constraint(equalTo: sideView.centerXAnchor)
            ])
            
            if(i==1) {
                sideView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
            } else {
                sideView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor).isActive = true
            }
        }
        
        self.graphHeight += 12 + self.mediaItemsHeight + 20
        
        let vline = UIView()
        resultView.addSubview(vline)
        vline.activateConstraints([
            vline.widthAnchor.constraint(equalToConstant: 2),
            vline.topAnchor.constraint(equalTo: resultView.topAnchor),
            vline.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
            vline.bottomAnchor.constraint(equalTo: resultView.topAnchor, constant: self.graphHeight)
        ])
        ADD_VDASHES(to: vline)
        
        let hline = UIView()
        resultView.addSubview(hline)
        hline.activateConstraints([
            hline.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            hline.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            hline.heightAnchor.constraint(equalToConstant: 2),
            hline.bottomAnchor.constraint(equalTo: vline.bottomAnchor)
        ])
        ADD_HDASHES(to: hline)
        
        let yetToCallWinnerLabel = UILabel()
        yetToCallWinnerLabel.textAlignment = .center
        yetToCallWinnerLabel.font = AILERON(13)
        yetToCallWinnerLabel.textColor = CSS.shared.displayMode().main_textColor
        yetToCallWinnerLabel.text = "YET TO CALL WINNER"
        yetToCallWinnerLabel.backgroundColor = .clear
        resultView.addSubview(yetToCallWinnerLabel)
        yetToCallWinnerLabel.activateConstraints([
            yetToCallWinnerLabel.topAnchor.constraint(equalTo: hline.bottomAnchor, constant: 12),
            yetToCallWinnerLabel.centerXAnchor.constraint(equalTo: resultView.centerXAnchor)
        ])
        
        let yetToCallWinnerView = self.yetToCallWinnerView(width: _W)
        resultView.addSubview(yetToCallWinnerView)
        yetToCallWinnerView.activateConstraints([
            yetToCallWinnerView.topAnchor.constraint(equalTo: yetToCallWinnerLabel.bottomAnchor, constant: 12),
            yetToCallWinnerView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor)
        ])
        self.graphHeight += self.yetToCallWinnerHeight + 60
        
        resultView.heightAnchor.constraint(equalToConstant: self.graphHeight).isActive = true
        return resultView
    }
    
    
    func createGraphView_4(data: controversyPortalGraph) -> UIView { //!!!
        let size = graphSize()
        
        let imageview = UIImageView(image: UIImage(named: DisplayMode.imageName("US_election")))
        imageview.activateConstraints([
            imageview.widthAnchor.constraint(equalToConstant: size.width),
            imageview.heightAnchor.constraint(equalToConstant: size.height)
        ])
        
//        imageview.layer.borderColor = UIColor.red.cgColor
//        imageview.layer.borderWidth = 1.0
        
        return imageview
    }
    
    func createGraphView_3(data: controversyPortalGraph) -> UIView {
        let webView = WKWebView()
        webView.activateConstraints([
            webView.widthAnchor.constraint(equalToConstant: self.GRAPH_WIDTH),
            webView.heightAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT)
        ])
        
//        let domain = "https://improve-the-news-frontend.vercel.app"
        let domain = "https://www.improvemynews.com"
//        let domain = ITN_URL()
        
        let theme = DARK_MODE() ? "dark" : "light"
        let url = domain + self.GRAPH_URL + theme
        
        print("GRAPH", url)
        
        //webView.isUserInteractionEnabled = false
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
        
        webView.layer.borderColor = UIColor.red.cgColor
        webView.layer.borderWidth = 1.0
        
        return webView
    }
     
    func createGraphView_2(data: controversyPortalGraph) -> UIView { //!!!
        let resultView = UIView()
        resultView.backgroundColor = self.view.backgroundColor
        
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT),
            resultView.heightAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT)
        ])
        
        let vLine = UIView()
        vLine.backgroundColor = CSS.shared.displayMode().main_textColor
        resultView.addSubview(vLine)
        vLine.activateConstraints([
            vLine.widthAnchor.constraint(equalToConstant: 1),
            vLine.topAnchor.constraint(equalTo: resultView.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
            vLine.centerXAnchor.constraint(equalTo: resultView.centerXAnchor)
        ])
        ADD_VDASHES(to: vLine)
        
        let hLine = UIView()
        hLine.backgroundColor = .clear //CSS.shared.displayMode().main_textColor
        resultView.addSubview(hLine)
        hLine.activateConstraints([
            hLine.heightAnchor.constraint(equalToConstant: 1),
            hLine.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            hLine.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            hLine.centerYAnchor.constraint(equalTo: resultView.centerYAnchor)
        ])
        ADD_HDASHES(to: hLine)
        
        let bgColor = UIColor.clear
        
        let leftLabel = UILabel()
        resultView.addSubview(leftLabel)
        leftLabel.font = AILERON(12)
        leftLabel.backgroundColor = bgColor
        leftLabel.textColor = CSS.shared.displayMode().main_textColor
        leftLabel.activateConstraints([
            leftLabel.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            leftLabel.topAnchor.constraint(equalTo: hLine.bottomAnchor, constant: 6)
        ])
        leftLabel.text = data.left.uppercased()
        
        let rightLabel = UILabel()
        resultView.addSubview(rightLabel)
        rightLabel.font = AILERON(12)
        rightLabel.textAlignment = .right
        rightLabel.backgroundColor = bgColor
        rightLabel.textColor = CSS.shared.displayMode().main_textColor
        rightLabel.activateConstraints([
            rightLabel.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            rightLabel.topAnchor.constraint(equalTo: leftLabel.topAnchor)
        ])
        rightLabel.text = data.right.uppercased()
        
        let topLabel = UILabel()
        resultView.addSubview(topLabel)
        topLabel.font = AILERON(12)
        topLabel.backgroundColor = bgColor
        topLabel.textColor = CSS.shared.displayMode().main_textColor
        topLabel.activateConstraints([
            topLabel.leadingAnchor.constraint(equalTo: vLine.trailingAnchor, constant: 6),
            topLabel.topAnchor.constraint(equalTo: resultView.topAnchor)
        ])
        topLabel.text = data.top.uppercased()
        
        let bottomLabel = UILabel()
        resultView.addSubview(bottomLabel)
        bottomLabel.font = AILERON(12)
        bottomLabel.textAlignment = .right
        bottomLabel.backgroundColor = bgColor
        bottomLabel.textColor = CSS.shared.displayMode().main_textColor
        bottomLabel.activateConstraints([
            bottomLabel.trailingAnchor.constraint(equalTo: vLine.leadingAnchor, constant: -6),
            bottomLabel.bottomAnchor.constraint(equalTo: resultView.bottomAnchor)
        ])
        bottomLabel.text = data.bottom.uppercased()
        
        let minX: CGFloat = 0
        let maxX: CGFloat = self.GRAPH_HEIGHT-44
        let minY: CGFloat = 0
        let maxY: CGFloat = self.GRAPH_HEIGHT-44
        
        self.figureSlugs = []
        for (i, F) in data.figures.enumerated() {
            let val_x: CGFloat = INTERPOLATE(minA: 1.0, maxA: 10.0, value: F.hValue, minB: minX, maxB: maxX)
            let val_y: CGFloat = INTERPOLATE(minA: 1.0, maxA: 10.0, value: F.vValue, minB: minY, maxB: maxY)
            
            let figureImageView = UIImageView()
            figureImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
            resultView.addSubview(figureImageView)
            figureImageView.activateConstraints([
                figureImageView.widthAnchor.constraint(equalToConstant: 44),
                figureImageView.heightAnchor.constraint(equalToConstant: 44),
                figureImageView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: val_x),
                figureImageView.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -val_y)
            ])
            figureImageView.layer.cornerRadius = 22
            figureImageView.clipsToBounds = true
            figureImageView.layer.borderColor = CSS.shared.displayMode().main_bgColor.cgColor
            figureImageView.layer.borderWidth = 2.0
            figureImageView.sd_setImage(with: URL(string: F.image))
            
            var name = F.name.uppercased()
            if let lastName = name.components(separatedBy: " ").last {
                name = lastName
            }
            
            let nameLabel = UILabel()
            nameLabel.font = AILERON(9)
            nameLabel.textColor = CSS.shared.displayMode().sec_textColor
            nameLabel.text = name
            nameLabel.textAlignment = .center
            nameLabel.isUserInteractionEnabled = false
            nameLabel.backgroundColor = resultView.backgroundColor
            resultView.addSubview(nameLabel)
            nameLabel.lineBreakMode = .byTruncatingTail
            nameLabel.activateConstraints([
                nameLabel.leadingAnchor.constraint(equalTo: figureImageView.leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: figureImageView.trailingAnchor),
                nameLabel.topAnchor.constraint(equalTo: figureImageView.bottomAnchor, constant: 4)
            ])
            
            let imgButton = UIButton(type: .custom)
            imgButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            resultView.addSubview(imgButton)
            imgButton.activateConstraints([
                imgButton.leadingAnchor.constraint(equalTo: figureImageView.leadingAnchor),
                imgButton.topAnchor.constraint(equalTo: figureImageView.topAnchor),
                imgButton.trailingAnchor.constraint(equalTo: figureImageView.trailingAnchor),
                imgButton.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor)
            ])
            imgButton.tag = i
            self.figureSlugs.append(F.slug)
            imgButton.addTarget(self, action: #selector(self.graphFigureOnTap(_:)), for: .touchUpInside)
        }
        
        return resultView
    }
    
    @objc func twitterButtonOnTap(_ sender: UIButton?) {
        SHARE_ON_TWITTER_2(url: self.twitterUrl, text: self.twitterText)
    }
    
    @objc func graphFigureOnTap(_ sender: UIButton?) {
        var slug = ""
        if let _index = sender?.tag {
            slug = self.figureSlugs[_index]
        }

        let vc = FigureDetailsViewController()
        vc.slug = slug
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func addSubTopics(_ subtopics: [SimpleTopic], title: String) {
        self.subtopics = subtopics
        
        let H: CGFloat = 40.0
        REMOVE_ALL_SUBVIEWS(from: self.subtopicsContainer)
        self.subtopicsContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.subtopicsContainer.superview!.backgroundColor = CSS.shared.displayMode().main_bgColor

        var _m: CGFloat = 0
        if(IPAD()) {
            _m = (SCREEN_SIZE_iPadSideTab().width - W())/2
        }

        let subTitleLabel = UILabel()
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = DM_SERIF_DISPLAY_resize(22)
        subTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        subTitleLabel.text = title
        self.subtopicsContainer.addSubview(subTitleLabel)
        subTitleLabel.activateConstraints([
            subTitleLabel.leadingAnchor.constraint(equalTo: self.subtopicsContainer.leadingAnchor,
                constant: IPHONE() ? 16 : _m),
            subTitleLabel.topAnchor.constraint(equalTo: self.subtopicsContainer.topAnchor, constant: 6)
        ])

        let innerScrollView = UIScrollView()
        innerScrollView.showsHorizontalScrollIndicator = false
        innerScrollView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.subtopicsContainer.addSubview(innerScrollView)
        innerScrollView.activateConstraints([
            innerScrollView.leadingAnchor.constraint(equalTo: self.subtopicsContainer.leadingAnchor, constant: _m),
            innerScrollView.trailingAnchor.constraint(equalTo: self.subtopicsContainer.trailingAnchor, constant: -_m),
            innerScrollView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 8),
            innerScrollView.heightAnchor.constraint(equalToConstant: H)
        ])
        
        let innerContentView = UIView()
        innerContentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        innerScrollView.addSubview(innerContentView)
        innerContentView.activateConstraints([
            innerContentView.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor),
            innerContentView.topAnchor.constraint(equalTo: innerScrollView.topAnchor),
            innerContentView.heightAnchor.constraint(equalToConstant: H)
        ])
        innerContentView.tag = 222
        
        let SEP: CGFloat = 8.0
        var val_x: CGFloat = IPHONE() ? M : 0
        for (i, T) in subtopics.enumerated() {
            let label = UILabel()
            label.font = AILERON(15)
            label.textColor = CSS.shared.displayMode().sec_textColor
            label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
            label.textAlignment = .center
            label.text = T.name
            label.layer.cornerRadius = 20
            label.layer.borderWidth = 1.0
            label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
            label.clipsToBounds = true
            
            let _W = label.calculateWidthFor(height: H) + 42
            
            innerContentView.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: innerContentView.topAnchor),
                label.widthAnchor.constraint(equalToConstant: _W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 400 + i
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            innerContentView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(self.subtopicButtonOnTap), for: .touchUpInside)
            
            val_x += SEP + _W
        }
        
        if(IPHONE()) {
            val_x += M
        }
        
        innerContentView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
        innerScrollView.contentSize = CGSize(width: val_x, height: H)

        self.selectSubTopic(index: 0, mustLoad: false)
        // ----------------------------
        self.subtopicsContainer.show()
        self.tmpContainer2HeightConstraint?.constant = IPHONE() ? 93 : 108
    }
    
    func selectSubTopic(index: Int, mustLoad: Bool = true) {
        self.currentSubTopic = index
        
        if let containerView = self.view.viewWithTag(222) {
            var i = -1
            for V in containerView.subviews {
                if let label = V as? UILabel {
                    i += 1
                    if(i == index) {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                        label.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                        label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor 
                    }
                }
            }
        }
        
        if(mustLoad) {
            //self.topics = []
            
            let containerView = self.view.viewWithTag(555)!
            REMOVE_ALL_SUBVIEWS(from: containerView)
            
            self.page = 1
            self.items = []
            self.loadsCount = 0
            self.isSubTopic = true
            
            // stories
            self.stories = []
            self.storiesTotal = 0
            self.storiesPage = 1
            REMOVE_ALL_SUBVIEWS(from: self.storiesContainer)
            self.storiesContainer.hide()
            
            self.loadContent(page: self.page)
        }
    }
    
    @objc func subtopicButtonOnTap(_ sender: UIButton) {
        let i = sender.tag - 400
        self.selectSubTopic(index: i)
    }
}

// MARK: - Stories
extension ControversiesViewController {
    
    func updateStories(adding newStories: [StorySearchResult]) {
        var _newStories = [StorySearchResult]()
        for ST in newStories {
            var add = true
            
            let foundItems = self.stories.filter { $0.slug == ST.slug }
            if(foundItems.count>0) {
                add = false
            }
            
            if(add) {
                _newStories.append(ST)
            }
        }
        
        var mustShowStories = false
        if(self.storiesTotal>0) {
            mustShowStories = true
        }
        
        if(mustShowStories) {

            if(self.storiesContainer.subviews.count == 0) {
                let titleLabel = UILabel()
                titleLabel.numberOfLines = 0
                titleLabel.font = DM_SERIF_DISPLAY_resize(22)
                titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                titleLabel.text = "Go Deeper"
                self.storiesContainer.addArrangedSubview(titleLabel)
                ADD_SPACER(to: self.storiesContainer, height: 10)
            } else {
                if let _titleLabel = self.storiesContainer.subviews.first as? UILabel {
                    _titleLabel.textColor = CSS.shared.displayMode().sec_textColor
                }
            }
            
            var storiesVStack: UIStackView!
            
            if let _vstack = self.view.viewWithTag(777) as? UIStackView {
                storiesVStack = _vstack
            } else {
                storiesVStack = VSTACK(into: self.storiesContainer)
                storiesVStack.tag = 777
            }
            
            // Refresh stories UI /////////
            if(IPHONE()) {
                for STView in storiesVStack.arrangedSubviews {
                    if(STView is iPhoneAllNews_vImgCol_v3) {
                        (STView as! iPhoneAllNews_vImgCol_v3).refreshDisplayMode()
                        if((STView as! iPhoneAllNews_vImgCol_v3).isContext) {
                            (STView as! iPhoneAllNews_vImgCol_v3).storyPill.setAsContext()
                        }
                    }
                }
            } else {
                for STACKView in storiesVStack.arrangedSubviews {
                    if(STACKView is UIStackView) {
                        let _STACKView = (STACKView as! UIStackView)
                        for STView in _STACKView.arrangedSubviews {
                            if(STView is iPhoneAllNews_vImgCol_v3) {
                                (STView as! iPhoneAllNews_vImgCol_v3).refreshDisplayMode()
                                if((STView as! iPhoneAllNews_vImgCol_v3).isContext) {
                                    (STView as! iPhoneAllNews_vImgCol_v3).storyPill.setAsContext()
                                }
                            }
                        }
                    }
                }
            }
            ///////////////////////////////
            if(IPHONE()) {
                storiesVStack.activateConstraints([
                    storiesVStack.leadingAnchor.constraint(equalTo: self.storiesContainer.leadingAnchor, constant: 16),
                    storiesVStack.trailingAnchor.constraint(equalTo: self.storiesContainer.trailingAnchor, constant: 0)
                ])
            
                let col_WIDTH = SCREEN_SIZE().width-32
                
                for ST in _newStories {
                    let storyView = iPhoneAllNews_vImgCol_v3(width: col_WIDTH, minimumLineNum: false)
                    storiesVStack.addArrangedSubview(storyView)
                    storyView.populate(story: ST)
                    if(ST.type==2) {
                        storyView.isContext = true
                        storyView.storyPill.setAsContext()
                    }
                    
                    storyView.activateConstraints([
                        storyView.heightAnchor.constraint(equalToConstant: storyView.calculateHeight())
                    ])
                    
                    self.stories.append(ST)
                }
            } else {
                let col_WIDTH = (SCREEN_SIZE_iPadSideTab().width-(16*3))/2
                
                var col = 1
                for ST in _newStories {
                    var rowHStack: UIStackView!
                    
                    if(col==1) {
                        rowHStack = HSTACK(into: storiesVStack)
                        rowHStack.backgroundColor = .clear
                    } else {
                        rowHStack = storiesVStack.arrangedSubviews.last as? UIStackView
                    }
                
                    let storyView = iPhoneAllNews_vImgCol_v3(width: col_WIDTH, minimumLineNum: false)
                    rowHStack.addArrangedSubview(storyView)
                    storyView.populate(story: ST)
                    if(ST.type==2) {
                        storyView.isContext = true
                        storyView.storyPill.setAsContext()
                    }
                    storyView.activateConstraints([
                        storyView.heightAnchor.constraint(equalToConstant: storyView.calculateHeight()),
                        storyView.widthAnchor.constraint(equalToConstant: col_WIDTH)
                    ])
                    
                    if(col==1) {
                        ADD_SPACER(to: rowHStack)
                    }
                    col += 1
                    
                    if(col==3){ col=1 }
                    self.stories.append(ST)
                }
            }
            self.storiesContainer.show()
            
            //show more
            if(self.stories.count < self.storiesTotal) {
                // ---- Show More
                if(self.storiesShowMore.subviews.count==0) {
                    self.storiesShowMore.backgroundColor = CSS.shared.displayMode().main_bgColor
                    self.storiesShowMore.activateConstraints([
                        self.storiesShowMore.heightAnchor.constraint(equalToConstant: 88)
                    ])

                    let button = UIButton(type: .custom)
                    self.storiesShowMore.addSubview(button)
                    button.activateConstraints([
                        button.heightAnchor.constraint(equalToConstant: 42),
                        button.widthAnchor.constraint(equalToConstant: 150),
                        button.centerXAnchor.constraint(equalTo: self.storiesShowMore.centerXAnchor),
                        button.centerYAnchor.constraint(equalTo: self.storiesShowMore.centerYAnchor)
                    ])
                    button.setTitle("Show more", for: .normal)
                    button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
                    button.titleLabel?.font = AILERON(15)
                    button.layer.masksToBounds = true
                    button.layer.cornerRadius = 9
                    button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
                    
                    button.addTarget(self, action: #selector(self.onLoadMoreStoriesTap(_:)), for: .touchUpInside)
                }

                storiesVStack.addArrangedSubview(self.storiesShowMore)
                storiesVStack.show()
                // ----
            } else {
                self.storiesShowMore.removeFromSuperview()
            }
        } else {
            self.storiesContainer.hide()
            REMOVE_ALL_SUBVIEWS(from: self.storiesContainer)
        }
    }
    
    @objc func onLoadMoreStoriesTap(_ sender: UIButton?) {
        self.loadMoreStories(page: self.storiesPage+1)
    }
    
    private func loadMoreStories(page P: Int) {
        var T = ""
        if(!self.isSubTopic) {
            if(self.topics.count>0 && self.currentTopic != -1) {
                T = self.topics[self.currentTopic].slug
                if(T == "all"){ T = "" }
            }
        } else {
            if(self.subtopics.count>0 && self.currentSubTopic != -1) {
                T = self.subtopics[self.currentSubTopic].slug
                if(T == "all"){
                     //T = ""
                     if(self.topics.count>0 && self.currentTopic != -1) {
                        T = self.topics[self.currentTopic].slug
                        if(T == "all"){ T = "" }
                    }
                }
            }
        }
        
        self.showLoading()
        print("LOAD more STORIES (for CONTROVERSY)")
        ControversiesData.shared.loadList(topic: T, page: P) { (error, total, list, topics, subtopics, controData, storiesCount, stories) in
            self.hideLoading()
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                    message: "Trouble loading Stories,\nplease try again later.", onCompletion: {
                        CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    if let _t = storiesCount, let _stories = stories {
                        self.storiesPage += 1
                        self.addMoreStories(total: _t, items: _stories)
                    }
                }
            }
        }
                
    }
    
    func addMoreStories(total: Int, items: [StorySearchResult]) {
        self.storiesTotal = total
        self.updateStories(adding: items)
    }
    
}

extension ControversiesViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let _url = navigationAction.request.mainDocumentURL?.absoluteString {
            
            //print("URL", _url)
            
//            if(_url.contains(self.GRAPH_URL)) {
//                
//            } else {
//                print(_url)
//                decisionHandler(.cancel)
//            }
            
            decisionHandler(.allow)
            webView.isUserInteractionEnabled = false
            
            

            

//            if(url.contains("metaculus.php")) {
//                decisionHandler(.allow)
//            } else if(url.contains("metaculus.com")) {
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

extension ControversiesViewController {
    
    func candidateView(dataIndex: Int) -> UIView {
        let candidate = self.candidates[dataIndex]
        self.graphHeight = 64+6+16+6
        
        let resultView = UIView()
        resultView.backgroundColor = .clear //.green
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: 90),
            resultView.heightAnchor.constraint(equalToConstant: self.graphHeight)
        ])
        
        let circleBorderView = UIView()
        circleBorderView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        resultView.addSubview(circleBorderView)
        circleBorderView.activateConstraints([
            circleBorderView.widthAnchor.constraint(equalToConstant: 64),
            circleBorderView.heightAnchor.constraint(equalToConstant: 64),
            circleBorderView.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
            circleBorderView.topAnchor.constraint(equalTo: resultView.topAnchor)
        ])
        circleBorderView.layer.cornerRadius = 64/2
        
        let imageView = UIImageView()
        circleBorderView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 46),
            imageView.heightAnchor.constraint(equalToConstant: 46),
            imageView.centerXAnchor.constraint(equalTo: circleBorderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleBorderView.centerYAnchor)
        ])
        imageView.layer.cornerRadius = 46/2
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: candidate.image))
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = AILERON(13)
        nameLabel.textColor = CSS.shared.displayMode().main_textColor
        nameLabel.text = candidate.name.uppercased()
        nameLabel.backgroundColor = .clear //.blue
        resultView.addSubview(nameLabel)
        nameLabel.activateConstraints([
            nameLabel.topAnchor.constraint(equalTo: circleBorderView.bottomAnchor, constant: 6),
            nameLabel.centerXAnchor.constraint(equalTo: circleBorderView.centerXAnchor)
        ])
        
        let buttonArea = UIButton(type: .system)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        resultView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: resultView.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: resultView.bottomAnchor)
        ])
        buttonArea.tag = dataIndex
        buttonArea.addTarget(self, action: #selector(self.candidateButtonOnTap(_:)), for: .touchUpInside)
        
        return resultView
    }
    @objc func candidateButtonOnTap(_ sender: UIButton?) {
        let index = sender!.tag
        let candidate = self.candidates[index]
        
        let vc = FigureDetailsViewController()
        vc.slug = candidate.slug
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    // ---------------------------------
    func mediaItemsView(forCandidateIndex dataIndex: Int) -> UIView {
        let candidate = self.candidates[dataIndex]
        let _mediaItems = self.mediaItems.filter({ $0.figureId == candidate.id })

//        let _mediaItems = self.mediaItems.filter({ $0.name.count > 3 })
//        let _mediaItems = self.mediaItems
        
        let resultView = UIView()
        resultView.backgroundColor = .clear //.yellow
    
        // -------------------
        let items_dim: CGFloat = 34.0
        let items_per_row: CGFloat = 4.0
        let items_sep: CGFloat = 11.0
        
        let _W: CGFloat = (items_dim + items_sep) * items_per_row
        var _H: CGFloat = 0
        
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        var row: Int = 1
        var col: Int = 1
        
        for (j, M) in _mediaItems.enumerated() {
            if(val_x >= _W) {
                val_x = 0
                val_y += items_sep + items_dim
                
                _H = val_y + items_dim
                row += 1
            }
            
            var rowView: UIView!
            if(resultView.subviews.count < row) {
                rowView = UIView()
                rowView.backgroundColor = .clear //.green
                resultView.addSubview(rowView)
                rowView.activateConstraints([
                    rowView.topAnchor.constraint(equalTo: resultView.topAnchor, constant: val_y),
                    rowView.heightAnchor.constraint(equalToConstant: items_dim)
                ])
            } else {
                rowView = resultView.subviews.last!
            }
            
            let mediaIcon = UIImageView()
            mediaIcon.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.25) : .black.withAlphaComponent(0.25)
            rowView.addSubview(mediaIcon)
            mediaIcon.activateConstraints([
                mediaIcon.widthAnchor.constraint(equalToConstant: items_dim),
                mediaIcon.heightAnchor.constraint(equalToConstant: items_dim),
                mediaIcon.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
                mediaIcon.topAnchor.constraint(equalTo: rowView.topAnchor)
            ])
            mediaIcon.layer.cornerRadius = items_dim/2
            mediaIcon.clipsToBounds = true
            mediaIcon.sd_setImage(with: URL(string: M.image))
        
            let buttonArea = UIButton(type: .system)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            rowView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: mediaIcon.leadingAnchor),
                buttonArea.topAnchor.constraint(equalTo: mediaIcon.topAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: mediaIcon.trailingAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: mediaIcon.bottomAnchor)
            ])
            buttonArea.tag = j
            buttonArea.addTarget(self, action: #selector(self.mediaButtonOnTap(_:)), for: .touchUpInside)
        
            val_x += items_dim + items_sep
            col += 1
            
            if(col==4) {
                rowView.widthAnchor.constraint(equalToConstant: _W).isActive = true
                rowView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
                col = 1
            } else {
                if(j == _mediaItems.count-1) {
                    rowView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
                    if(dataIndex == 0) {
                        rowView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor).isActive = true
                    } else {
                        rowView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
                    }
                }
            }
        }
        
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: _W),
            resultView.heightAnchor.constraint(equalToConstant: _H),
        ])
        
        if(_H > self.mediaItemsHeight) {
            self.mediaItemsHeight = _H
        }
        
        return resultView
    }
    @objc func mediaButtonOnTap(_ sender: UIButton?) {
        let index = sender!.tag
        let mediaItem = self.mediaItems[index]

//        let vc = ArticleViewController()
//        vc.article = MainFeedArticle(url: mediaItem.url)
//        CustomNavController.shared.pushViewController(vc, animated: true)

        let text = "Result called on " + mediaItem.time + ". [0]"
        
        let popup = ElectionResultsPopupView(title: mediaItem.name,
                    description: text, linkedTexts: ["Source"], links: [mediaItem.url], height: 175)
        
        popup.delegate = self
        popup.pushFromBottom()
    }
    
    // ---------------------------------
    func yetToCallWinnerView(width: CGFloat) -> UIView {
        let resultView = UIView()
        resultView.backgroundColor = .clear
        
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: width)
        ])
        
        let _mediaItems = self.mediaItems.filter({ $0.figureId == 0 })
        //let _mediaItems = self.mediaItems
        self.yetToCallWinnerHeight = 0
        
        // -------------------
        let items_dim: CGFloat = 34.0
        let items_per_row: CGFloat = 8.0
        let items_sep: CGFloat = 11.0
        
        var _H: CGFloat = 0
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        var row: Int = 1
        var col: Int = 1
        
        for (j, M) in _mediaItems.enumerated() {
            if(val_x >= width) {
                val_x = 0
                val_y += items_sep + items_dim
                
                _H = val_y + items_dim
                row += 1
            }
            
            var rowView: UIView!
            if(resultView.subviews.count < row) {
                rowView = UIView()
                rowView.backgroundColor = .clear //.green
                resultView.addSubview(rowView)
                rowView.activateConstraints([
                    rowView.topAnchor.constraint(equalTo: resultView.topAnchor, constant: val_y),
                    rowView.heightAnchor.constraint(equalToConstant: items_dim)
                ])
                
                self.yetToCallWinnerHeight += items_dim + items_sep
            } else {
                rowView = resultView.subviews.last!
            }
            
            let mediaIcon = UIImageView()
            mediaIcon.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.25) : .black.withAlphaComponent(0.25)
            rowView.addSubview(mediaIcon)
            mediaIcon.activateConstraints([
                mediaIcon.widthAnchor.constraint(equalToConstant: items_dim),
                mediaIcon.heightAnchor.constraint(equalToConstant: items_dim),
                mediaIcon.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: val_x),
                mediaIcon.topAnchor.constraint(equalTo: rowView.topAnchor)
            ])
            mediaIcon.layer.cornerRadius = items_dim/2
            mediaIcon.clipsToBounds = true
            mediaIcon.sd_setImage(with: URL(string: M.image))
        
            let buttonArea = UIButton(type: .system)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            rowView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: mediaIcon.leadingAnchor),
                buttonArea.topAnchor.constraint(equalTo: mediaIcon.topAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: mediaIcon.trailingAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: mediaIcon.bottomAnchor)
            ])
            buttonArea.tag = j
            buttonArea.addTarget(self, action: #selector(self.mediaButtonOnTap(_:)), for: .touchUpInside)
        
            val_x += items_dim + items_sep
            col += 1
            
            if(col==Int(items_per_row)) {
                rowView.widthAnchor.constraint(equalToConstant: width-items_sep).isActive = true
                rowView.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
                col = 1
            } else {
                if(j == _mediaItems.count-1) {
                    rowView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
                    rowView.centerXAnchor.constraint(equalTo: resultView.centerXAnchor).isActive = true
                }
            }
        }
        
        resultView.heightAnchor.constraint(equalToConstant: self.yetToCallWinnerHeight).isActive = true
        return resultView
    }
}

extension ControversiesViewController: ElectionResultsPopupViewDelegate {
    
    func ElectionResultsPopupView_onUrlOpened(sender: ElectionResultsPopupView, url: String) {
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: url)
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
}
