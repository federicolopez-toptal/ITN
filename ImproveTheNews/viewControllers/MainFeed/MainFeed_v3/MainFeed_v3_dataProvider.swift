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
        if(Layout.current() == .textImages) {
            if(MUST_SPLIT() == 0) {
                self.populateDataProvider_iPhone_textImages()
            } else {
                self.populateDataProvider_iPhone_textImages_split()
            }
        } else {
            if(MUST_SPLIT() == 0) {
                self.populateDataProvider_iPhone_textOnly()
            } else {
                self.populateDataProvider_iPhone_textOnly_split()
            }
        }
    }
    
    private func populateDataProvider_iPhone_textOnly_split() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            // "Header" item
            let header = DP3_headerItem(title: _T.capitalizedName)
            self.dataProvider.append(header)
            
            let splitHeader = DP3_splitHeaderItem()
            self.dataProvider.append(splitHeader)
            
            var articlesLeft = [MainFeedArticle]()
            var articlesRight = [MainFeedArticle]()
            
        // Articles sorting  ----------------------------------
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
            
            let total = _T.articles.count
            var artCount = 0
            while(artCount<total) {
                var storyRows = 0
                var articleRows = 0
                // Articles -------------------------------------------
                    while(articleRows<4 && (articlesLeft.count>0 || articlesRight.count>0)) {
                        let newGroupItem = DP3_iPhoneArticleSplit_2colsTxt()
                        
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
                    }
                    articleRows = 0
                    
                // Stories -----------------------------------
                    if(_T.stillHasStories()) {
                        let spacer = DP3_spacer(size: 20)
                        self.dataProvider.append(spacer)
                    }
                    
                    while(_T.stillHasStories() || storyRows<4) {
                        if let _ST = _T.nextAvailableArticle(isStory: true) {
                            let newGroupItem = DP3_iPhoneStory_vTxt()
                            newGroupItem.articles.append(_ST)
                            self.data.addCountTo(topic: _T.name)
                            artCount += 1
                            self.dataProvider.append(newGroupItem)
                            storyRows += 1
                        } else {
                            break
                        }
                    }
                // -------------------------------------------
            }
        
            // "Load more" item
            var isCompleted = false
            if let _ = self.topicsCompleted[_T.name] {
                isCompleted = true
            }
            let loadMore = DP3_more(topic: _T.name, completed: isCompleted)
            self.dataProvider.append(loadMore)
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    private func populateDataProvider_iPhone_textImages_split() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            // "Header" item
            let header = DP3_headerItem(title: _T.capitalizedName)
            self.dataProvider.append(header)
            
            let splitHeader = DP3_splitHeaderItem()
            self.dataProvider.append(splitHeader)
            
            var articlesLeft = [MainFeedArticle]()
            var articlesRight = [MainFeedArticle]()
            
        // Articles sorting  ----------------------------------
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
            
            let total = _T.articles.count
            var artCount = 0
            while(artCount<total) {
                var storyRows = 0
                var articleRows = 0
                // Articles -------------------------------------------
                    while(articleRows<4 && (articlesLeft.count>0 || articlesRight.count>0)) {
                        let newGroupItem = DP3_iPhoneArticleSplit_2colsImg()
                        
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
                    }
                    
                    //articleRows = 0
                // Stories -----------------------------------
                    if(_T.stillHasStories()) {
                        let spacer = DP3_spacer(size: 20)
                        self.dataProvider.append(spacer)
                    }
                
                    while(_T.stillHasStories() && storyRows<4) {
                        if let _ST = _T.nextAvailableArticle(isStory: true) {
                            let newGroupItem = DP3_iPhoneStory_vTxt()
                            newGroupItem.articles.append(_ST)
                            self.data.addCountTo(topic: _T.name)
                            artCount += 1
                            self.dataProvider.append(newGroupItem)
                            storyRows += 1
                        } else {
                            break
                        }
                    }
                // -------------------------------------------
            }
        
            // "Load more" item
            var isCompleted = false
            if let _ = self.topicsCompleted[_T.name] {
                isCompleted = true
            }
            let loadMore = DP3_more(topic: _T.name, completed: isCompleted)
            self.dataProvider.append(loadMore)
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    private func populateDataProvider_iPhone_textImages() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            var itemInTopic = 0
            while(_T.hasNewsAvailable()) {
            
                if(itemInTopic == 0) {
                    // "Header" item
                    let header = DP3_headerItem(title: _T.capitalizedName)
                    self.dataProvider.append(header)
                    itemInTopic += 1
                }
                
                var newGroupItem: DP3_groupItem?
                
                switch(itemInTopic) {
                    case 1, 2, 5:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_vImg() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                    case 3, 4, 9, 10:
                        newGroupItem = DP3_iPhoneArticle_2colsImg() // Row: 2 articles
                    case 6, 7, 8:
                        newGroupItem = DP3_iPhoneStory_2colsImg() // Row: 2 stories
                
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
                
                    // Extra spacer(s)
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneStory_vImg && _newGroupItem is DP3_iPhoneArticle_2colsImg) {
                            let spacer = DP3_spacer(size: 10)
                            self.dataProvider.append(spacer)
                        }
                    }
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneArticle_2colsImg && _newGroupItem is DP3_iPhoneStory_vImg) {
                            let spacer = DP3_spacer(size: 20)
                            self.dataProvider.append(spacer)
                        }
                    }
                    if let _last = self.dataProvider.last {
                        if(_last is DP3_iPhoneStory_vImg && _newGroupItem is DP3_iPhoneStory_2colsImg) {
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
            if(i==0) {
                self.insertBanner()
            }

            // "Load more" item
            var isCompleted = false
            if let _ = self.topicsCompleted[_T.name] {
                isCompleted = true
            }
            let loadMore = DP3_more(topic: _T.name, completed: isCompleted)
            self.dataProvider.append(loadMore)
            
        } // for
        
        //Footer at the end of all
        self.addFooter()
    }
    
    private func populateDataProvider_iPhone_textOnly() {
        self.data.resetCounting()
        self.dataProvider = [DP3_item]()
        
        if(self.data.topic.count==0) { return }
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            var itemInTopic = 0
            while(_T.hasNewsAvailable()) {
            
                if(itemInTopic == 0) {
                    // "Header" item
                    let header = DP3_headerItem(title: _T.capitalizedName)
                    self.dataProvider.append(header)
                    itemInTopic += 1
                }
                
                var newGroupItem: DP3_groupItem?
                
                switch(itemInTopic) {
                    case 1, 2, 5:
                        if(_T.stillHasStories()) {
                            newGroupItem = DP3_iPhoneStory_vTxt() // Story, VImage
                        } else {
                            itemInTopic += 1
                        }
                    case 3, 4, 9, 10:
                        newGroupItem = DP3_iPhoneArticle_2colsTxt() // Row: 2 articles
                    case 6, 7, 8:
                        newGroupItem = DP3_iPhoneStory_2colsTxt() // Row: 2 stories
                        
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
            if(i==0) { self.insertBanner() }

            // "Load more" item
            var isCompleted = false
            if let _ = self.topicsCompleted[_T.name] {
                isCompleted = true
            }
            let loadMore = DP3_more(topic: _T.name, completed: isCompleted)
            self.dataProvider.append(loadMore)
            
        } // for
        
        //Footer at the end of all
        self.addFooter()

    }
    
    private func insertBanner() {
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
    
    private func addFooter() {
        let spacer = DP3_spacer(size: 15)
        self.dataProvider.append(spacer)
    
        let footer = DP3_footer()
        self.dataProvider.append(footer)
    }
}
