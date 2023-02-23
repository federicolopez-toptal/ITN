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
                    if(itemInTopic==1) {
                        let header = DataProviderHeaderItem(title: _T.capitalizedName)
                        self.dataProvider.append(header)
                    
                        newGroupItem = iPadGroupItem_top()
                    } else {
                        newGroupItem = iPadGroupItem_row()
                    }
                }
                
                for j in 1...newGroupItem.MaxNumOfItems { // fill the "newItem"
                    let storyFlag = newGroupItem.storyFlags[j-1]
                    if let _A = _T.nextAvailableArticle(isStory: storyFlag) {
                        newGroupItem.articles.append(_A)
                    } else {
                        break
                    }
                }
                
                self.dataProvider.append(newGroupItem)
                itemInTopic += 1
            }
        }
    }
    // --------------------------------

}
