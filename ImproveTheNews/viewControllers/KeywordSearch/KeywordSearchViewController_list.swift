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
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    // MARK: - Cell registration
    func listRegisterCells() {
        self.list.register(iPadHeaderCell.self, forCellReuseIdentifier: iPadHeaderCell.identifier)
        self.list.register(iPadSpacerCell.self, forCellReuseIdentifier: iPadSpacerCell.identifier)
        self.list.register(iPhoneGroupItem_1AR_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1AR_Cell.identifier)
        self.list.register(iPhoneGroupItem_1ST_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1ST_Cell.identifier)
        self.list.register(TopicsCell.self, forCellReuseIdentifier: TopicsCell.identifier)
        self.list.register(CenteredTextCell.self, forCellReuseIdentifier: CenteredTextCell.identifier)
        self.list.register(iPadMoreCell.self, forCellReuseIdentifier: iPadMoreCell.identifier)
    }
    
    // MARK: - Cell component
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
            (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
        } else if let _item = dpItem as? DataProviderMoreItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadMoreCell.identifier) as! iPadMoreCell
            (cell as! iPadMoreCell).populate(with: _item)
            (cell as! iPadMoreCell).delegate = self
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            // preguntar x iphone
            if(!article.isStory) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1AR_Cell.identifier) as! iPhoneGroupItem_1AR_Cell
                (cell as! iPhoneGroupItem_1AR_Cell).populate(with: _group)
            } else {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1ST_Cell.identifier) as! iPhoneGroupItem_1ST_Cell
                (cell as! iPhoneGroupItem_1ST_Cell).populate(with: _group)
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
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            result = 30
        } else if let _item = dpItem as? DataProviderMoreItem {
            result = 70
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            // preguntar x iphone
            if(!article.isStory) {
                result = iPhoneGroupItem_1AR_Cell.calculateHeightFor(_group.articles) + 5
            } else {
                result = iPhoneGroupItem_1ST_Cell.calculateHeightFor(_group.articles) + 10
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

extension KeywordSearchViewController: iPadMoreCellDelegate {

    func onShowMoreButtonTap(sender: iPadMoreCell) {
        if(sender.topic=="ST") { // STORIES
            if(KeywordSearch.shared.stories.count == self.storyPages * 4) {
                self.showLoading()
                print("SEARCHING...")
        
                self.storySearchPage += 1
                let T = self.searchTextfield.text()
                
                KeywordSearch.shared.search(T, type: .stories, pageNumber: self.storySearchPage) { (success) in
                    if(success) {
                        self.onShowMoreButtonTap(sender: sender)
                    } else {
                        // show error
                        print("Error en busqueda")
                    }
                    
                    self.hideLoading()
                }
            } else {
                var isStory = false
                for (i, item) in self.dataProvider.enumerated() {
                    if(item is DataProviderGroupItem) {
                        if((item as! DataProviderGroupItem).articles.first!.isStory) {
                            isStory = true
                        }
                    }

                    if(isStory && item is DataProviderMoreItem) {
                        self.dataProvider.remove(at: i)
                        self.addStories(index: i)
                        
                        let moreItem = DataProviderMoreItem(topic: "ST", completed: false)
                        self.dataProvider.insert(moreItem, at: i+4)
                        
                        break
                    }
                }
            
                MAIN_THREAD {
                    self.list.reloadData()
                }
            }
        } else { // ARTICLES
            if(KeywordSearch.shared.articles.count == self.articlePages * 4) {
                self.showLoading()
                print("SEARCHING...")
        
                self.articleSearchPage += 1
                let T = self.searchTextfield.text()
                
                KeywordSearch.shared.search(T, type: .articles, pageNumber: self.articleSearchPage) { (success) in
                    if(success) {
                        //test
                        for (i, AR) in KeywordSearch.shared.articles.enumerated() {
                            print((i+1), AR.title)
                        }
                    
                        self.onShowMoreButtonTap(sender: sender)
                    } else {
                        // show error
                        print("Error en busqueda")
                    }
                    
                    self.hideLoading()
                }
            } else {
                var isStory = true
                for (i, item) in self.dataProvider.enumerated() {
                    if(item is DataProviderGroupItem) {
                        if((item as! DataProviderGroupItem).articles.first!.isStory == false) {
                            isStory = false
                        }
                    }
                    
                    if(isStory == false && item is DataProviderMoreItem) {
                        self.dataProvider.remove(at: i)
                        self.addArticles(index: i)
                        
                        let moreItem = DataProviderMoreItem(topic: "AR", completed: false)
                        self.dataProvider.insert(moreItem, at: i+4)
                        
                        break
                    }
                }
            
                MAIN_THREAD {
                    self.list.reloadData()
                }
            }
        }
    }

}
