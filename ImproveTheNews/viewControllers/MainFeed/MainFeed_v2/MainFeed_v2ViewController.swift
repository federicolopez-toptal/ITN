//
//  MainFeed_v2ViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit

class MainFeed_v2ViewController: BaseViewController {

    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()
    var list = CustomFeedList()

    var topic = "news"
    let data = MainFeedv3()
    var dataProvider = [DataProviderItem]()

    var topicsCompleted = [String: Bool]()
    var prevMustSplit: Int?
    var mustReloadOnShow = false
    var bannerClosed = false
    

    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.preferencesSetDefaultValues()
        self.addNotificationObservers()
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
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.loadData(showLoading: true)
            CustomNavController.shared.menu.changeLayoutFromStoredValue()
            CustomNavController.shared.menu.changeDisplayModeFromStoredValue()
        }
    }
    
    // MARK: - UI
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
    func refreshList() {
        DispatchQueue.main.async {
            self.list.reloadData()
        }
    }

}

// MARK: - Data
extension MainFeed_v2ViewController {
    
    func loadData(showLoading: Bool = true) {
        self.bannerClosed = false
        if(showLoading){ self.showLoading() }
        self.topicsCompleted = [String: Bool]()
        
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

//                        if(self.prevMustSplit != nil) {
//                            if(self.prevMustSplit != MUST_SPLIT()) {
//                                CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
//                            }
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
//                        DELAY(2.0) {
//                            self.scrollToBottom()
//                        }
                        
                        self.testFeature()
                    }
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
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: self.dataProvider.count-1, section: 0)
        self.list.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}


extension MainFeed_v2ViewController {
    
    func testFeature() {
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
    }
    
}
