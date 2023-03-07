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
            hsp     header split
            m       more (show more)
            f       footer
            _       small spacer
            
            sbi     story, big with image
            swt     story, wide only text
            sci     story column (with image)
            sct     story column (only text)
            
            awi     article, wide with image
            awt     article, wide only text
            aci     article column (with image)
            act     article column (only text)
            
        */
        
        let LOADMORE_LIMIT = 50
        var itemsToShowPerTopic = ""
        
        if(TEXT_IMAGES()) {
            itemsToShowPerTopic = "h,"
            for _ in 1...LOADMORE_LIMIT {
                itemsToShowPerTopic += "sbi,awi2,awt3,swt,sci,aci3,"
            }
            itemsToShowPerTopic += "m"
        } else if(TEXT_ONLY()){
            itemsToShowPerTopic = "h,"
            for _ in 1...LOADMORE_LIMIT {
                itemsToShowPerTopic += "swt,awt2,sct,act3,"
            }
            itemsToShowPerTopic += "m"
        }
        
        let mustSplit = MUST_SPLIT()
        if(mustSplit > 0) {
            if(TEXT_IMAGES()) {
                itemsToShowPerTopic = "h,hsp,"
                for _ in 1...LOADMORE_LIMIT {
                    //itemsToShowPerTopic += "aci8,_,swt,_,swt,_"
                    itemsToShowPerTopic += "aci8,swt2,"
                }
                //itemsToShowPerTopic += "swt,"
                itemsToShowPerTopic += "m"
            } else if(TEXT_ONLY()){
                itemsToShowPerTopic = "h,hsp,"
                for _ in 1...LOADMORE_LIMIT {
                    itemsToShowPerTopic += "act8,swt2,"
                }
                itemsToShowPerTopic += "m"
            }
        }

        self.data.resetCounting()
        self.dataProvider = [DP_item]()
        for (i, T) in self.data.topics.enumerated() {

            self.column = 1
            var allItems = itemsToShowPerTopic.components(separatedBy: ",")
            if(mustSplit==0 && i==0 && allItems.count>1 && Layout.current() == .textImages && IPHONE()){
                allItems.swapAt(0, 1)
            }
            
            for item in allItems {
                let type = item.getCharAt(index: 0) // 1st char: Data type (h: header, s: story, a: article, m: more)
                let format = item.subString(from: 1, count: 2) // 2nd + 3rd char: Size and/or format
                var count = item.getCharAt(index: 3) //4th char: Items count
                if let subCount = item.getCharAt(index: 4), count != nil {
                    count! += subCount
                }
                
                if(type == "h") { // header
                    let hText = T.capitalizedName.uppercased()
                    self.addHeader(format: format, isHeadline: (T.name=="news"), headlineText: hText)
                } else if(type == "_") {
                    let spacer = DP_spacer(height: 10)
                    self.dataProvider.append(spacer)
                }else if(type == "m") {
                    self.insertBanner(index: i)
                
                    var completed = false
                    if let _ = self.topicsCompleted[T.name] {
                        completed = true
                    }
                    let more = DP_more(topic: T.name, completed: completed)
                    self.dataProvider.append(more)
                } else if(type == "s") {   // story
                    self.addStoryToDataProvider(count: count, format: format, topicIndex: i)
                } else if(type == "a") {   // article
                    self.addArticleToDataProvider(count: count, format: format, topicIndex: i)
                }
                            
            }
            //self.insertBanner(index: i) // End of topic, after "Show more"
        }
        
        let footer = DP_footer()
        self.dataProvider.append(footer)
    }
    
    func insertBanner(index: Int) {
        var mustShow = true
        if let _value = READ(LocalKeys.misc.bannerDontShowAgain), (_value == "1") {
            mustShow = false
        }
        
        if(index==0 && (self.data.banner != nil) && mustShow && MUST_SPLIT()==0 && IPHONE()) { //!!
            let dpBanner = DP_banner()
            self.dataProvider.append(dpBanner)
        }
    }
    
    func addHeader(format: String?, isHeadline: Bool, headlineText: String) {
        if(format == nil) {
            let header = DP_header(text: headlineText, isHeadline: isHeadline)
            self.dataProvider.append(header)
        } else if(format == "sp") {
            var L = "LEFT"
            var R = "RIGHT"
            if(MUST_SPLIT() == 2) {
                L = "CRITICAL"
                R = "PRO"
            }
        
            let header = DP_splitHeader(leftText: L, rightText: R)
            self.dataProvider.append(header)
        }
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
                        self.data.addCountTo(topic: self.data.topics[i].name)
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
                        self.data.addCountTo(topic: self.data.topics[i].name)
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
