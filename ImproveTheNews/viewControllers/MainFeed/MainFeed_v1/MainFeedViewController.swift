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

    var mustReloadOnShow = false
    var bannerClosed = false


    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
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
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.setReloadMainFeedOnShow),
            name: Notification_reloadMainFeedOnShow, object: nil)
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onStanceIconTapFromNotification),
            name: Notification_stanceIconTap, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            if(self.imFirstViewController()) {
                self.navBar.addComponents([.logo, .menuIcon, .searchIcon, .user]) //.user
            } else {
                self.navBar.addComponents([.back, .title, .headlines])
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
            self.loadUserData()
            self.testFeature()
            
//            UUID.shared.trace()
            
//            DELAY(0.5) { //!!!
//                let vc = FAQViewController()
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.loadData(showLoading: true)
            CustomNavController.shared.menu.changeLayoutFromStoredValue()
            CustomNavController.shared.menu.changeDisplayModeFromStoredValue()
        }
    }
    
    @objc func onStanceIconTapFromNotification(_ notification: Notification) {
        var mustReturn = false
        if(CustomNavController.shared.viewControllers.last! != self) { mustReturn = true }
        if(CustomNavController.shared.viewControllers.last! is KeywordSearchViewController){ mustReturn = false }
        if(mustReturn){ return }
    
        if let _info = notification.userInfo as? [String: Any] {
            let source = _info["source"] as! String
            let country = _info["country"] as! String
            let LR = _info["LR"] as! Int
            let PE = _info["PE"] as! Int
            
            let popup = StancePopupView()
            popup.populate(sourceName: source, country: country, LR: LR, PE: PE)
            popup.pushFromBottom()
            //print("HERE!")
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
    // MARK: - Data
    func loadData(showLoading: Bool = true) {

        self.bannerClosed = false
        if(showLoading){ self.showLoading() }
        self.topicsCompleted = [String: Bool]()
        //let imFirst = self.imFirstViewController() !!!
        
        var cfg = URLSession.shared.configuration
        cfg.timeoutIntervalForRequest = 30
        
        UUID.shared.checkIfGenerated { (success) in // generates a new uuid (if needed)
            if(!success) {
                self.showErrorAlert()
                return
            }
            
            Sources.shared.checkIfLoaded { (success) in // load sources (if needed)
                if(!success) {
                    self.showErrorAlert()
                    return
                }
            
                self.data.loadData(self.topic) { (error) in
                    MAIN_THREAD {/* --- */
                        if(error != nil || self.data.topics.count == 0) {
                            self.showErrorAlert()
                            return
                        }
                    
                        self.navBar.setTitle(self.getTopicName(topic: self.topic))
                        self.topicSelector.setTopics(self.data.topicNames())
                        self.populateDataProvider()
                        self.refreshList()

                        self.hideLoading()
                        self.list.hideRefresher()
                        self.list.forceUpdateLayoutForVisibleItems()
                        self.refreshVLine()

//                        if(self.prevMustSplit != nil) {
//                            if(self.prevMustSplit != MUST_SPLIT()) { self.tapOnLogo() }
//                        }
//                        self.prevMustSplit = MUST_SPLIT()
                        
                        // TOUR
                        if(READ(LocalKeys.preferences.onBoardingShow)==nil) {
                            if(CustomNavController.shared.viewControllers.first! == self) {
                                WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
                                CustomNavController.shared.startTour()
                            }
                        }
                        
//                        if(CustomNavController.shared.viewControllers.first! == self) {
//                            CustomNavController.shared.startTour() //!!!
//                        }

                        //self.testFeature()
                        
                    /* --- */ }
                }
            }
        }
    }
    
    func showErrorAlert() {
        MAIN_THREAD {
            self.hideLoading()
            self.list.hideRefresher()
            
            ALERT(vc: self, title: "",
                message: "Trouble loading the news,\nplease try again later.", onCompletion: {
                DELAY(1.0) {
                    self.loadData(showLoading: true)
                }
            })
        }
    }
    
    func loadUserData() { // UNSED
//        if(CustomNavController.shared.viewControllers.first!==self && USER_AUTHENTICATED()) {
//            API.shared.getUserInfo { (success, serverMsg, user) in
//                if let _sliderValues = user?.sliderValues {
//                    print(_sliderValues)
//                    print(MainFeedv3.sliderValues())
//
//                    if(_sliderValues != MainFeedv3.sliderValues()) {
//                        MainFeedv3.parseSliderValues(_sliderValues)
//                        self.loadData(showLoading: true)
//                        MAIN_THREAD {
//                            CustomNavController.shared.slidersPanel.reloadSliderValues()
//                            CustomNavController.shared.slidersPanel.forceSplitToStoredValue()
//                            CustomNavController.shared.menu.changeLayoutFromStoredValue()
//                            CustomNavController.shared.menu.changeDisplayModeFromStoredValue()
//                        }
//                    } else {
//                        print("nop")
//                    }
//                }
//            }
//        }
    }
    
    
    // MARK: - For local notifications
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
                self.bannerClosed = true
                self.dataProvider.remove(at: i)
                break
            }
        }
        
        self.refreshList()
        self.list.forceUpdateLayoutForVisibleItems()
    }
    @objc func setReloadMainFeedOnShow() {
        self.mustReloadOnShow = true
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
extension MainFeedViewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        if(index==0) {
            self.scrollToZero()
        } else {
            let vc = MainFeedViewController()
            let topic = self.data.topics[index].name
            vc.topic = topic
            
            CustomNavController.shared.tour_old?.cancel()
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
        
        // show flags
        if(READ(LocalKeys.preferences.showSourceFlags)==nil) {
            WRITE(LocalKeys.preferences.showSourceFlags, value: "01")
        }
    }
    
    func scrollToBottom() {
        self.list.scrollToItem(at: IndexPath(row: self.dataProvider.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func showFAQ() {
        let vc = FAQViewController()
        CustomNavController.shared.viewControllers = [vc]
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

//        var found = false
//        for T in self.data.topics {
//            if(T.name=="sci_tech") {
//                for (i, A) in T.articles.enumerated() {
//                    if(i==1 && A.isStory) {
//                        DELAY(1.0) {
//                            let vc = StoryViewController()
//                            vc.story = A
//                            CustomNavController.shared.pushViewController(vc, animated: true)
//                        }
//                        
//                    
//                        found = true
//                        break
//                    }
//                }
//            }
//            
//            if(found){ break }
//        }

//        DELAY(1.0) {
//            MAIN_THREAD {
//                let vc = KeywordSearchViewController()
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }
//        }
        ///
    }
    
}

extension MainFeedViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
