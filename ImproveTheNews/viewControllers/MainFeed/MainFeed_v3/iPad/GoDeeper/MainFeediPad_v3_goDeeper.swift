//
//  MainFeediPad_v3_goDeeper.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/02/2025.
//

import Foundation
import UIKit

// MARK: - Go Deeper
extension MainFeediPad_v3_viewController {

    private func showGoDeeperErrorAlert() {
        MAIN_THREAD {
            self.hideLoading()
            self.list.hideRefresher()
            
            ALERT(vc: self, title: "",
                message: "Trouble loading Go Deeper items,\nplease try again later.", onCompletion: {
                DELAY(1.0) {
                    self.loadData(showLoading: true)
                }
            })
        }
    }
    ////////////////////////////////////////////////////////////

    func loadGoDeeper() {
        self.data.loadGoDeeper(page: self.goDeeperPage) { (error, total) in
            self.hideLoading()
        
            if let _error = error {
                self.showGoDeeperErrorAlert()
                return
            }
        
            if let _total = total {
                self.repopulateDataProviderGoDeeper(total: _total)
                self.refreshList()
            }
            
        }
    }
    
    func repopulateDataProviderGoDeeper(total: Int) {
        // Clean all GO DEEPER previous content (logically)
        var TIndex = -1
        for (i, T) in self.data.topics.enumerated() {
            if(T.name == "godeeper") {
                for (j, _) in T.articles.enumerated() {
                    self.data.topics[i].articles[j].used = false
                }
                
                TIndex = i
                break
            }
        }
        
    
        for (i, _dp) in self.dataProvider.enumerated() {
            if let _header = _dp as? DP3_headerItem, _header.title.lowercased() == "go deeper" {
                // remove previous GO DEEPER content from dataProvider
                while(true) {
                    let _item = self.dataProvider[i+1]
                    
                    if(_item is DP3_headerItem) {
                        break
                    } else {
                        self.dataProvider.remove(at: i+1)
                    }
                }
                
                // Add/Distribute GO DEEPER content
                var sum = 1
                while( self.data.topics[TIndex].hasNewsAvailable() ) {
                    let newGroupItem = DP3_iPhoneGoDeeper_4cols() // A reemplazar

                    for _ in 1...4 {
                        if let A = self.data.topics[TIndex].nextAvailableArticle(isStory: true) {
                            newGroupItem.articles.append(A)
                            self.data.addCountTo(topic: self.data.topics[TIndex].name)
                        } else {
                            break
                        }
                    }
                    
                    self.dataProvider.insert(newGroupItem, at: i+sum)
                    sum += 1
                }
                
                // More button
                if(self.data.topics[TIndex].articles.count < total) {
                    let moreItem = DP3_more(topic: "godeeper", completed: false)
                    self.dataProvider.insert(moreItem, at: i+sum)
                }
                break
            }
            
            
        }
        
        ///
    }
    
}
