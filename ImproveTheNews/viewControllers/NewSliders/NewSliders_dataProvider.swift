//
//  NewSliders_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit

extension NewSlidersViewController {

    func populateDataProvider() {
        if(IPHONE()) {
            if(MUST_SPLIT_B() == 0) {
                self.populateDataProvider_iPhone_plain() // iPhone - Images & Texts
            } else {
                self.populateDataProvider_iPhone_split() // iPhone - Images & Texts + Split
            }
        } else {
            if(MUST_SPLIT_B() == 0) {
                self.populateDataProvider_iPad_plain() // iPad - Images & Texts
            } else {
                self.populateDataProvider_iPhone_split() // iPad - Images & Texts + Split
            }
        }
    }
    
    func populateDataProvider_iPhone_split() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        var _T: MainFeedTopic!
        self.addShownTopic()
        
        if(self.data.topics.first != nil) {
            _T = self.data.topics.first!
            
        // Articles sorting/filtering  ---------------------------
            var articlesLeft = [MainFeedArticle]()
            var articlesRight = [MainFeedArticle]()
        
            while(_T.stillHasArticles()) {
                if let _A = _T.nextAvailableArticle(isStory: false) {
                    if(MUST_SPLIT_B() == 1) {
                        if(_A.LR < 3) {
                            articlesLeft.append(_A)
                        } else {
                            articlesRight.append(_A)
                        }
                        self.data.addCountTo(topic: _T.name)
                    } else if(MUST_SPLIT_B() == 2) {
                        if(_A.PE < 3) {
                            articlesLeft.append(_A)
                        } else {
                            articlesRight.append(_A)
                        }
                        self.data.addCountTo(topic: _T.name)
                    }
                } else {
                    break
                }
            }
            
        // Split headers --------------------------------------------
            var _L = "LEFT"
            var _R = "RIGHT"
            if(MUST_SPLIT_B() == 2) {
                _L = "CRITICAL"
                _R = "PRO"
            }
            
            self.addSplitHeaders(L: _L, R: _R)
        // Add Articles -------------------------------------------
            while(articlesLeft.count>0 || articlesRight.count>0) {
                let newGroupItem = DP3_iPhoneArticle_2cols()
                        
                if let _leftArt = articlesLeft.first {
                    newGroupItem.articles.append(_leftArt)
                    articlesLeft.removeFirst()
                } else {
                    newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 1) )
                }
                
                if let _rightArt = articlesRight.first {
                    newGroupItem.articles.append(_rightArt)
                    articlesRight.removeFirst()
                } else {
                    newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 5) )
                }
                                
                self.dataProvider.append(newGroupItem)
            }
        
        // ------------------------------------------------------
        }
        
        self.addLoadMore(topicName: _T.name)
    }
    
    func populateDataProvider_iPhone_plain() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        var _T: MainFeedTopic!
        self.addShownTopic()
        
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
    
    func populateDataProvider_iPad_plain() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        var _T: MainFeedTopic!
        self.addShownTopic()
        
        if(self.data.topics.first != nil) {
            _T = self.data.topics.first!
            
            while(_T.hasNewsAvailable()) {
                let newGroupItem = DP3_iPhoneArticle_4cols()
                
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
    
    private func addShownTopic() {
        let textItem = DP3_text(text: "All")
        self.dataProvider.append(textItem)
    }
    
    private func addSplitHeaders(L: String, R: String) {
        let splitHeader = DP3_splitHeaderItem(leftTitle: L, rightTitle: R)
        self.dataProvider.append(splitHeader)
    }

}
