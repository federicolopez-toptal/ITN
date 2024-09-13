//
//  MainFeed_v3_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit

extension MainFeed_v3_viewController {

    // main POPULATE
    func populateDataProvider() {
        if(Layout.current() == .textImages) {
            self.populateDataProvider_iPhone_textImages()
        } else {
            self.populateDataProvider_iPhone_textOnly()
        }

        // -------------------------------------------------
        let topSpacerHeight = self.topValue - self.safeAreaTop
        let initSpacer = DP3_spacer(size: topSpacerHeight)
        self.dataProvider.insert(initSpacer, at: 0)
    }
    
    // Text & Images
    private func populateDataProvider_iPhone_textImages() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            //var _T = self.data.topics[i]
            var _T: MainFeedTopic!
            if(i<self.data.topics.count) {
                _T = self.data.topics[i]
            } else {
                continue
            }
            
            if(_T.name == "ai" && self.topic != "ai") {
                continue
            }
            
            var itemInTopic = 0
            while(_T.hasNewsAvailable()) {
            
            // Headers
                if(itemInTopic == 0) {
                    self.addHeader(text: _T.capitalizedName)
                    itemInTopic += 1
                }
                
                var newGroupItem: DP3_groupItem?
                
                switch(itemInTopic) {
                    case 1:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                        
                    case 2, 4, 5:
                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                
                    case 3, 6, 7:
                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
                
//                    case 1, 2, 5:
//                        if(_T.stillHasStories()) {
//                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
//                        } else {
//                            itemInTopic += 1
//                        }
//                    case 3, 4, 9, 10:
//                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
//                    case 6, 7, 8:
//                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                
                    default:
                        NOTHING()
                }
                
                ///////// fill "newGroupItem"
                if let _newGroupItem = newGroupItem {
                    for j in 1..._newGroupItem.MaxNumOfItems {
                        let storyFlag = _newGroupItem.storyFlags[j-1]
                        if let _A = _T.nextAvailableArticle(isStory: storyFlag) {
                            _newGroupItem.articles.append(_A)
                            self.data.addCountTo(topic: _T.name)
                        } else {
                            break
                        }
                    }
                
                    // Sepatator (if apply)
                    if(self.itemHas2Cols(item: newGroupItem!)) {
                        if let _lastItem = self.dataProvider.last, self.itemHas2Cols(item: _lastItem as! DP3_groupItem) {
                            let sep = DP3_lineSeparator(type: 2)
                            self.dataProvider.append(sep)
                        }
                    }
                                      
                    self.dataProvider.append(_newGroupItem)
                    itemInTopic += 1
                } // fill ///////////////////
                
                
                if(itemInTopic==8) {
                    itemInTopic = 4
                }
                
                
            } // while
            
            // Banner, only for 1rst topic (if apply)
            if(i==0) { self.insertNewBanner() }

            // "Load more" item
            self.addLoadMore(topicName: _T.name)
            
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    private func itemHas2Cols(item: DP3_groupItem) -> Bool {
        var result = false
        if( (item is DP3_iPhoneStory_2cols) || (item is DP3_iPhoneArticle_2cols) ) {
            result = true
        }
        
        return result
    }
    
    // Text only
    private func populateDataProvider_iPhone_textOnly() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            //var _T = self.data.topics[i]
            var _T: MainFeedTopic!
            if(i<self.data.topics.count) {
                _T = self.data.topics[i]
            } else {
                continue
            }
            
            if(_T.name == "ai" && self.topic != "ai") {
                continue
            }
            
            var itemInTopic = 0
            while(_T.hasNewsAvailable()) {
            
            // Headers
                if(itemInTopic == 0) {
                    self.addHeader(text: _T.capitalizedName)
                    itemInTopic += 1
                }
                
                var newGroupItem: DP3_groupItem?
                
                switch(itemInTopic) {
                    case 1:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                        
                    case 2, 4, 5:
                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                
                    case 3, 6, 7:
                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
                
//                    case 1, 2, 5:
//                        if(_T.stillHasStories()) {
//                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
//                        } else {
//                            itemInTopic += 1
//                        }
//                    case 3, 4, 9, 10:
//                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
//                    case 6, 7, 8:
//                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                        
                    default:
                        NOTHING()
                }
                
                ///////// fill "newGroupItem"
                if let _newGroupItem = newGroupItem {
                    for j in 1..._newGroupItem.MaxNumOfItems {
                        let storyFlag = _newGroupItem.storyFlags[j-1]
                        if let _A = _T.nextAvailableArticle(isStory: storyFlag) {
                            _newGroupItem.articles.append(_A)
                            self.data.addCountTo(topic: _T.name)
                        } else {
                            if let _A = _T.nextAvailableArticle(isStory: !storyFlag) {
                                _newGroupItem.articles.append(_A)
                                self.data.addCountTo(topic: _T.name)
                            } else {
                                break
                            }
                        }
                    }
                       
                    // Sepatator (if apply)
                    if(self.itemHas2Cols(item: newGroupItem!)) {
                        if let _lastItem = self.dataProvider.last, self.itemHas2Cols(item: _lastItem as! DP3_groupItem) {
                            let sep = DP3_lineSeparator(type: 2)
                            self.dataProvider.append(sep)
                        }
                    }
                       
                    self.dataProvider.append(_newGroupItem)
                    itemInTopic += 1
                } // fill ///////////////////
                
                
                if(itemInTopic==8) {
                    itemInTopic = 4
                }
                
            } // while
            
            //Banner, only for 1rst topic (if apply)
            if(i==0) { self.insertNewBanner() }

            // "Load more" item
            self.addLoadMore(topicName: _T.name)
            
        } // for
        
        //Footer at the end of all
        self.addFooter()

    }
}

// MARK: DataProvider aux methods
extension MainFeed_v3_viewController {
    
    private func addHeader(text: String) {
        if(self.dataProvider.count > 0) {
            let sep = DP3_lineSeparator(type: 1)
            self.dataProvider.append(sep)
        }

        let header = DP3_headerItem(title: text)
        self.dataProvider.append(header)
    }
    
    private func insertNewBanner() {
        // chequeos previos...
            // El orden es podcast, youtube, newsletter (ver si se puede saltear youtube)
        
        if(MUST_SPLIT() == 0) { // Already in the first topic...
            if let _banner = self.data.banner {
                if(_banner.isPodcast()) {
                    for (i, item) in self.dataProvider.enumerated() {
                        if let _item = item as? DP3_iPhoneArticle_2cols, let _article = _item.articles.first {
                            // Replace article with podcast banner
                            var A = _article
                            A.title = Banner.DEFAULT_TITLE
                            (self.dataProvider[i] as! DP3_iPhoneArticle_2cols).articles[0] = A
                            
                            break
                        }
                    }
                } else if(_banner.isNewsLetter()) {
                    let spacerAtTop = DP3_spacer(size: 10) // Space before the "Show more"
                    self.dataProvider.append(spacerAtTop)
                    
                    let banner = DP3_banner()
                    self.dataProvider.append(banner)
                    
                    let spacerToBottom = DP3_spacer(size: 24) // Space after the "Show more"
                    self.dataProvider.append(spacerToBottom)
                }
            }
        }
        
        if(self.data.banner != nil && MUST_SPLIT()==0) {
            
        
//            let spacerAtTop = DP3_spacer(size: 10) // Space before the "Show more"
//            self.dataProvider.append(spacerAtTop)
//            
//            let banner = DP3_banner()
//            self.dataProvider.append(banner)
//            
//            let spacerToBottom = DP3_spacer(size: 24) // Space after the "Show more"
//            self.dataProvider.append(spacerToBottom)
        }
    }
    
    private func addLoadMore(topicName: String) {
        var isCompleted = false
        if let _ = self.topicsCompleted[topicName] {
            isCompleted = true
        }
        let loadMore = DP3_more(topic: topicName, completed: isCompleted)
        self.dataProvider.append(loadMore)
    }
    
    private func addFooter() {
        let spacer = DP3_spacer(size: 15)
        self.dataProvider.append(spacer)
    
        let footer = DP3_footer()
        self.dataProvider.append(footer)
    }
    
}
