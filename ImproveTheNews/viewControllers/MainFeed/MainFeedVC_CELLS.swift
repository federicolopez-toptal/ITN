//
//  MainFeedVC_CELLS.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/10/2022.
//

import UIKit


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
    
    func getCellSizeAt(_ indexPath: IndexPath, width: CGFloat) -> CGSize {
        var size: CGSize!
        let dpItem = self.getDP_item(indexPath)

        if (dpItem is DP_header) { // Header
            size = HeaderCell.getHeight(width: width)
        } else if (dpItem is DP_more) { // More
            size = MoreCell.getHeight(width: width)
        } else if (dpItem is DP_footer) { // Footer
            size = FooterCell.getHeight(width: width)
        } else if let _dpItem = dpItem as? DP_Story_CO { // Story column
            let story = self.getArticle(from: _dpItem)
            size = StoryCO_cell.calculateHeight(text: story.title,
                sourcesCount: story.storySources.count,
                width: width)
        } else if let _dpItem = dpItem as? DP_Article_CO { // Article column
            let article = self.getArticle(from: _dpItem)
            size = ArticleCO_cell.calculateHeight(text: article.title,
            sourcesCount: article.storySources.count,
            width: width)
        } else if (dpItem is DP_Story_BI) { // Story, big image
            size = StoryBI_cell.getHeight(width: width)
        } else if let _dpItem = dpItem as? DP_Article_WI { // Article, wide image
            let article = self.getArticle(from: _dpItem)
            size = ArticleWI_cell.calculateHeight(text: article.title, width: width)
        } else if let _dpItem = dpItem as? DP_Article_WT { // Article, wide text
            let article = self.getArticle(from: _dpItem)
            size = ArticleWT_cell.calculateHeight(text: article.title, width: width)
        } else if let _dpItem = dpItem as? DP_Story_WT { // Story, wide text
            let story = self.getArticle(from: _dpItem)
            size = StoryWT_cell.calculateHeight(text: story.title, width: width)
        }
        
        return size
    }
    
    // ------------------
    func getCellForIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let dpItem = self.getDP_item(indexPath)
        
        if let _item = dpItem as? DP_header { // Header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
        } else if let _item = dpItem as? DP_more  { // More
            cell = self.list.dequeueReusableCell(withReuseIdentifier: MoreCell.identifier,
                for: indexPath) as! MoreCell
            (cell as! MoreCell).populate(with: _item)
        } else if let _item = dpItem as? DP_footer {
            cell = self.list.dequeueReusableCell(withReuseIdentifier: FooterCell.identifier,
                for: indexPath) as! FooterCell
            (cell as! FooterCell).viewController = self
            (cell as! FooterCell).populate(with: _item)
        } else if let _item = dpItem as? DP_Story_CO { // Story column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryCO_cell.identifier,
                for: indexPath) as! StoryCO_cell
            (cell as! StoryCO_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = dpItem as? DP_Article_CO { // Article column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleCO_cell.identifier,
                for: indexPath) as! ArticleCO_cell
            (cell as! ArticleCO_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = dpItem as? DP_Story_BI { // Story, big image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryBI_cell.identifier,
                for: indexPath) as! StoryBI_cell
            (cell as! StoryBI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = dpItem as? DP_Article_WI { // Article, wide image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWI_cell.identifier,
                for: indexPath) as! ArticleWI_cell
            (cell as! ArticleWI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = dpItem as? DP_Article_WT { // Article, wide text
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWT_cell.identifier,
                for: indexPath) as! ArticleWT_cell
            (cell as! ArticleWT_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = dpItem as? DP_Story_WT { // Story, wide text
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryWT_cell.identifier,
                for: indexPath) as! StoryWT_cell
            (cell as! StoryWT_cell).populate(with: self.getArticle(from: _item))
        }
            
        return cell
    }
    
}

extension MainFeedViewController {

    private func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    private func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }
    
    private func getBanner(from item: DP_banner) -> Banner {
        return self.data.banners[item.bannerIndex]
    }

}




/*
        var cell: UICollectionViewCell!
        let item = self.getDP_item(indexPath)
        
        if let _item = item as? DP_header {
            // Header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
        } else if let _item = item as? DP_Story_BI {
            // Big story with image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryBI_cell.identifier,
                for: indexPath) as! StoryBI_cell
            (cell as! StoryBI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Article_WI {
            // Wide article with image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWI_cell.identifier,
                for: indexPath) as! ArticleWI_cell
            (cell as! ArticleWI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Article_WT {
            // Wide article (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWT_cell.identifier,
                for: indexPath) as! ArticleWT_cell
            (cell as! ArticleWT_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Story_WT {
            // Wide story (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryWT_cell.identifier,
                for: indexPath) as! StoryWT_cell
            (cell as! StoryWT_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Story_CO {
            // Story column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryCO_cell.identifier,
                for: indexPath) as! StoryCO_cell
            (cell as! StoryCO_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = item as? DP_Article_CO {
            // Article column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleCO_cell.identifier,
                for: indexPath) as! ArticleCO_cell
            (cell as! ArticleCO_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = item as? DP_banner {
            // Banner
            cell = self.list.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier,
                for: indexPath) as! BannerCell
            (cell as! BannerCell).populate(with: self.getBanner(from: _item))
        }
        
        return cell!
         */
