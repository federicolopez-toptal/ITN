//
//  MainFeediPad_v3_viewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit


class MainFeediPad_v3_viewController: BaseViewController {
    
    //let tabsBar = TabsBar.customInit()
    
    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()
    var list = CustomFeedList()
    
    var topic = "news"
    let data = MainFeedv5_iPad()
    var dataProvider = [DP3_item]()
    
    var topicsCompleted = [String: Bool]()
    var prevMustSplit: Int?
    var mustReloadOnShow = false
    var bannerClosed = false

    // ----------------------------
    var topValue: CGFloat = -1
    var listAdded = false
    var middleIndexPath: IndexPath?

    var lastScrollViewPosY: CGFloat = 0
    var topBarsTransitioning = false

    var controversies = [ControversyListItem]()
    var controversiesTotal = 0
    var controversiesPage = 1
    let latestControversies = "Latest controversies"

    var safeAreaTop: CGFloat = 0


    
    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.preferencesSetDefaultValues()
        self.addNotificationObservers()
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
            
            self.setupList()
            //self.tabsBar.buildInto(viewController: self)
            
            if let _safeAreaTop = SAFE_AREA()?.top {
                self.list.setRefresher_yOffset(_safeAreaTop)
                self.safeAreaTop = _safeAreaTop
            }
            
//            self.navBar.alpha = 0.25
//            self.topicSelector.alpha = 0.25
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeywordSearch.searchTerm = nil
        
        if(!self.didAppear) {
//            CustomNavController.shared.tour.start()
        
            self.didAppear = true
            self.loadData()

//            DELAY(0.5) {
//                let vc = NewsLetterContentViewController()
//                vc.refData = NewsLetterStory(type: 1)
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }
    
//            DELAY(0.5) {
//                let vc = FigureDetailsViewController()
//                vc.slug = "elon-musk"
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }

//            DELAY(0.5) {
//                let vc = AccountViewController()
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.loadData(showLoading: true)
            CustomNavController.shared.menu.changeLayoutFromStoredValue()
            CustomNavController.shared.menu.changeDisplayModeFromStoredValue()
        }
        
//        DELAY(1.0) {
//            CustomNavController.shared.hidePanelAndButtonWithAnimation()
//            let vc = PreferencesViewController()
//            CustomNavController.shared.pushViewController(vc, animated: true)
//        }

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
extension MainFeediPad_v3_viewController {
    
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
                        
                        // TOUR
                        if(READ(LocalKeys.preferences.onBoardingShow)==nil) {
                            WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
                            CustomNavController.shared.tour.start()
                        }
                        
//                        DELAY(0.25) {   
//                            let vc = FigureDetailsViewController()
//                            vc.slug = "elon-musk"
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
                for j in 1...100 {
                    let _i = i+1
                    if(_i < self.dataProvider.count) {
                        if let _header = self.dataProvider[i+1] as? DP3_headerItem {
                            if(_header.title != "-----" && _header.title != self.latestControversies) {
                                break
                            }
                        }
                        
                        self.dataProvider.remove(at: i+1)
                    }
                }
                
                break
            }
        }
    }
    
    func addControversiesToMainFeed(mustRefresh: Bool = true) {
        let upperBound = self.controversies.count-1
        if(upperBound < 0) {
            return
        }
        
        var topicIndex = -1
        
        for (i, DP) in self.dataProvider.enumerated() {
            if let _DP = DP as? DP3_headerItem, _DP.title.lowercased() != "split" {
                topicIndex += 1
            }
            
            if(topicIndex==0) { // first topic, "ai"
                if(DP is DP3_iPad5items) {
                    /* */
                    var count = 1
                    var offset = 0
                    for j in 0...upperBound {

                        var li1: ControversyListItem? = nil
                        var li2: ControversyListItem? = nil

                        if(count==1) {
                            if(j==self.controversies.count-1) {
                                li1 = self.controversies[j]
                                li2 = nil
                            }
                        } else if(count==2) {
                            li1 = self.controversies[j-1]
                            li2 = self.controversies[j]
                        }

                        if(li1 != nil) {
                            let CO = DP3_controversies_x2(controversy1: li1!, controversy2: li2)
                            self.dataProvider.insert(CO, at: i+1+offset)
                            offset += 1
                        }

                        count += 1
                        if(count==3) { count=1 }
                    }
                    /* */
                    break
                }
                
//                let spacer1 = DP3_spacer(size: 20)
//                self.dataProvider.insert(spacer1, at: i+offset)
//                
//                if(self.controversies.count < self.controversiesTotal) {
//                    offset += 1
//                    let more = DP3_more(topic: "CONTRO", completed: false)
//                    self.dataProvider.insert(more, at: i+offset)
//                    
//                    offset += 1
//                    let spacer2 = DP3_spacer(size: 35)
//                    self.dataProvider.insert(spacer2, at: i+offset)
//                }
                
                
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

extension MainFeediPad_v3_viewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let _rows = self.list.indexPathsForVisibleRows, let _rowA = _rows.first, let _rowZ = _rows.last {
            let middleRow = (_rowA.row + _rowZ.row)/2
            self.middleIndexPath = IndexPath(row: middleRow, section: 0)
        }

        self.setupList()
//        self.tabsBar.buildInto(viewController: self)
        CustomNavController.shared.tour.rotate()
        
        // Header
        DELAY(0.2) {
            self.navBar.alpha = 1.0
            self.navBar.show()
            
            self.topicSelector.alpha = 1.0
            self.topicSelector.show()
        }
    }

}

extension MainFeediPad_v3_viewController: UIScrollViewDelegate {
    
    
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var saveLastPos = true
//        let currentPosY = scrollView.contentOffset.y
//        let diff = self.lastScrollViewPosY - currentPosY
//        
//        if(diff < 0) {
//            // up
//            if(currentPosY >= 70) {
//                if(!self.navBar.isHidden) {
//                    self.hideTopBars()
//                    saveLastPos = false
//                }
//            }
//        } else {
//            // down
//            if(self.navBar.isHidden) {
//                self.showTopBars()
//            }
//        }
//        
//        if(saveLastPos) {
//            self.lastScrollViewPosY = currentPosY
//        }
//    }
    
    func hideTopBars() {
        if(!self.topBarsTransitioning) {
            self.topBarsTransitioning = true
            
            //self.listTopConstraint?.constant = 0
            UIView.animate(withDuration: 0.4) {
                self.navBar.alpha = 0
                self.topicSelector.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.topBarsTransitioning = false
                
                self.navBar.hide()
                self.topicSelector.hide()
            }
        }
    }
    
    func showTopBars() {
        if(!self.topBarsTransitioning) {
            self.topBarsTransitioning = true
            
            self.navBar.show()
            self.topicSelector.show()
            //self.listTopConstraint?.constant = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
            UIView.animate(withDuration: 0.4) {
                self.navBar.alpha = 1
                self.topicSelector.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.topBarsTransitioning = false
            }
        }
    }
    
}
