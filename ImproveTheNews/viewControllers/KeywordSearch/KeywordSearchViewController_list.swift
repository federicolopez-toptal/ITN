//
//  KeywordSearchViewController_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit


extension KeywordSearchViewController {
    
    // MARK: - Start
    func listInit() {
        if(self.list.superview != nil) {
            self.list.removeFromSuperview()
        }
        self.list = UITableView()
    
        let listMargins: CGFloat = IPAD() ? 16 : 0.0
        
        self.view.addSubview(self.list)
        self.list.backgroundColor = self.view.backgroundColor
        
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: listMargins),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -listMargins),
            self.list.topAnchor.constraint(equalTo: self.searchSelector.bottomAnchor, constant: 0),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.listRegisterCells()
        
        self.refresher.tintColor = .lightGray
        self.refresher.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.list.addSubview(refresher)
        
        self.list.delegate = self
        self.list.dataSource = self
        
        DELAY(0.2) {
            if let _middleIndexPath = self.middleIndexPath {
                self.list.scrollToRow(at: _middleIndexPath, at: .middle, animated: false)
            }
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl!) {
        self.refresher.beginRefreshing()
        self.search(self.searchTextfield.text(), type: .all)
    }
    
    // MARK: - misc
    func refreshList() {
        MAIN_THREAD {
            self.list.reloadData()
        }
    }
    
    // MARK: - Cell registration
    func listRegisterCells() {
        self.list.register(iPhoneHeaderCell_v3.self, forCellReuseIdentifier: iPhoneHeaderCell_v3.identifier)
        self.list.register(iPhoneStory_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)
        self.list.register(iPadArticle_2colsImg_cell_v3.self, forCellReuseIdentifier: iPadArticle_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneMoreCell_v3.self, forCellReuseIdentifier: iPhoneMoreCell_v3.identifier)
        self.list.register(SpacerCell_v3.self, forCellReuseIdentifier: SpacerCell_v3.identifier)
        self.list.register(TopicsCell.self, forCellReuseIdentifier: TopicsCell.identifier)
        self.list.register(CenteredTextCell.self, forCellReuseIdentifier: CenteredTextCell.identifier)
        self.list.register(iPadStory_2colsImg_cell_v3.self, forCellReuseIdentifier: iPadStory_2colsImg_cell_v3.identifier)
    }
    
    // MARK: - Cell component
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(self.filteredDataProvider.isEmpty || indexPath.row>=self.filteredDataProvider.count) {
            return cell
        }
        
        let dpItem = self.filteredDataProvider[indexPath.row]
        
        if let _dpItem = dpItem as? DP3_headerItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderCell_v3.identifier) as! iPhoneHeaderCell_v3
            let mustRemovePadding = IPHONE() ? false : true
            (cell as! iPhoneHeaderCell_v3).populate(with: _dpItem, removePadding: mustRemovePadding)
        } else if let _item = dpItem as? DP3_more {
            cell = self.list.dequeueReusableCell(withIdentifier: iPhoneMoreCell_v3.identifier) as! iPhoneMoreCell_v3
            (cell as! iPhoneMoreCell_v3).populate(with: _item)
            (cell as! iPhoneMoreCell_v3).delegate = self
        } else if let _group = dpItem as? DP3_groupItem {
            let article = _group.articles.first!
            
            if(article.isStory) {
                // Stories
                if(IPHONE()) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPadStory_2colsImg_cell_v3.identifier)!
                }
            } else {
                // Articles
                if(IPHONE()) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)!
                    (cell as! iPhoneArticle_2colsImg_cell_v3).forceHideVLine = true
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPadArticle_2colsImg_cell_v3.identifier)!
                    (cell as! iPadArticle_2colsImg_cell_v3).forceHideVLine = true
                }
            }
            
            (cell as! GroupItemCell_v3).populate(with: _group)
            
        } else if let _group = dpItem as? DP3_topics {
            cell = self.list.dequeueReusableCell(withIdentifier: TopicsCell.identifier) as! TopicsCell
            (cell as! TopicsCell).populate(with: _group.topics)
        } else if let _ = dpItem as? DP3_spacer {
            cell = self.list.dequeueReusableCell(withIdentifier: SpacerCell_v3.identifier) as! SpacerCell_v3
            (cell as! SpacerCell_v3).refreshDisplayMode()
        } else if let _item = dpItem as? DP3_text {
            cell = self.list.dequeueReusableCell(withIdentifier: CenteredTextCell.identifier) as! CenteredTextCell
            (cell as! CenteredTextCell).populate(with: _item.text, offsetY: -15)
        }
        
        return cell
    }
    
    // MARK: - Cell height
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        if(self.filteredDataProvider.isEmpty || indexPath.row>=self.filteredDataProvider.count) {
            return result
        }
        
        let dpItem = self.filteredDataProvider[indexPath.row]
        
        if let _ = dpItem as? DP3_headerItem {
            //result = (self.getCell(indexPath) as! iPhoneHeaderCell_v3).calculateHeight()
            result = 50
        } else if let _ = dpItem as? DP3_more {
            result = 70
        } else if let _ = dpItem as? DP3_groupItem {
            let cell = self.getCell(indexPath)
        
            if(cell is iPhoneStory_2colsImg_cell_v3) {
                result = (cell as! iPhoneStory_2colsImg_cell_v3).calculateGroupHeight()
            } else if(cell is iPadStory_2colsImg_cell_v3) {
                result = (cell as! iPadStory_2colsImg_cell_v3).calculateGroupHeight()
            } else if(cell is iPhoneArticle_2colsImg_cell_v3) {
                result = (cell as! iPhoneArticle_2colsImg_cell_v3).calculateGroupHeight()
            } else if(cell is iPadArticle_2colsImg_cell_v3) {
                result = (cell as! iPadArticle_2colsImg_cell_v3).calculateGroupHeight()
            }
                        
        } else if let _group = dpItem as? DP3_topics {
            result = TopicsCell.calculateHeightFor(topics: _group.topics)
        } else if let _item = dpItem as? DP3_spacer  {
            return _item.size
        } else if let _ = dpItem as? DP3_text {
            return CenteredTextCell.height + 10
        }
    
        return round(result)
    }
    
}

// MARK: - iPadMoreCellDelegate
extension KeywordSearchViewController: iPhoneMoreCell_v3_delegate {

    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3) {
        if(sender.topic == "ST") {
            self.loadMoreStories()
        } else {
            self.loadMoreArticles()
        }
    }
    
    func loadMoreStories() {
        if(self.thereAreStoriesToShow()) {
            let i = self.removeAddMoreItem(isStory: true)
            let count = self.addStories(index: i)
            if(count==self.PAGE_SIZE){
                self.addMoreItem(forStories: true)
            }
            
            self.updateFilteredDataProvider()
            self.refreshList()
        } else {
            //print("SEARCHING...")
            
            self.showLoading()
            let T = self.searchTextfield.text()
            KeywordSearch.shared.search(T, type: .stories, pageNumber: self.storySearchPage+1) { (ok, _) in
                if(ok) {
                    self.storySearchPage += 1
                    let i = self.removeAddMoreItem(isStory: true)
                    let count = self.addStories(index: i)
                    
                    if(count >= self.PAGE_SIZE) {
                        self.addMoreItem(forStories: true)
                    }
                
                    self.updateFilteredDataProvider()
                    self.refreshList()
                } else {
                    self.showErrorOnLoadMore()
                }

                self.hideLoading()
            }
        }
    }
    
    func loadMoreArticles() {
        if(self.thereAreArticlesToShow()) {
            let i = self.removeAddMoreItem(isStory: false)
            let count = self.addArticles(index: i)
            if(count==self.PAGE_SIZE){
                self.addMoreItem(forStories: false)
            }
            
            self.updateFilteredDataProvider()
            self.refreshList()
        } else {
            //print("SEARCHING...")
            
            self.showLoading()
            let T = self.searchTextfield.text()
            KeywordSearch.shared.search(T, type: .articles, pageNumber: self.articleSearchPage+1) { (ok, _) in
                if(ok) {
                    self.articleSearchPage += 1
                    let i = self.removeAddMoreItem(isStory: false)
                    let count = self.addArticles(index: i)
                    if(count >= self.PAGE_SIZE) {
                        self.addMoreItem(forStories: false)
                    }
                
                    self.updateFilteredDataProvider()
                    self.refreshList()
                } else {
                    self.showErrorOnLoadMore()
                }

                self.hideLoading()
            }
        }
    }
    
    func removeAddMoreItem(isStory: Bool) -> Int {
        if(isStory==false) {
            self.dataProvider.remove(at: self.dataProvider.count-1)
            return self.dataProvider.count
        }
        
        var found = false
        var result = -1
        for (i, item) in self.dataProvider.enumerated() {
            if(!found && item is DP3_groupItem) {
                if((item as! DP3_groupItem).articles.first!.isStory == isStory) {
                    found = true
                }
            }

            if(found && item is DP3_more) {
                self.dataProvider.remove(at: i)
                result = i
                break
            }
        }
    
        return result
    }
    
    func addMoreItem(forStories: Bool) {
        if(forStories==false) {
            let moreItem = DP3_more(topic: "AR", completed: false)
            self.dataProvider.append(moreItem)
            return
        }
        
        var found = false
        for (i, item) in self.dataProvider.enumerated() {
            if(!found && item is DP3_groupItem) {
                if((item as! DP3_groupItem).articles.first!.isStory == forStories) {
                    found = true
                }
            }
            
            if(forStories==true && found && item is DP3_headerItem) {
                let moreItem = DP3_more(topic: "ST", completed: false)
                self.dataProvider.insert(moreItem, at: i)
                break
            }
        }
    }

    func showErrorOnLoadMore() {
        MAIN_THREAD {
//            HIDE_KEYBOARD(view: self.view)
//            let popup = StancePopupView()
//            popup.populate(sourceName: "mySource", country: "USA", LR: 1, PE: 5)
//            popup.pushFromBottom()
        
        HIDE_KEYBOARD(view: self.view)
        SERVER_ERROR_POPUP(text: "Oops: we're having a temprary\ndatabase problem - this one is on\nus!")
        
            //let msg = "There was an error while retrieving the information. Try again?"

//            ALERT_YESNO(vc: self, title: "Server error", message: msg) { (answer) in
//                if(answer) {
//                    DELAY(0.2) {
//                        self.search(self.searchTextfield.text(), type: .all)
//                    }
//                } else {
//                    MAIN_THREAD {
//                        self.refresher.endRefreshing()
//                    }
//                }
//            }
        }
        
        
        
//        MAIN_THREAD {
//            ALERT(vc: self, title: "Server error",
//                message: "There was an error while retrieving the information. Please try again later", onCompletion: {
//            })
//        }
    }
    
    func removeAddMore(isStory: Bool) {
        var found = false
        for (i, item) in self.dataProvider.enumerated() {
            if(item is DP3_groupItem) {
                if((item as! DP3_groupItem).articles.first!.isStory == isStory) {
                    found = true
                }
            }

            if(found && item is DP3_more) {
                self.dataProvider.remove(at: i)
                break
            }
        }
    
        MAIN_THREAD {
            self.list.reloadData()
        }
    }
    
    func updateFilteredDataProvider() {
        self.filteredDataProvider = [DP3_item]()
        
        if(self.resultType == 0) {
            for _item in self.dataProvider {
                self.filteredDataProvider.append(_item)
            }
        } else {
            var count = 0
            for _item in self.dataProvider {
                if(_item is DP3_headerItem) {
                    count += 1
                }
                
                if(count==self.resultType) {
                    self.filteredDataProvider.append(_item)
                }
            }
            
            let spacer = DP3_spacer(size: 10)
            self.filteredDataProvider.insert(spacer, at: 0)
        }
        
    }

}
