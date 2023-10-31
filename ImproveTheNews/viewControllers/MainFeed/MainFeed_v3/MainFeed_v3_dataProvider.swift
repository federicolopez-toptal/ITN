//
//  MainFeed_v3_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit

extension MainFeed_v3_viewController {

    // --------------------------------
    func populateDataProvider() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            var itemInTopic = 1
            while(_T.hasAvailableArticles()) {
                var newGroupItem: DP3_groupItem?
                
                if(itemInTopic == 1) {
                    // "Header" item
                    let header = DP3_headerItem(title: _T.capitalizedName)
                    self.dataProvider.append(header)                    
                }
                
                // Main big story
                newGroupItem = DP3_iPhoneBigStory()
                
                ////////////////////
                if let _newGroupItem = newGroupItem {
                    for j in 1..._newGroupItem.MaxNumOfItems { // fill the "newItem"
                        let storyFlag = _newGroupItem.storyFlags[j-1]
                        if let _A = _T.nextAvailableArticle(isStory: storyFlag) {
                            _newGroupItem.articles.append(_A)
                            self.data.addCountTo(topic: _T.name)
                        } else {
                            break
                        }
                    }
                
                    self.dataProvider.append(_newGroupItem)
                    itemInTopic += 1
                }
                ////////////////////
                
                if(!_T.stillHasStories()) { // only stories for now...
                    break
                }
                
            } // while
            
//            // Banner, only for 1rst topic (if apply)
//            if(i==0) { self.insertBanner() }
//
//            // "Load more" item
//            var isCompleted = false
//            if let _ = self.topicsCompleted[_T.name] {
//                isCompleted = true
//            }
//            let loadMore = DataProviderMoreItem(topic: _T.name, completed: isCompleted)
//            self.dataProvider.append(loadMore)
            
        } // for
        
//        // Footer at the end of everything
//        let footer = DataProviderFooterItem()
//        self.dataProvider.append(footer)
        
    }
    
    private func insertBanner() {
//        var mustShow = true
//        if let _value = READ(LocalKeys.misc.bannerDontShowAgain), (_value == "1") {
//            mustShow = false
//        }
//    
//        if(self.data.banner != nil && mustShow && MUST_SPLIT()==0) {
//            let banner = DataProviderBannerItem()
//            self.dataProvider.append(banner)
//        }
    }
}
