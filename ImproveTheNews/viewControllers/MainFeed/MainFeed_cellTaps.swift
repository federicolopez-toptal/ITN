//
//  MainFeed_cellTaps.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/10/2022.
//

import UIKit
import Foundation

// MARK: - Cell generic tap
extension MainFeedViewController {
    
    func tapOnCellAt(_ indexPath: IndexPath) {
        let item = self.getDP_item(indexPath)
        let isHeader = item is DP_header
        let isBanner = item is DP_banner
        let isMore = item is DP_more
        let isFooter = item is DP_footer

        if(!isHeader && !isBanner && !isMore && !isFooter) {
            let article = self.getArticle(from: (item as! DP_itemPointingData))

            if(article.isStory) {
                // FUTURE_IMPLEMENTATION("Show the Story content screen here")
                let vc = StoryViewController()
                vc.story = article
                CustomNavController.shared.pushViewController(vc, animated: true)
            } else {
                let vc = ArticleViewController()
                vc.article = article
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    
}




// MARK: - Stance icon(s) tap
extension MainFeedViewController: ArticleWI_cell_Delegate, ArticleWT_cell_Delegate,
                                    ArticleCI_cell_Delegate, ArticleCT_cell_Delegate {

    func onStanceIconTap(sender: ArticleWI_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    func onStanceIconTap(sender: ArticleWT_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    func onStanceIconTap(sender: ArticleCI_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    func onStanceIconTap(sender: ArticleCT_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    // -----------------------
    private func showStancePopup(sourceName: String, country: String, LR: Int, PE: Int) {
        let popup = StancePopupView()
        popup.populate(sourceName: sourceName, country: country, LR: LR, PE: PE)
        popup.pushFromBottom()
    }

}

// MARK: - Show more
extension MainFeedViewController: MoreCellDelegate {
    
    func onShowMoreButtonTap(sender: MoreCell) {
        self.showLoading()

        if let _topic = sender.topic {
            //print("TOPIC", _topic)
            self.data.loadMoreData(topic: _topic) { (error, articlesAdded) in
                let count = self.data.topicsCount[_topic]! + 11
                if(count >= LOAD_MORE_LIMIT * 11) {
                    self.topicsCompleted[_topic] = true
                }
                
                
//                if(articlesAdded == 0) { // No more articles
//
//                }
                
                self.populateDataProvider()
                self.refreshList()
                
                self.hideLoading()
                self.list.hideRefresher()
                self.list.forceUpdateLayoutForVisibleItems()
                self.refreshVLine()
            }
        }
        
    }
}
