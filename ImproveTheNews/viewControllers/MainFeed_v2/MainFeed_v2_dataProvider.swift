//
//  MainFeed_v2_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation

extension MainFeed_v2ViewController {

    


    // --------------------------------
    func populateDataProvider() {
    
        self.data.resetCounting()
        self.dataProvider = [DataProviderGroupItem]()
        
        for i in 0...self.data.topics.count-1 {
            var _T = self.data.topics[i]
            
            // Per topic...
            var itemInTopic = 1
            while(_T.hasAvailableArticles()) {
                var newGroupItem: DataProviderGroupItem!
                
                if(IPAD()) {
                    if(TEXT_IMAGES()) {
                        if(MUST_SPLIT()==0) {
                            if(itemInTopic==1) {
                                // "Header" item
                                let header = DataProviderHeaderItem(title: _T.capitalizedName)
                                self.dataProvider.append(header)
                            
                                newGroupItem = DataProvideriPadGroup_top()
                            } else {
                                newGroupItem = DataProvideriPadGroup_row()
                            }
                        } else {
                            // SPLIT
                            if(itemInTopic==1) {
                                // "Header" (topic)
                                let header = DataProviderHeaderItem(title: _T.capitalizedName)
                                self.dataProvider.append(header)
                                
                                // "Header" (split)
                                let splitHeader = DataProviderSplitHeaderItem()
                                self.dataProvider.append(splitHeader)
                            }
                            
                            newGroupItem = iPadGroupItem_split()
                            
//                            if(itemInTopic < 7) {
//                                newGroupItem = iPadGroupItem_split()
//                            } else {
//                                newGroupItem = iPadGroupItem_split()
//                            }
                        }
                    } else {
                        // TEXT ONLY
                        if(MUST_SPLIT()==0) {
                            if(itemInTopic==1) {
                                // "Header" item
                                let header = DataProviderHeaderItem(title: _T.capitalizedName)
                                self.dataProvider.append(header)
                            
                                newGroupItem = DataProvideriPadGroup_topText()
                            } else {
                                newGroupItem = DataProvideriPadGroup_rowText()
                            }
                        } else {
                            // SPLIT
                            if(itemInTopic==1) {
                                // "Header" (topic)
                                let header = DataProviderHeaderItem(title: _T.capitalizedName)
                                self.dataProvider.append(header)
                                
                                // "Header" (split)
                                let splitHeader = DataProviderSplitHeaderItem()
                                self.dataProvider.append(splitHeader)
                            }
                            
                            newGroupItem = iPadGroupItem_splitText()
                        }
                    }
                }
                
                for j in 1...newGroupItem.MaxNumOfItems { // fill the "newItem"
                    let storyFlag = newGroupItem.storyFlags[j-1]
                    if let _A = _T.nextAvailableArticle(isStory: storyFlag) {
                        newGroupItem.articles.append(_A)
                        self.data.addCountTo(topic: _T.name)
                        
//                        if(newGroupItem.articles.count==4 && newGroupItem is DataProvideriPadGroup_topText) {
//                            break
//                        }
                    } else {
                        break
                    }
                }
                
                self.dataProvider.append(newGroupItem)
                itemInTopic += 1
            }
            
            if(i==0) { // Banner, only for 1rst topic (if apply)
                self.insertBanner()
            }
            
            // "Load more" item
            var isCompleted = false
            if let _ = self.topicsCompleted[_T.name] {
                isCompleted = true
            }
            let loadMore = DataProviderMoreItem(topic: _T.name, completed: isCompleted)
            self.dataProvider.append(loadMore)
        }
        
        // Footer
        let footer = DataProviderFooterItem()
        self.dataProvider.append(footer)
    }
    // --------------------------------


    private func insertBanner() {
        var mustShow = true
        if let _value = READ(LocalKeys.misc.bannerDontShowAgain), (_value == "1") {
            mustShow = false
        }
    
        if(self.data.banner != nil && mustShow && MUST_SPLIT()==0) {
            let banner = DataProviderBannerItem()
            self.dataProvider.append(banner)
        }
    }
}

//            if(MUST_SPLIT()>0) { // remove stories
//                var _articles = [MainFeedArticle]()
//                for _A in _T.articles {
//                    if(!_A.isStory) {
//                        _articles.append(_A)
//                    }
//                }
//
//                _T.articles = _articles
//            }
