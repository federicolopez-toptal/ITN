//
//  MainFeed_dataProvider.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/10/2022.
//

import UIKit
import Foundation

extension MainFeedViewController {
    
    func populateDataProvider() {

        /*
            VALID (working) items
            
            h       simple header
            m       more (show more)
            f       footer
            
            sbi     story, big with image
            swt     story, wide only text
            sci     story column (with image)
            sct     story column (only text)
            
            awi     article, wide with image
            awt     article, wide only text
            aci     article column (with image)
            act     article column (only text)
            
        */
        
        var itemsToShowPerTopic = "h,sbi,awi2,awt3,swt,sci,aci3,m"
        if(TEXT_ONLY()){
            itemsToShowPerTopic = "h,swt,awt2,sct,act3,m"
        }
        
        //"h,sbi,awi,m,awt3,swt,sco,aco3"
        //"h,sbi,awi2,awt3,swt,sco,aco3"
        //"h,sbi,awi2,awt3,swt" // sco,aco
        //"h,sbi,sco,aco3,awt2"
        //"h,sbi,awi2,awt3,swt,sco2"
        // "h,sbi,awi2,awt3,swt,sco,aco"

        self.dataProvider = [DP_item]()
        for (i, T) in self.data.topics.enumerated() {

            self.column = 1
            var allItems = itemsToShowPerTopic.components(separatedBy: ",")
            if(i==0 && allItems.count>1){ allItems.swapAt(0, 1) }
            
            for item in allItems {
                let type = item.getCharAt(index: 0) // 1st char: Data type (h: header, s: story, a: article, m: more)
                let format = item.subString(from: 1, count: 2) // 2nd + 3rd char: Size and/or format
                let count = item.getCharAt(index: 3) //4th char: Items count
                
                if(type == "h") { // header
                    let header = DP_header(text: T.capitalizedName.uppercased(), isHeadlines: (T.name=="news"))
                    self.dataProvider.append(header)
                } else if(type == "m") {
                    let more = DP_more(topic: T.name)
                    self.dataProvider.append(more)
                } else if(type == "s") {   // story
                    self.addStoryToDataProvider(count: count, format: format, topicIndex: i)
                } else if(type == "a") {   // article
                    self.addArticleToDataProvider(count: count, format: format, topicIndex: i)
                }
                            
            }
             
//            if(i==0 && self.data.banners.count>0) {
//                let banner = DP_banner(index: 0)
//                self.dataProvider.append(banner)
//            }
        }
        
        let footer = DP_footer()
        self.dataProvider.append(footer)
    }
    
    func addStoryToDataProvider(count: String?, format: String?, topicIndex i: Int) {
        var mCount = 1
        if let _count = count {
            mCount = Int(_count)!
        }
    
        for _ in 1...mCount {
            if let _j = self.getNextArticle(topicIndex: i, isStory: true) {
                if let _format = format {
                    var dpItem: DP_itemPointingData?
                    
                    if(_format == "bi") {
                        dpItem = DP_Story_BI(T: i, A: _j)
                    } else if(_format == "wt") {
                        dpItem = DP_Story_WT(T: i, A: _j)
                    } else if(_format == "ci") {
                        dpItem = DP_Story_CI(T: i, A: _j, column: self.column)
                        self.addColumn()
                    } else if(_format == "ct") {
                        dpItem = DP_Story_CT(T: i, A: _j, column: self.column)
                        self.addColumn()
                    }
                    
                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
    }
    
    func addArticleToDataProvider(count: String?, format: String?, topicIndex i: Int) {
        var mCount = 1
        if let _count = count {
            mCount = Int(_count)!
        }

        for _ in 1...mCount {
            if let _j = self.getNextArticle(topicIndex: i) {
                if let _format = format {
                    var dpItem: DP_itemPointingData?

                    if(_format == "wi") {
                        dpItem = DP_Article_WI(T: i, A: _j)
                    } else if(_format == "wt") {
                        dpItem = DP_Article_WT(T: i, A: _j)
                    } else if(_format == "ci") {
                        dpItem = DP_Article_CI(T: i, A: _j, column: self.column)
                        self.addColumn()
                    } else if(_format == "ct") {
                        dpItem = DP_Article_CT(T: i, A: _j, column: self.column)
                        self.addColumn()
                    }

                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
    }
    
    private func addColumn() {
        self.column += 1
        if(self.column == 3) {
            self.column = 1
        }
    }
    
    
    func getNextArticle(topicIndex i: Int, isStory: Bool = false) -> Int? {
        var result: Int? = nil
        for (j, A) in self.data.topics[i].articles.enumerated() {
            if(A.isStory==isStory && !A.used) {
                self.data.topics[i].articles[j].used = true
                result = j
                break
            }
        }
        return result
    }
    
}
