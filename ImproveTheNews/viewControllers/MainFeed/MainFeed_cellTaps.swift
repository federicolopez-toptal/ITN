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
//            if(article.isStory) {
//                print("STORY", article.title)
//            } else {
//                print("ARTICLE", article.title)
//            }
            
            let vc = ArticleViewController()
            vc.article = article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}




// MARK: - Stance icon(s) tap
extension MainFeedViewController: ArticleWI_cell_Delegate, ArticleWT_cell_Delegate, ArticleCO_cell_Delegate {

    func onStanceIconTap(sender: ArticleWI_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    func onStanceIconTap(sender: ArticleWT_cell) {
        self.showStancePopup(sourceName: sender.sourceName, country: sender.country, LR: sender.LR, PE: sender.PE)
    }
    
    func onStanceIconTap(sender: ArticleCO_cell) {
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
        let vc = MainFeedViewController()
        if let _topic = sender.topic {
            vc.topic = _topic
        }
        
        self.data.updateCounting()
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
}
