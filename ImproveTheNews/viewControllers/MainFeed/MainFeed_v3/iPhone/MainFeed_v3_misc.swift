//
//  MainFeed_v3_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit


// MARK: - miscs/utils
extension MainFeed_v3_viewController {

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
    
    func imFirstViewController() -> Bool {
        var result = false
        if let _first = CustomNavController.shared.viewControllers.first {
            if(_first == self) { result = true }
        }

        return result
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

// MARK: - Notifications
extension MainFeed_v3_viewController {

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onStanceIconTap),
            name: Notification_stanceIconTap, object: nil)
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.loadDataFromNotification),
            name: Notification_reloadMainFeed, object: nil)
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.setReloadMainFeedOnShow),
            name: Notification_reloadMainFeedOnShow, object: nil)
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.removeBannerFromNotification),
            name: Notification_removeBanner, object: nil)
            
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.refreshList),
            name: Notification_refreshMainFeed, object: nil)
    }
    
    @objc func onStanceIconTap(_ notification: Notification) {
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
        }
    }
    
    @objc func loadDataFromNotification(_ notification: Notification) {
        self.loadData(showLoading: true)
    }
    
    @objc func setReloadMainFeedOnShow() {
        self.mustReloadOnShow = true
    }
    
    @objc func removeBannerFromNotification() {
        for (i, dpObj) in self.dataProvider.enumerated() {
            if(dpObj is DP3_banner) {
                self.bannerClosed = true
                self.dataProvider.remove(at: i)
                break
            }
        }
        
        self.refreshList()
    }
    
}

// MARK: UIGestureRecognizerDelegate (To swipe the view BACK)
extension MainFeed_v3_viewController: UIGestureRecognizerDelegate {
  
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}

// MARK: - TopicSelectorViewDelegate
extension MainFeed_v3_viewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        if(index==0) {
            self.list.scrollToTop()
        } else {
            let vc = MainFeed_v3_viewController()
            let topic = self.data.topics[index].name
            vc.topic = topic
            
            CustomNavController.shared.tour_old?.cancel()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - CustomFeedListDelegate (List - Pull to Refresh)
extension MainFeed_v3_viewController: CustomFeedListDelegate {

    func feedListOnRefreshPulled(sender: CustomFeedList) {
        self.loadData(showLoading: false)
    }
    
    func feedListOnScrollToTop(sender: CustomFeedList) {
        DELAY(1.0) {
            self.showTopBars()
        }
    }
    
}
