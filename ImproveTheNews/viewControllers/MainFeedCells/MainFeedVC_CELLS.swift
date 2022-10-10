//
//  MainFeedVC_CELLS.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/10/2022.
//

import UIKit


extension MainFeedViewController {
    
    func getCellSizeAtIndexPath(_ indexPath: IndexPath, width: CGFloat) -> CGSize {
        var size: CGSize!
        let dpItem = self.getDP_item(indexPath)

        if (dpItem is DP_header) { // Header
            size = HeaderCell.calculateHeight(width: width)
        } else if let _dpItem = dpItem as? DP_Story_CO { // Story column
            let story = self.getArticle(from: _dpItem)
            size = StoryCO_cell.calculateHeight(text: story.title,
                sourcesCount: story.storySources.count, width: width)
        } else if let _dpItem = dpItem as? DP_Article_CO { // Article column
            let article = self.getArticle(from: _dpItem)
            size = ArticleCO_cell.calculateHeight(text: article.title, sourcesCount: article.storySources.count, width: width)
        } else if (dpItem is DP_Story_BI) { // Story, big image
            size = StoryBI_cell.calculateHeight(width: width)
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
    
    
    
    
    
    func getCellForIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let dpItem = self.getDP_item(indexPath)
        
        if let _item = dpItem as? DP_header { // Header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
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
