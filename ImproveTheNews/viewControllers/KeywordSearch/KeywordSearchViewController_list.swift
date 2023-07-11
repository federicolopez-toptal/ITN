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
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.listRegisterCells()
        
        self.refresher.tintColor = .lightGray
        self.refresher.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.list.addSubview(refresher)
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    @objc func refresh(_ sender: UIRefreshControl!) {
        self.refresher.beginRefreshing()
        self.search(self.searchTextfield.text(), type: .all)
    }
    
    // MARK: - Cell registration
    func listRegisterCells() {
        self.list.register(iPadHeaderCell.self, forCellReuseIdentifier: iPadHeaderCell.identifier)
        self.list.register(iPadSpacerCell.self, forCellReuseIdentifier: iPadSpacerCell.identifier)
        self.list.register(iPhoneGroupItem_1AR_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1AR_Cell.identifier)
        self.list.register(iPhoneGroupItem_1ST_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1ST_Cell.identifier)
        self.list.register(iPadGroupItem_2ST_Cell.self, forCellReuseIdentifier: iPadGroupItem_2ST_Cell.identifier)
        self.list.register(TopicsCell.self, forCellReuseIdentifier: TopicsCell.identifier)
        self.list.register(CenteredTextCell.self, forCellReuseIdentifier: CenteredTextCell.identifier)
        self.list.register(iPadMoreCell.self, forCellReuseIdentifier: iPadMoreCell.identifier)
    }
    
    // MARK: - Cell component
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(self.dataProvider.isEmpty || indexPath.row>=self.dataProvider.count) {
            return cell
        }
        
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
            (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
            if(IPAD()){ (cell as! iPadHeaderCell).titleLabel.font = MERRIWEATHER_BOLD(20) }
        } else if let _item = dpItem as? DataProviderMoreItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadMoreCell.identifier) as! iPadMoreCell
            (cell as! iPadMoreCell).populate(with: _item)
            (cell as! iPadMoreCell).delegate = self
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            if(article.isStory) {
                if(IPHONE()) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1ST_Cell.identifier) as! iPhoneGroupItem_1ST_Cell
                    (cell as! iPhoneGroupItem_1ST_Cell).populate(with: _group)
                    (cell as! iPhoneGroupItem_1ST_Cell).highlight(text: self.searchTextfield.text())
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_2ST_Cell.identifier) as! iPadGroupItem_2ST_Cell
                    (cell as! iPadGroupItem_2ST_Cell).populate(with: _group)
                    (cell as! iPadGroupItem_2ST_Cell).highlight(text: self.searchTextfield.text())
                }
            } else {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1AR_Cell.identifier) as! iPhoneGroupItem_1AR_Cell
                (cell as! iPhoneGroupItem_1AR_Cell).populate(with: _group)
                (cell as! iPhoneGroupItem_1AR_Cell).highlight(text: self.searchTextfield.text())
            }

        } else if let _group = dpItem as? DataProviderTopicsItem {
            cell = self.list.dequeueReusableCell(withIdentifier: TopicsCell.identifier) as! TopicsCell
            (cell as! TopicsCell).populate(with: _group.topics)
        } else if let _ = dpItem as? DataProviderSpacer {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadSpacerCell.identifier) as! iPadSpacerCell
            (cell as! iPadSpacerCell).refreshDisplayMode()
        } else if let _item = dpItem as? DataProviderCenteredText {
            cell = self.list.dequeueReusableCell(withIdentifier: CenteredTextCell.identifier) as! CenteredTextCell
            (cell as! CenteredTextCell).populate(with: _item.text, offsetY: -15)
        }
        
        return cell
    }
    
    // MARK: - Cell height
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        if(self.dataProvider.isEmpty || indexPath.row>=self.dataProvider.count) {
            return result
        }
        
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            result = 30
        } else if let _ = dpItem as? DataProviderMoreItem {
            result = 70
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            if(article.isStory) {
                if(IPHONE()) {
                    result = iPhoneGroupItem_1ST_Cell.calculateHeightFor(_group.articles) + 10
                } else {
                    result = 350 + 20
                }
            } else {
                result = iPhoneGroupItem_1AR_Cell.calculateHeightFor(_group.articles) + 5
            }
        } else if let _group = dpItem as? DataProviderTopicsItem {
            result = TopicsCell.calculateHeightFor(topics: _group.topics) + 10
        } else if let _item = dpItem as? DataProviderSpacer  {
            return _item.size
        } else if let _ = dpItem as? DataProviderCenteredText {
            return CenteredTextCell.height + 10
        }
        
        return result
    }
    
}

// MARK: - iPadMoreCellDelegate
extension KeywordSearchViewController: iPadMoreCellDelegate {

    func onShowMoreButtonTap(sender: iPadMoreCell) {
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
            
            MAIN_THREAD {
                self.list.reloadData()
            }
        } else {
            print("SEARCHING...")
            
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
                
                    MAIN_THREAD {
                        self.list.reloadData()
                    }
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
            
            MAIN_THREAD {
                self.list.reloadData()
            }
        } else {
            print("SEARCHING...")
            
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
                
                    MAIN_THREAD {
                        self.list.reloadData()
                    }
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
            if(!found && item is DataProviderGroupItem) {
                if((item as! DataProviderGroupItem).articles.first!.isStory == isStory) {
                    found = true
                }
            }

            if(found && item is DataProviderMoreItem) {
                self.dataProvider.remove(at: i)
                result = i
                break
            }
        }
    
        return result
    }
    
    func addMoreItem(forStories: Bool) {
        if(forStories==false) {
            let moreItem = DataProviderMoreItem(topic: "AR", completed: false)
            self.dataProvider.append(moreItem)
            return
        }
        
        var found = false
        for (i, item) in self.dataProvider.enumerated() {
            if(!found && item is DataProviderGroupItem) {
                if((item as! DataProviderGroupItem).articles.first!.isStory == forStories) {
                    found = true
                }
            }
            
            if(forStories==true && found && item is DataProviderHeaderItem) {
                let moreItem = DataProviderMoreItem(topic: "ST", completed: false)
                self.dataProvider.insert(moreItem, at: i)
                break
            }
        }
    }

    func showErrorOnLoadMore() {
        MAIN_THREAD {
            ALERT(vc: self, title: "Server error",
                message: "There was an error while retrieving the information. Please try again later", onCompletion: {
            })
        }
    }
    
    func removeAddMore(isStory: Bool) {
        var found = false
        for (i, item) in self.dataProvider.enumerated() {
            if(item is DataProviderGroupItem) {
                if((item as! DataProviderGroupItem).articles.first!.isStory == isStory) {
                    found = true
                }
            }

            if(found && item is DataProviderMoreItem) {
                self.dataProvider.remove(at: i)
                break
            }
        }
    
        MAIN_THREAD {
            self.list.reloadData()
        }
    }

}
