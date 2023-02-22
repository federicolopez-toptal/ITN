//
//  MainFeed_v2_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation
import UIKit


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
    
    func scrollToZero() {
        self.list.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    // Preferences default values
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

extension MainFeed_v2ViewController: UIGestureRecognizerDelegate {
  
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}

// MARK: - Topic selector & Breadcrumbs
extension MainFeed_v2ViewController: TopicSelectorViewDelegate {

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
    
}
