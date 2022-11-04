//
//  MainFeed_collectionView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/10/2022.
//

import UIKit
import Foundation

// LIST
extension MainFeedViewController {
    
    // MARK: - Init
    func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
        self.list.customDelegate = self
        
        var topValue: CGFloat = NavBarView.HEIGHT() + TopicSelectorView.HEIGHT()
        if(self.breadcrumbs != nil) {
            topValue += BreadcrumbsView.HEIGHT()
        }
        
        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue) // navBar + topicSelector
        ])
        
        // Cells registration
        self.list.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        self.list.register(SplitHeaderCell.self, forCellWithReuseIdentifier: SplitHeaderCell.identifier)
        self.list.register(MoreCell.self, forCellWithReuseIdentifier: MoreCell.identifier)
        self.list.register(FooterCell.self, forCellWithReuseIdentifier: FooterCell.identifier)
        self.list.register(StoryBI_cell.self, forCellWithReuseIdentifier: StoryBI_cell.identifier)
        self.list.register(ArticleWI_cell.self, forCellWithReuseIdentifier: ArticleWI_cell.identifier)
        self.list.register(ArticleWT_cell.self, forCellWithReuseIdentifier: ArticleWT_cell.identifier)
        self.list.register(StoryWT_cell.self, forCellWithReuseIdentifier: StoryWT_cell.identifier)
        self.list.register(StoryCI_cell.self, forCellWithReuseIdentifier: StoryCI_cell.identifier)
        self.list.register(StoryCT_cell.self, forCellWithReuseIdentifier: StoryCT_cell.identifier)
        self.list.register(ArticleCI_cell.self, forCellWithReuseIdentifier: ArticleCI_cell.identifier)
        self.list.register(ArticleCT_cell.self, forCellWithReuseIdentifier: ArticleCT_cell.identifier)
        
        self.list.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)


        self.list.delegate = self
        self.list.dataSource = self
    }
    
    // MARK: - misc
    func refreshList() {
        DispatchQueue.main.async {
            (self.list.collectionViewLayout as! CustomFlowLayout).resetCache()
            self.list.reloadData()
        }
    }
    
    func refreshVLine() {
        MAIN_THREAD {
            if(self.mustSplit()==0) {
                self.list.vLineView.hide()
                return
            }
        
            var lines = [(CGFloat, Bool)]()
            
            for (i, dp) in self.dataProvider.enumerated() {
                var mustDraw = true
                let iPath = IndexPath(row: i, section: 0)
                var H = self.getCellSizeAt(iPath, width: self.list.bounds.width).height
                let dpItem = self.getDP_item(iPath)
                
                if (dpItem is DP_header || dpItem is DP_footer || dpItem is DP_more){
                    mustDraw = false
                    lines.append( (H, mustDraw) )
                } else if(dpItem is DP_splitHeader) {
                    lines.append( (H, mustDraw) )
                } else {
                    var column = 1
                    if let _dp = dpItem as? DP_Article_CI { column = _dp.column }
                    else if let _dp = dpItem as? DP_Article_CT { column = _dp.column }
                    else if let _dp = dpItem as? DP_Story_CI { column = _dp.column }
                    else if let _dp = dpItem as? DP_Story_CT { column = _dp.column }
                    
                    if(column == 1) {
                        if(i+1 < self.dataProvider.count) {
                            let nextIPath = IndexPath(row: i+1, section: 0)
                            let nextDpItem = self.getDP_item(nextIPath)
                            if(nextDpItem is DP_Article_CI || nextDpItem is DP_Article_CT ||
                                nextDpItem is DP_Story_CI || nextDpItem is DP_Story_CT) {
                            
                                let nextH = self.getCellSizeAt(nextIPath, width: self.list.bounds.width).height
                                if(nextH > H){ H = nextH }
                            }
                        }
                        
                        lines.append( (H, mustDraw) )
                    } else {
                        NOTHING()
                    }
                }
            }
            
            self.list.refreshVLine(lines: lines)
        }
    }
    
}

// MARK: - UICollectionViewDataSource + UICollectionViewDelegateFlowLayout
extension MainFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomCollectionViewDelegate {

    func collectionViewOnRefreshPulled(sender: CustomCollectionView) {
        self.loadData(showLoading: false)
    }
    
    // ------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.getCellForIndexPath(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.getCellSizeAt(indexPath, width: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapOnCellAt(indexPath)
    }

}


extension MainFeedViewController {
    
    // TAP event
    
    
    // size
    func getCellSizeAt(_ indexPath: IndexPath, width: CGFloat) -> CGSize {
        var size = CGSize.zero
        if(indexPath.row >= self.dataProvider.count) {
            return size
        }
        
        let dpItem = self.getDP_item(indexPath)

        if (dpItem is DP_header) { // Header
            size = HeaderCell.getHeight(width: width)
        } else if (dpItem is DP_splitHeader) { // Split header
            size = SplitHeaderCell.getHeight(width: width)
        } else if (dpItem is DP_more) { // More
            size = MoreCell.getHeight(width: width)
        } else if (dpItem is DP_footer) { // Footer
            size = FooterCell.getHeight(width: width)
        } else if let _dpItem = dpItem as? DP_Story_CI { // Story column (with image)
            let story = self.getArticle(from: _dpItem)
            size = StoryCI_cell.calculateHeight(text: story.title,
                sourcesCount: story.storySources.count,
                width: width)
        } else if let _dpItem = dpItem as? DP_Story_CT { // Story column (only text)
            let story = self.getArticle(from: _dpItem)
            size = StoryCT_cell.calculateHeight(text: story.title,
                sourcesCount: story.storySources.count,
                width: width)
        } else if let _dpItem = dpItem as? DP_Article_CI { // Article column (with image)
            let article = self.getArticle(from: _dpItem)
            size = ArticleCI_cell.calculateHeight(text: article.title,
            sourcesCount: article.storySources.count,
            width: width)
        } else if let _dpItem = dpItem as? DP_Article_CT { // Article column (only text)
            let article = self.getArticle(from: _dpItem)
            size = ArticleCT_cell.calculateHeight(text: article.title,
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
    
    // CELL ------------------
    func getCellForIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let dpItem = self.getDP_item(indexPath)
        
        if let _item = dpItem as? DP_header { // Header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
        } else if let _item = dpItem as? DP_splitHeader { // Split header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: SplitHeaderCell.identifier,
                for: indexPath) as! SplitHeaderCell
            (cell as! SplitHeaderCell).populate(with: _item)
        } else if let _item = dpItem as? DP_more  { // More
            cell = self.list.dequeueReusableCell(withReuseIdentifier: MoreCell.identifier,
                for: indexPath) as! MoreCell
            (cell as! MoreCell).populate(with: _item)
            (cell as! MoreCell).delegate = self
        } else if let _item = dpItem as? DP_footer {
            cell = self.list.dequeueReusableCell(withReuseIdentifier: FooterCell.identifier,
                for: indexPath) as! FooterCell
            (cell as! FooterCell).viewController = self
            (cell as! FooterCell).populate(with: _item)
        } else if let _item = dpItem as? DP_Story_CI { // Story column (with image)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryCI_cell.identifier,
                for: indexPath) as! StoryCI_cell
            (cell as! StoryCI_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = dpItem as? DP_Story_CT { // Story column (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryCT_cell.identifier,
                for: indexPath) as! StoryCT_cell
            (cell as! StoryCT_cell).populate(with: self.getArticle(from: _item), column: _item.column)
        } else if let _item = dpItem as? DP_Article_CI { // Article column (with image)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleCI_cell.identifier,
                for: indexPath) as! ArticleCI_cell
            (cell as! ArticleCI_cell).populate(with: self.getArticle(from: _item), column: _item.column)
            (cell as! ArticleCI_cell).delegate = self
        } else if let _item = dpItem as? DP_Article_CT { // Article column (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleCT_cell.identifier,
                for: indexPath) as! ArticleCT_cell
            (cell as! ArticleCT_cell).populate(with: self.getArticle(from: _item), column: _item.column)
            (cell as! ArticleCT_cell).delegate = self
        } else if let _item = dpItem as? DP_Story_BI { // Story, big image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryBI_cell.identifier,
                for: indexPath) as! StoryBI_cell
            (cell as! StoryBI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = dpItem as? DP_Article_WI { // Article, wide image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWI_cell.identifier,
                for: indexPath) as! ArticleWI_cell
            (cell as! ArticleWI_cell).populate(with: self.getArticle(from: _item))
            (cell as! ArticleWI_cell).delegate = self
        } else if let _item = dpItem as? DP_Article_WT { // Article, wide text
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWT_cell.identifier,
                for: indexPath) as! ArticleWT_cell
            (cell as! ArticleWT_cell).populate(with: self.getArticle(from: _item))
            (cell as! ArticleWT_cell).delegate = self
        } else if let _item = dpItem as? DP_Story_WT { // Story, wide text
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryWT_cell.identifier,
                for: indexPath) as! StoryWT_cell
            (cell as! StoryWT_cell).populate(with: self.getArticle(from: _item))
        }
            
        return cell
    }
    
    func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }
    
    func getBanner(from item: DP_banner) -> Banner {
        return self.data.banners[item.bannerIndex]
    }

}
