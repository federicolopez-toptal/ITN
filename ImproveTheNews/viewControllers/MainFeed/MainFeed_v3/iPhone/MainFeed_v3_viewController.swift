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
    let data = MainFeedv3()
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
    
    var ignoreScroll = false
    var loadedMore = false
    
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
                self.navBar.addComponents([.logo, .menuIcon, .searchIcon, .user])
            } else {
                self.navBar.addComponents([.back, .title, .headlines])
            }
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            self.topValue = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
            self.setupList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
            
//            DELAY(2.0) {
//                let vc = ControDetailViewController()
//                vc.slug = "ai-existential-threat"
//                CustomNavController.shared.pushViewController(vc, animated: true)
//            }            
        }
        
        if(self.mustReloadOnShow) {
            self.mustReloadOnShow = false
            self.loadData(showLoading: true)
            CustomNavController.shared.slidersPanel.reloadSliderValues()
            CustomNavController.shared.slidersPanel.forceSplitToStoredValue()
            CustomNavController.shared.menu.changeLayoutFromStoredValue()
            CustomNavController.shared.menu.changeDisplayModeFromStoredValue()
        }
        
        if(CustomNavController.shared.slidersPanel.isHidden && CustomNavController.shared.floatingButton.isHidden) {
            CustomNavController.shared.slidersPanel.show(rows: 0, animated: false)
            CustomNavController.shared.showPanelAndButtonWithAnimation()
        }
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
                        
//                        // TOUR
                        if(CustomNavController.shared.showTour || READ(LocalKeys.preferences.onBoardingShow)==nil) {
                            if(CustomNavController.shared.viewControllers.first! == self) {
                                WRITE(LocalKeys.preferences.onBoardingShow, value: "YES")
                                CustomNavController.shared.startTour()
                            }
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
                        
                        self.controversies = []
                        self.controversiesPage = 1
                        self.controversiesTotal = 0
                        self.loadControversies()
                    }
                }
            }
        }
    }
    
    func loadControversies() {
        ControversiesData.shared.loadListForFeed(topic: self.topic, page: self.controversiesPage) { (error, list, total) in
            if let _ = error {
                NOTHING()
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _T = total, let _L = list {
                        self.ignoreScroll = true
                        
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
                    if let _header = self.dataProvider[i+1] as? DP3_headerItem {
                        if(_header.title != "-----" && _header.title != self.latestControversies) {
                            break
                        }
                    }
                    
                    self.dataProvider.remove(at: i+1)
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
        if(scrollView != self.list) {
            return
        }
        
        let _posY = scrollView.contentOffset.y
        let diff = self.lastScrollViewPosY - _posY
        
        if(self.ignoreScroll) {
//            self.lastScrollViewPosY = currentPosY
//            //print("ignore")
            return
        }
            
        if(self.loadedMore) {
            print(abs(_posY), diff)
        }
    
        

//        print( abs(diff) )
//        if(abs(diff)>100) {
//            print("***", diff)
//            return
//        }
            
        //var saveLastPos = true
        let currentPosY = _posY
        
        //print( Int(currentPosY), "diff \(diff)" )
        
       
        
        //print(self.lastScrollViewPosY, "-", currentPosY, "DIFF", diff)
        //print("currentPosY: \(currentPosY)", "diff: \(diff)")
        //print("DIFF", diff)
        //print(diff)
        
        if(diff < 0) {
            //print("UP")
            
            // up
            if(currentPosY >= 70) {
                if(!self.navBar.isHidden && !self.topBarsTransitioning) {
                    self.hideTopBars()
                    //saveLastPos = false
                }
            }
        } else {
            //print("DOWN")
            // down
            if(self.navBar.isHidden && !self.topBarsTransitioning) {
                self.showTopBars()
            }
        }
        
        //if(saveLastPos) {
            self.lastScrollViewPosY = currentPosY
        //}
    }
    
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
