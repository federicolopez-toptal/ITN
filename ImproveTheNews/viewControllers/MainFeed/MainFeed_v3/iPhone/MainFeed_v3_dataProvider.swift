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
//            if(MUST_SPLIT() == 0) {
                self.populateDataProvider_iPhone_textImages()
//            } else {
//                self.populateDataProvider_iPhone_textImages_split()
//                self.splitFix()
//            }
        } else {
//            if(MUST_SPLIT() == 0) {
                self.populateDataProvider_iPhone_textOnly()
//            } else {
//                self.populateDataProvider_iPhone_textOnly_split()
//                self.splitFix()
//            }
        }

        // -------------------------------------------------
        let topSpacerHeight = self.topValue - self.safeAreaTop
        let initSpacer = DP3_spacer(size: topSpacerHeight)
        self.dataProvider.insert(initSpacer, at: 0)
    }
    
    private func splitFix() {
        for (i, item) in self.dataProvider.enumerated() {
            if let _item = item as? DP3_headerItem, _item.title.lowercased() == "split" {
                let prevIndex = i-1
                if(prevIndex<self.dataProvider.count) {
                    let prevItem = self.dataProvider[prevIndex]
                    if(prevItem is DP3_iPhoneArticle_2cols) {
                        self.dataProvider.remove(at: i)
                        if(i<self.dataProvider.count) {
                            self.dataProvider.remove(at: i)
                        }
                    }
                }
            }
        }
        
        for (i, item) in self.dataProvider.enumerated() {
            if let _item = item as? DP3_headerItem, _item.title.lowercased() == "split" {
                let nextIndex1 = i+1
                let nextIndex2 = i+2
                let nextIndex3 = i+3
                if(nextIndex3<self.dataProvider.count) {
                    let nextItem1 = self.dataProvider[nextIndex1]
                    let nextItem2 = self.dataProvider[nextIndex2]
                    let nextItem3 = self.dataProvider[nextIndex3]
                    if(nextItem1 is DP3_splitHeaderItem && nextItem2 is DP3_spacer && nextItem3 is DP3_more) {
                        for _ in 1...3 {
                            self.dataProvider.remove(at: i)
                        }
                    }
                }
            }
        }
        
    }
    
    // Split + Text only
    private func populateDataProvider_iPhone_textOnly_split() {
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
        // main Header
            self.addHeader(text: _T.capitalizedName)
            
        // Articles sorting  ----------------------------------
            var articlesLeft = [MainFeedArticle]()
            var articlesRight = [MainFeedArticle]()
            
            while(_T.stillHasArticles()) {
                if let _A = _T.nextAvailableArticle(isStory: false) {
                    if(MUST_SPLIT() == 1) {
                        if(_A.LR < 3) {
                            articlesLeft.append(_A)
                        } else {
                            articlesRight.append(_A)
                        }
                        self.data.addCountTo(topic: _T.name)
                    } else if(MUST_SPLIT() == 2) {
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
        // ------------------------------------------------------
            let total = _T.articles.count
            var artCount = 0
            while(artCount<total) {
                var storyRows = 0
                var articleRows = 0
                // Add Stories -----------------------------------
//                    if(self.dataProvider.count>0 && _T.stillHasStories()) {
//                        let spacer = DP3_spacer(size: 20)
//                        self.dataProvider.append(spacer)
//                    }

                    while(_T.stillHasStories()) {
                        if let _ST = _T.nextAvailableArticle(isStory: true) {
                            if let _last = self.dataProvider.last, _last is DP3_iPhoneArticle_2cols {
                                let spacer = DP3_spacer(size: 20)
                                self.dataProvider.append(spacer)
                            }
                            
                            let newGroupItem = DP3_iPhoneStory_1Wide()
                            newGroupItem.articles.append(_ST)
                            self.data.addCountTo(topic: _T.name)
                            artCount += 1
                            
                            self.dataProvider.append(newGroupItem)
                            storyRows += 1
                            
                            if(storyRows==2) {
                                break
                            }
                        } else {
                            break
                        }
                    }
                    
                // Split headers --------------------------------------------
                var _L = "LEFT"
                var _R = "RIGHT"
                if(MUST_SPLIT() == 2) {
                    _L = "CRITICAL"
                    _R = "PRO"
                }
                
                self.addHeader(text: "Split")
                self.addSplitHeaders(L: _L, R: _R)
                
                // Add Articles -------------------------------------------
                    while(articlesLeft.count>0 || articlesRight.count>0) {
                        let newGroupItem = DP3_iPhoneArticle_2cols()
                        
                        if let _leftArt = articlesLeft.first {
                            newGroupItem.articles.append(_leftArt)
                            articlesLeft.removeFirst()
                            artCount += 1
                        } else {
                            newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 1) )
                        }
                        
                        if let _rightArt = articlesRight.first {
                            newGroupItem.articles.append(_rightArt)
                            articlesRight.removeFirst()
                            artCount += 1
                        } else {
                            newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 5) )
                        }
                                        
                        self.dataProvider.append(newGroupItem)
                        articleRows += 1
                        
                        if(articleRows==3){
                            break
                        }
                    }
                // -------------------------------------------
            }
        
            // "Load more" item
            let spacer = DP3_spacer(size: 20)
            self.dataProvider.append(spacer)
            self.addLoadMore(topicName: _T.name)
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    // Split + Text & Images
    private func populateDataProvider_iPhone_textImages_split() {
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
            
        // main Header
            self.addHeader(text: _T.capitalizedName)

        // Articles sorting/filtering  ---------------------------
            var articlesLeft = [MainFeedArticle]()
            var articlesRight = [MainFeedArticle]()
            
            while(_T.stillHasArticles()) {
                if let _A = _T.nextAvailableArticle(isStory: false) {
                    if(MUST_SPLIT() == 1) {
                        if(_A.LR < 3) {
                            articlesLeft.append(_A)
                        } else {
                            articlesRight.append(_A)
                        }
                        self.data.addCountTo(topic: _T.name)
                    } else if(MUST_SPLIT() == 2) {
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
            
            
        // ------------------------------------------------------
            let total = _T.articles.count
            var artCount = 0
            while(artCount<total) {
                var storyRows = 0
                var articleRows = 0
                // Add Stories -----------------------------------
//                    if(self.dataProvider.count>0 && _T.stillHasStories()) {
//                        let spacer = DP3_spacer(size: 20)
//                        self.dataProvider.append(spacer)
//                    }

                    while(_T.stillHasStories()) {
                        if let _ST = _T.nextAvailableArticle(isStory: true) {
                            if let _last = self.dataProvider.last, _last is DP3_iPhoneArticle_2cols {
                                let spacer = DP3_spacer(size: 20)
                                self.dataProvider.append(spacer)
                            }
                            
                            let newGroupItem = DP3_iPhoneStory_1Wide()
                            newGroupItem.articles.append(_ST)
                            self.data.addCountTo(topic: _T.name)
                            artCount += 1
                            
                            self.dataProvider.append(newGroupItem)
                            storyRows += 1
                            
                            if(storyRows==2) {
                                break
                            }
                        } else {
                            break
                        }
                    }
                    
                // Split headers --------------------------------------------
                var _L = "LEFT"
                var _R = "RIGHT"
                if(MUST_SPLIT() == 2) {
                    _L = "CRITICAL"
                    _R = "PRO"
                }
                
                self.addHeader(text: "Split")
                self.addSplitHeaders(L: _L, R: _R)
                    
                // Add Articles -------------------------------------------
                    while(articlesLeft.count>0 || articlesRight.count>0) {
                        let newGroupItem = DP3_iPhoneArticle_2cols()
                        
                        if let _leftArt = articlesLeft.first {
                            newGroupItem.articles.append(_leftArt)
                            articlesLeft.removeFirst()
                            artCount += 1
                        } else {
                            newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 1) )
                        }
                        
                        if let _rightArt = articlesRight.first {
                            newGroupItem.articles.append(_rightArt)
                            articlesRight.removeFirst()
                            artCount += 1
                        } else {
                            newGroupItem.articles.append( MainFeedArticle.createEmpty(defaultValue: 5) )
                        }
                                        
                        self.dataProvider.append(newGroupItem)
                        articleRows += 1
                        
                        if(articleRows==3){
                            break
                        }
                    }
                // -------------------------------------------
            }
        
            // "Load more" item
            let spacer = DP3_spacer(size: 20)
            self.dataProvider.append(spacer)
            self.addLoadMore(topicName: _T.name) // if apply
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    // Text & Images (Split off)
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
                    case 1, 2, 5:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                    case 3, 4, 9, 10:
                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
                    case 6, 7, 8:
                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                
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
                
                    // Extra spacer(s) - specific situtations
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneStory_1Wide && _newGroupItem is DP3_iPhoneArticle_2cols) {
                            let spacer = DP3_spacer(size: 10)
                            self.dataProvider.append(spacer)
                        }
                    }
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneArticle_2cols && _newGroupItem is DP3_iPhoneStory_1Wide) {
                            let spacer = DP3_spacer(size: 20)
                            self.dataProvider.append(spacer)
                        }
                    }
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneStory_1Wide && _newGroupItem is DP3_iPhoneStory_2cols) {
                            let spacer = DP3_spacer(size: 10)
                            self.dataProvider.append(spacer)
                        }
                    }
                                
                    self.dataProvider.append(_newGroupItem)
                    itemInTopic += 1
                } // fill ///////////////////
                
                
                if(itemInTopic==11) {
                    itemInTopic = 7
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
    
    // Text only (Split off)
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
                    case 1, 2, 5:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_1Wide() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                    case 3, 4, 9, 10:
                        newGroupItem = DP3_iPhoneArticle_2cols() // Row: 2 articles
                    case 6, 7, 8:
                        newGroupItem = DP3_iPhoneStory_2cols() // Row: 2 stories
                        
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
                                
                    self.dataProvider.append(_newGroupItem)
                    itemInTopic += 1
                } // fill ///////////////////
                
                
                if(itemInTopic==11) {
                    itemInTopic = 7
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
        let header = DP3_headerItem(title: text)
        self.dataProvider.append(header)
    }
    
    private func addSplitHeaders(L: String, R: String) {
        let splitHeader = DP3_splitHeaderItem(leftTitle: L, rightTitle: R)
        self.dataProvider.append(splitHeader)
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
    
    private func insertBanner() { // OLD
        var mustShow = true
        if let _value = READ(LocalKeys.misc.bannerDontShowAgain), (_value == "1") {
            mustShow = false
        }
    
        if(self.data.banner != nil && mustShow && MUST_SPLIT()==0) {
            let spacerAtTop = DP3_spacer(size: 10) // Space before the "Show more"
            self.dataProvider.append(spacerAtTop)
            
            let banner = DP3_banner()
            self.dataProvider.append(banner)
            
            let spacerToBottom = DP3_spacer(size: 24) // Space after the "Show more"
            self.dataProvider.append(spacerToBottom)
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
