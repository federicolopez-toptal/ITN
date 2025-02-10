//
//  MainFeed_v3_viewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit


class MainFeed_v3_viewController: BaseViewController {
    
    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()
    var list = CustomFeedList()
    
    var topic = "news"
    let data = MainFeedv5_iPhone()
    var dataProvider = [DP3_item]()
    
    var topicsCompleted = [String: Bool]()
    var prevMustSplit: Int?
    var mustReloadOnShow = false
    var bannerClosed = false
    
    var topValue: CGFloat = 0
    
    
    var lastScrollViewPosY: CGFloat = 0
    var topBarsTransitioning = false
    
    var controversies = [ControversyListItem]()
    var controversiesTotal = 0
    var controversiesPage = 1
    let latestControversies = "Latest controversies"
    
    var safeAreaTop: CGFloat = 0
    
    //var debugText = UITextField()
    
    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.preferencesSetDefaultValues()
        self.addNotificationObservers()
        
//        UUID.shared.trace()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            if(self.imFirstViewController()) {
                self.navBar.addComponents([.logo, .menuIcon, .searchIcon, .user, .newsletter])
            } else {
                self.navBar.addComponents([.back, .title, .headlines])
            }
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            self.topValue = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
            self.setupList()
            
            if let _safeAreaTop = SAFE_AREA()?.top {
                self.list.setRefresher_yOffset(_safeAreaTop)                
                self.safeAreaTop = _safeAreaTop
            }
            
            (CustomNavController.shared.tabsBar as! TabsBar_iPhone).iPhone_yOffset_fix()
            
//            self.navBar.alpha = 0.25
//            self.topicSelector.alpha = 0.25
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeywordSearch.searchTerm = nil
            
        if(!self.didAppear) {
            //CustomNavController.shared.tour.start()
            
//            DELAY(1.0) {
//                var vc = SourceFilter_iPhoneViewController()
//                vc.modalPresentationStyle = .fullScreen
//                CustomNavController.shared.present(vc, animated: true)
//            }
            
        
        
        
            self.didAppear = true
            self.loadData()
            
//            DELAY(0.5) {
//                let vc = NewsLetterContentViewController()
//                vc.refData = NewsLetterStory(type: 1)
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }

//            DELAY(0.5) {
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
        
        CHECK_AUTHENTICATED()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBar.alpha = 1.0
        self.navBar.show()
        self.topicSelector.alpha = 1.0
        self.topicSelector.show()
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
}


// MARK: - Data
extension MainFeed_v3_viewController {
    
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
                        //print(self.data.topicNamesss())
                        
                        self.populateDataProvider()
                        self.refreshList()

                        self.hideLoading()
                        self.list.hideRefresher()
                        
                        // TOUR
                        if(READ(LocalKeys.preferences.onBoardingShow)==nil) {
                            WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
                            CustomNavController.shared.tour.start()
                        }

//                        DELAY(0.25) {
//                            //let vc = PublicFiguresViewController()
//                            
//                            let vc = FigureDetailsViewController()
//                            vc.slug = "elon-musk"
//                            CustomNavController.shared.pushViewController(vc, animated: true)
//                        }
                

//                        DELAY(0.5) {
//                            let vc = NewsLetterContentViewController()
//                            vc.refData = NewsLetterStory(type: 2)
//                            CustomNavController.shared.pushViewController(vc, animated: true)
//                        }

//                        DELAY(1.0) {
//                            self.list.scrollToBottom()
//                        }
                        
                        if(self.topic == "ai") {
                            self.controversies = []
                            self.controversiesPage = 1
                            self.controversiesTotal = 0
                            self.loadControversies()
                        }
                        
                    }
                }
            }
        }
    }
    
    func loadControversies() {
        // For now, only for the "ai" topic
        self.showLoading()
        ControversiesData.shared.loadListForFeed(topic: self.topic, page: self.controversiesPage) { (error, list, total) in
            self.hideLoading()
            
            if let _ = error {
                NOTHING()
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _T = total, let _L = list {
                        
                        for LI in _L {
                            self.controversies.append(LI)
                        }
                        self.controversiesTotal = _T
                        if(self.controversiesTotal > 0) {
                            self.addControversiesToMainFeed()
                        }
                    }
                }
            }
        }
    }
    
    func removeControversiesFromMainFeed() {
        var topicIndex = -1
        
        for (i, DP) in self.dataProvider.enumerated() {
            if let _DP = DP as? DP3_headerItem, _DP.title.lowercased() != "split" {
                topicIndex += 1
            }
            
            if(topicIndex==0 && DP is DP3_more) {
                for _ in 1...100 {
                    let _i = i+1
                    if(_i < self.dataProvider.count) {
                        if let _header = self.dataProvider[_i] as? DP3_headerItem {
                            if(_header.title != "-----" && _header.title != self.latestControversies) {
                                break
                            }
                        }
                        
                        self.dataProvider.remove(at: _i)
                    }
                }
                
                break
            }
        }
    }
    
    func addControversiesToMainFeed(mustRefresh: Bool = true) {
        var topicIndex = -1
                
        for (i, DP) in self.dataProvider.enumerated() {
            if let _DP = DP as? DP3_headerItem, _DP.title.lowercased() != "split" {
                topicIndex += 1
            }
            
            if(topicIndex==0) { // first topic, "ai"
                if(DP is DP3_iPhoneStory_1Wide) {
                    let CO = DP3_controversy(controversy: self.controversies.first!)
                    self.dataProvider.insert(CO, at: i+1)
                    
                    for (j, C) in self.controversies.enumerated() {
                        if(j>0) {
                            let CO = DP3_controversy(controversy: C)
                            self.dataProvider.insert(CO, at: i+4+j)
                        }
                    }
                    break
                }
            }
        }
        
        MAIN_THREAD {
            self.hideLoading()
        }
    
        if(mustRefresh) {
            self.refreshList()
        }
    }
     
    func addControversiesToMainFeed_2(mustRefresh: Bool = true) {
        var topicIndex = -1
                
        for (i, DP) in self.dataProvider.enumerated() {
            if let _DP = DP as? DP3_headerItem, _DP.title.lowercased() != "split" {
                topicIndex += 1
            }
            
            if(topicIndex==0 && DP is DP3_more) {
                let line = DP3_headerItem(title: "-----")
                self.dataProvider.insert(line, at: i+1)
//                let spacer0 = DP3_spacer(size: 20)
//                DPCopy.insert(spacer0, at: i+1)
            
                let header = DP3_headerItem(title: self.latestControversies)
                self.dataProvider.insert(header, at: i+2)
                
                var offset = 3
                for LI in self.controversies {
                    let CO = DP3_controversy(controversy: LI)
                    self.dataProvider.insert(CO, at: i+offset)
                    
                    offset += 1
                }
                
                let spacer1 = DP3_spacer(size: 20)
                self.dataProvider.insert(spacer1, at: i+offset)
                
                if(self.controversies.count < self.controversiesTotal) {
                    offset += 1
                    let more = DP3_more(topic: "CONTRO", completed: false)
                    self.dataProvider.insert(more, at: i+offset)
                    
                    offset += 1
                    let spacer2 = DP3_spacer(size: 35)
                    self.dataProvider.insert(spacer2, at: i+offset)
                }
                
                break
            }
        }
        
        MAIN_THREAD {
            self.hideLoading()
        }
    
        if(mustRefresh) {
            self.refreshList()
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

}

extension MainFeed_v3_viewController: UIScrollViewDelegate {
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _posY = scrollView.contentOffset.y
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) { // UP
            if(self.navBar.isHidden && !self.topBarsTransitioning) {
                self.showTopBars()
            }
        } else { // DOWN
            if(_posY >= 70) {
                if(!self.navBar.isHidden && !self.topBarsTransitioning) {
                    self.hideTopBars()
                }
            }
        }
    }
    
//    func scrollViewDidScroll_2(_ scrollView: UIScrollView) {
//        if(scrollView != self.list) {
//            return
//        }
//        
//        let _posY = scrollView.contentOffset.y
//        let diff = self.lastScrollViewPosY - _posY
//        let currentPosY = _posY
//        
//        if(diff < 0) {
//            // up
//            if(currentPosY >= 70) {
//                if(!self.navBar.isHidden && !self.topBarsTransitioning) {
//                    self.hideTopBars()
//                    //saveLastPos = false
//                }
//            }
//        } else {
//            // down
//            if(self.navBar.isHidden && !self.topBarsTransitioning) {
//                self.showTopBars()
//            }
//        }
//        
//        self.lastScrollViewPosY = currentPosY
//    }
    
    func hideTopBars() {
        if(!self.topBarsTransitioning) {
            self.topBarsTransitioning = true
            
            //self.listTopConstraint?.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.navBar.alpha = 0
                self.topicSelector.alpha = 0
                //self.view.layoutIfNeeded()
            } completion: { _ in
                self.navBar.hide()
                self.topicSelector.hide()
                
                self.topBarsTransitioning = false
            }
        }
    }
    
    func showTopBars() {
        if(!self.topBarsTransitioning) {
            self.topBarsTransitioning = true
            
            self.navBar.show()
            self.topicSelector.show()
            //self.listTopConstraint?.constant = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
            UIView.animate(withDuration: 0.2) {
                self.navBar.alpha = 1
                self.topicSelector.alpha = 1
                //self.view.layoutIfNeeded()
            } completion: { _ in
                self.topBarsTransitioning = false
            }
        }
    }
    
}
