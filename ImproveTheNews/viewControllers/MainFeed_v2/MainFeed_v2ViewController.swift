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
    var dataProvider = [DataProviderGroupItem]()

    var topicsCompleted = [String: Bool]()
    var mustReloadOnShow = false



    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.preferencesSetDefaultValues()
        
        // add notification observers
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            if(self.imFirstViewController()) {
                self.navBar.addComponents([.logo, .menuIcon, .searchIcon, .user])
            } else {
                self.navBar.addComponents([.back, .title, .headlines])
            }
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            //self.setupList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
            //self.testFeature()
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.loadData(showLoading: true)
        }
        
        if(CustomNavController.shared.slidersPanel.isHidden && CustomNavController.shared.floatingButton.isHidden) {
            CustomNavController.shared.showPanelAndButtonWithAnimation()
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
        
        UUID.shared.checkIfGenerated { _ in // generates a new uuid (if needed)
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)

                self.data.loadData(self.topic) { (error) in
                    MAIN_THREAD {/* --- */
                        if(self.data.topics.count == 0) {
                            print("FEED VACIO!!!")
                        }
                    
                        self.navBar.setTitle(self.getTopicName(topic: self.topic))
                        self.topicSelector.setTopics(self.data.topicNames())
                        self.populateDataProvider()
//                        self.refreshList()

                        self.hideLoading()
//                        self.list.hideRefresher()
//                        self.list.forceUpdateLayoutForVisibleItems()
//                        self.refreshVLine()

//                        if(self.prevMustSplit != nil) {
//                            if(self.prevMustSplit != MUST_SPLIT()) { self.tapOnLogo() }
//                        }
//                        self.prevMustSplit = MUST_SPLIT()
                        
//                        // TOUR
//                        if(CustomNavController.shared.showTour || READ(LocalKeys.preferences.onBoardingShow)==nil) {
//                            WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
//                            CustomNavController.shared.showTour = false
//                            self.startTour()
//                        }
                        
                    /* --- */ }
                }
            }
        }
    }

}
