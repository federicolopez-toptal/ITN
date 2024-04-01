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
    
    var listTopConstraint: NSLayoutConstraint? = nil
    var lastScrollViewPosY: CGFloat = 0
    var topBarsTransitioning = false
    
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
            
            self.setupList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
            
            DELAY(0.25) {
                let vc = ControversiesViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
            //CustomNavController.shared.menu.presentPreferences() //!!!
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

}

extension MainFeed_v3_viewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var saveLastPos = true
        let currentPosY = scrollView.contentOffset.y
        let diff = self.lastScrollViewPosY - currentPosY
        
        if(diff < 0) {
            // up
            if(currentPosY >= 150) {
                if(!self.navBar.isHidden) {
                    self.hideTopBars()
                    saveLastPos = false
                }
            }
        } else {
            // down
            if(self.navBar.isHidden) {
                self.showTopBars()
            }
        }
        
        if(saveLastPos) {
            self.lastScrollViewPosY = currentPosY
        }
    }
    
    func hideTopBars() {
        if(!self.topBarsTransitioning) {
            self.topBarsTransitioning = true
            
            self.listTopConstraint?.constant = 0
            UIView.animate(withDuration: 0.5) {
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
            self.listTopConstraint?.constant = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
            UIView.animate(withDuration: 0.5) {
                self.navBar.alpha = 1
                self.topicSelector.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.topBarsTransitioning = false
            }
        }
    }
    
}
