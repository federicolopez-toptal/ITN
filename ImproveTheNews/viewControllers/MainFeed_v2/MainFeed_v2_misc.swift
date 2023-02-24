//
//  MainFeed_v2_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation
import UIKit


// MARK: - Notifications
extension MainFeed_v2ViewController {

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
    }

    @objc func setReloadMainFeedOnShow() {
        self.mustReloadOnShow = true
    }

    @objc func loadDataFromNotification(_ notification: Notification) {
        self.loadData(showLoading: true)
    }

    @objc func onStanceIconTap(_ notification: Notification) {
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

}

// MARK: - miscs/utils
extension MainFeed_v2ViewController {
    
    
    
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
    
}

// MARK: UI
extension MainFeed_v2ViewController {
    
    func scrollToZero() {
        self.list.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func startTour() {
        MAIN_THREAD {
            CustomNavController.shared.slidersPanel.makeSureIsClosed()
            CustomNavController.shared.slidersPanel.forceSplitOff()
        
            let tour = TourView(buildInto: CustomNavController.shared.view)
            tour.start()
        }
    }
    
}

// MARK: To swipe BACK
extension MainFeed_v2ViewController: UIGestureRecognizerDelegate {
  
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}

// MARK: - Topic selector
extension MainFeed_v2ViewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        if(index==0) {
            self.scrollToZero()
        } else {
            let vc = MainFeed_v2ViewController()
            let topic = self.data.topics[index].name
            vc.topic = topic
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - List/Pull to Refresh
extension MainFeed_v2ViewController: CustomFeedListDelegate {
    func feedListOnRefreshPulled(sender: CustomFeedList) {
        self.loadData(showLoading: false)
    }
}


