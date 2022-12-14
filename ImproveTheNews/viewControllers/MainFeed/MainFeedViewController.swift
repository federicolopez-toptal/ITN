//
//  MainFeedViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit



class MainFeedViewController: BaseViewController {

    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()
    var list = CustomCollectionView()

    var topic = "news"
    let data = MainFeedv3()
    var dataProvider = [DP_item]()
    
    var topicsCompleted = [String: Bool]()
    var column = 1
    var prevMustSplit: Int?



    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.preferencesSetDefaultValues()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.loadDataFromNotification),
            name: Notification_reloadMainFeed, object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.refreshDataFromNotification),
            name: Notification_refreshMainFeed, object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.removeBannerFromNotification),
            name: Notification_removeBanner, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            if(self.imFirstViewController()) {
                self.navBar.addComponents([.logo, .menuIcon, .searchIcon])
            } else {
                self.navBar.addComponents([.back, .title])
            }
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            self.setupList()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
            self.testFeature()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
    // MARK: - Data
    func loadData(showLoading: Bool = true) {
        if(showLoading){ self.showLoading() }
        self.topicsCompleted = [String: Bool]()
        //let imFirst = self.imFirstViewController() !!!
        
        UUID.shared.checkIfGenerated { _ in // generates a new uuid (if needed)
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                //if(imFirst){ self.data.resetCounting() } !!!

                self.data.loadData(self.topic) { (error) in
                    MAIN_THREAD {/* --- */
                        if(self.data.topics.count == 0) {
                            print("FEED VACIO!!!")
                        }
                    
                        self.navBar.setTitle(self.getTopicName(topic: self.topic))
                        self.topicSelector.setTopics(self.data.topicNames())
                        self.populateDataProvider()
                        self.refreshList()

                        self.hideLoading()
                        self.list.hideRefresher()
                        self.list.forceUpdateLayoutForVisibleItems()
                        self.refreshVLine()

                        if(self.prevMustSplit != nil) {
                            if(self.prevMustSplit != self.mustSplit()) { self.tapOnLogo() }
                        }
                        self.prevMustSplit = self.mustSplit()
                        
                        // TOUR
                        if(CustomNavController.shared.showTour || READ(LocalKeys.preferences.onBoardingShow)==nil) {
                            WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
                            CustomNavController.shared.showTour = false
                            self.startTour()
                        }
                    /* --- */ }
                }
            }
        }
    }
    @objc func loadDataFromNotification() {
        self.loadData(showLoading: true)
    }
    @objc func refreshDataFromNotification() {
        self.refreshList()
        self.list.forceUpdateLayoutForVisibleItems()
    }
    @objc func removeBannerFromNotification() {
        for (i, dpObj) in self.dataProvider.enumerated() {
            if(dpObj is DP_banner) {
                self.dataProvider.remove(at: i)
                break
            }
        }
        
        self.refreshList()
        self.list.forceUpdateLayoutForVisibleItems()
    }
    
    // MARK: - end
    deinit {
//        if let _prevVC = CustomNavController.shared.viewControllers.last as? MainFeedViewController {
//            _prevVC.data.removeCount() !!!
//        }
    }
    
    // MARK: - misc
    func tapOnLogo() { // called from the navBar
        CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
    }
    
    func imFirstViewController() -> Bool {
        var result = false
        if let _first = CustomNavController.shared.viewControllers.first {
            if(_first == self) { result = true }
        }

        return result
    }
    
    func mustSplit() -> Int {
        if let _value = READ(LocalKeys.sliders.split) {
            return Int(_value)!
        } else {
            return 0
        }
    }
    
    func scrollToZero() {
        self.list.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    func getTopicName(topic: String) -> String {
        var result = ""
        for T in self.data.topics {
            if(T.name == topic) {
                result = T.capitalizedName
                break
            }
        }
        
        return result
    }


}

// MARK: - Topic selector & Breadcrumbs
extension MainFeedViewController: TopicSelectorViewDelegate, BreadcrumbsViewDelegate {

    func onTopicSelected(_ index: Int) {
        if(index==0) {
            self.scrollToZero()
        } else {
            let vc = MainFeedViewController()
            let topic = self.data.topics[index].name
            vc.topic = topic
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }

    // OLD SCROLLING BEHAVIOR
//    func onTopicSelected(_ index: Int) {
//        if(index==0) {
//            self.list.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//            return
//        }
//
//        var i = -1
//        for (j, dp) in self.dataProvider.enumerated() {
//            if let _ = dp as? DP_header {
//                i += 1
//                if(i == index) {
//                    self.list.scrollToItem(at: IndexPath(row: j, section: 0), at: .top, animated: true)
//                    break
//                }
//            }
//        }
//    }
    
    func breadcrumbOnTap(sender: BreadcrumbsView) {
        CustomNavController.shared.popViewController(animated: true)
    }
    
}

extension MainFeedViewController {
    
    func preferencesSetDefaultValues() {
        // show stories
        if(READ(LocalKeys.preferences.showStories)==nil) {
            WRITE(LocalKeys.preferences.showStories, value: "01")
        }
    
        // show source icons
        if(READ(LocalKeys.preferences.showSourceIcons)==nil) {
            WRITE(LocalKeys.preferences.showSourceIcons, value: "01")
        }
        
        // show stance icons
        if(READ(LocalKeys.preferences.showStanceIcons)==nil) {
            WRITE(LocalKeys.preferences.showStanceIcons, value: "01")
        }
        
        // stance popups
        if(READ(LocalKeys.preferences.showStancePopups)==nil) {
            WRITE(LocalKeys.preferences.showStancePopups, value: "01")
        }
        
    }
    
    func startTour() {
        MAIN_THREAD {
            CustomNavController.shared.slidersPanel.makeSureIsClosed()
            CustomNavController.shared.slidersPanel.forceSplitOff()
        
            let tour = TourView(buildInto: CustomNavController.shared.view)
            tour.start()
        }
    }
    
    func scrollToBottom() {
        self.list.scrollToItem(at: IndexPath(row: self.dataProvider.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func showFAQ() {
        let vc = FAQViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.2) {
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
        }
    }
    
}
    
 
extension MainFeedViewController {
    
    // Called from viewDidAppear, for testing purposes
    func testFeature() {

//        DELAY(4.5) {
//            self.scrollToBottom()
//        }
        
//        DELAY(1.0) {
//            self.hideLoading()
//            self.showFAQ()
//        }
    }
}
