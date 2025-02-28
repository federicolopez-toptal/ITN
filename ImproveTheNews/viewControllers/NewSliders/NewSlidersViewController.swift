//
//  NewSlidersViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit


class NewSlidersViewController: BaseViewController {
    
    var topic = "news"
    let articlesPerLoad: Int = 28
    let articlesPerLoadSplit: Int = 11
    
    let navBar = NavBarView()
    let topicSelector = TopicSelectorViewPlus()
    var list = CustomFeedList()
    
    let data = MainFeedv3()
    var dataProvider = [DP3_item]()
    var topicsCompleted = [String: Bool]()
    var mustReloadOnShow = false
    
    let subTitleLabel = UILabel()
    var middleIndexPath: IndexPath?
    
    let slidersPanel = SlidersPanel()
    
    var lastTopicTapped: String = ""
    var topicReloading = ("", -1)
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.setReloadMainFeedOnShow),
            name: Notification_reloadMainFeedOnShow, object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.loadDataFromNotification),
            name: Notification_reloadMainFeed, object: nil)
    }
    @objc func loadDataFromNotification(_ notification: Notification) {
        self.loadContent()
    }
    @objc func setReloadMainFeedOnShow() {
        self.mustReloadOnShow = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.menuIcon, .title, .share]) //.question .info2
            self.navBar.setTitle("Bias Split")
            self.navBar.addInfoButton(icon_yOffset: 2)
            self.navBar.addBottomLine()
            
            // ------------------------------
            self.navBar.onInfoButtonTap {
                let popup = StoryInfoPopupView(title: "Bias Split",
                    description: """
                    Use our sliders and stance-split feature for a more deliberate view of today’s headlines from other outlets.
                    """,
                    linkedTexts: [], links: [],
                    height: 180)
                    
                popup.pushFromBottom()
            }
            
            self.navBar.onQuestionButtonTap {
                let vc = FAQViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                DELAY(0.4) {
                    vc.scrollToNewsSliders()
                }
            }
                        
            self.navBar.setShareUrl(ITN_URL() + "/news-slider", vc: self)
            // -----------------------------
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        self.setupList()
        
        self.slidersPanel.buildInto(self.view, bottomRefView: self.list)
        self.slidersPanel.delegate = self
        
        self.slidersPanel.hide()
        self.slidersPanel.floatingButton.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.slidersPanel.reloadSliderValues()
            self.loadContent()
        }  
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        self.slidersPanel.refreshDisplayMode()
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
}

// MARK: misc
extension NewSlidersViewController: UIGestureRecognizerDelegate {
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: data
extension NewSlidersViewController {

    func loadContent(showLoading: Bool = true) {
        if(showLoading){ self.showLoading() }
        self.topicsCompleted = [String: Bool]()
        
        var C = self.articlesPerLoad
        if(MUST_SPLIT_B() != 0) {
            C = self.articlesPerLoadSplit
        }
        
        UUID.shared.checkIfGenerated { (success) in // generates a new uuid (if needed)
        /* ... */
        self.data.loadArticlesData(self.topic, amount: C) { error in
            MAIN_THREAD {/* --- */
                if(error != nil || self.data.topics.count == 0) {
                    self.showErrorAlert()
                    return
                }
                
                self.topicReloading = ("", -1)
                self.data.fixTopicsForNewSliders()
                
                var backButton = false
                if(self.topic != "news"){ backButton = true }
                
                var topicNames = self.data.topicNames()
                if(self.lastTopicTapped == "Russia/Ukraine" || self.lastTopicTapped == "Israel/Palestine") {
                    topicNames = [self.lastTopicTapped]
                }
                self.topicSelector.setTopics(topicNames, addBack: backButton)
                
                self.populateDataProvider()
                self.refreshList()
                self.hideLoading()
                self.list.hideRefresher()
                
                self.slidersPanel.show()
                self.slidersPanel.floatingButton.show()
            }
        }
        /* ... */
        }
        
    }
    
    func showErrorAlert() {
        MAIN_THREAD {
            self.hideLoading()
            
            ALERT(vc: self, title: "",
                message: "Trouble loading the news,\nplease try again later.", onCompletion: {
                
                var reloading = true
                if(self.topic != self.topicReloading.0) {
                    self.topicReloading = (self.topic, 1)
                } else {
                    let value = self.topicReloading.1 + 1
                    self.topicReloading.1 = value
                    
                    if(value == 3) {
                        reloading = false
                    }
                }

                if(reloading) {
                    DELAY(1.0) {
                        self.loadContent()
                    }
                }
            })
        }
    }
    
}

// MARK: Device rotation
extension NewSlidersViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let _rows = self.list.indexPathsForVisibleRows, let _rowA = _rows.first, let _rowZ = _rows.last {
            let middleRow = (_rowA.row + _rowZ.row)/2
            self.middleIndexPath = IndexPath(row: middleRow, section: 0)
        }

        self.setupList()
        CustomNavController.shared.tour.rotate()
////        self.tabsBar.buildInto(viewController: self)
//        
//        // Header
//        DELAY(0.2) {
//            self.navBar.alpha = 1.0
//            self.navBar.show()
//            
//            self.topicSelector.alpha = 1.0
//            self.topicSelector.show()
//        }
    }

}

extension NewSlidersViewController: SlidersPanelDelegate {
    func slidersPanelOnRefresh(sender: SlidersPanel) {
        self.loadContent()
    }
}

// MARK: - TopicSelectorViewDelegate
extension NewSlidersViewController: TopicSelectorViewPlusDelegate {

    func onTopicSelected(_ index: Int) {
//        if(index==0) {
//            self.list.scrollToTop()
//        } else {
//            let vc = MainFeed_v3_viewController()
//            let topic = self.data.topics[index].name
//            vc.topic = topic
//            
//            CustomNavController.shared.tour_old?.cancel()
//            CustomNavController.shared.pushViewController(vc, animated: true)
//        }

        let T = self.data.topics[index]
        self.lastTopicTapped = T.capitalizedName
        
        self.topic = T.name
        self.loadContent()
    }
    
    func onTopicBackButtonTap() {
        self.lastTopicTapped = ""
        self.topic = "news"
        self.loadContent()
    }
    
}
