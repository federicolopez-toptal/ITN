//
//  NewSliders_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit

extension NewSlidersViewController {

    func populateDataProvider() {
        self.populateDataProvider_iPhone_images()
    
    
//        if(Layout.current() == .textImages) {
////            if(MUST_SPLIT() == 0) {
//                self.populateDataProvider_iPhone_textImages()
////            } else {
////                self.populateDataProvider_iPhone_textImages_split()
////                self.splitFix()
////            }
//        } else {
////            if(MUST_SPLIT() == 0) {
//                self.populateDataProvider_iPhone_textOnly()
////            } else {
////                self.populateDataProvider_iPhone_textOnly_split()
////                self.splitFix()
////            }
//        }
    }
    
    func populateDataProvider_iPhone_images() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        var _T: MainFeedTopic!
        
        if(self.data.topics.first != nil) {
            _T = self.data.topics.first!
            
            while(_T.hasNewsAvailable()) {
                let newGroupItem = DP3_iPhoneArticle_2cols()
                
                for _ in 1...newGroupItem.MaxNumOfItems {
                    if let _A = _T.nextAvailableArticle(isStory: false) {
                        newGroupItem.articles.append(_A)
                        self.data.addCountTo(topic: _T.name)
                    } else {
                        break
                    }
                }
                
                self.dataProvider.append(newGroupItem)
            } // while
        }
        
        self.addLoadMore(topicName: _T.name)
    }
    
    private func addLoadMore(topicName: String) {
        var isCompleted = false
        if let _ = self.topicsCompleted[topicName] {
            isCompleted = true
        }
        let loadMore = DP3_more(topic: topicName, completed: isCompleted)
        self.dataProvider.append(loadMore)
    }

}
