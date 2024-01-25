//
//  MainFeed_v3_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit

extension MainFeed_v3_viewController {

    func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
        self.list.separatorStyle = .none
        self.list.customDelegate = self
        
        let topValue: CGFloat = NavBarView.HEIGHT() + CSS.shared.topicSelector_height

        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue) // navBar + topicSelector
        ])
        
        self.list.register(SpacerCell_v3.self, forCellReuseIdentifier: SpacerCell_v3.identifier)
        self.list.register(iPhoneHeaderCell_v3.self, forCellReuseIdentifier: iPhoneHeaderCell_v3.identifier)
        self.list.register(iPhoneSplitHeaderCell_v3.self, forCellReuseIdentifier: iPhoneSplitHeaderCell_v3.identifier)
        
        self.list.register(iPhoneStory_vImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vImg_cell_v3.identifier)
        self.list.register(iPhoneStory_vTxt_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vTxt_cell_v3.identifier)
        
        self.list.register(iPhoneStory_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneStory_2colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneStory_2colsTxt_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsImgBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsImgBanner_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsTxtBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsTxtBanner_cell_v3.identifier)
        
        
        self.list.register(iPhoneBannerCell_v3.self, forCellReuseIdentifier: iPhoneBannerCell_v3.identifier)
        self.list.register(iPhoneBannerPCCell_v3.self, forCellReuseIdentifier: iPhoneBannerPCCell_v3.identifier)
        self.list.register(iPhoneBannerNLCell_v3.self, forCellReuseIdentifier: iPhoneBannerNLCell_v3.identifier)
        self.list.register(iPhoneMoreCell_v3.self, forCellReuseIdentifier: iPhoneMoreCell_v3.identifier)
        self.list.register(iPhoneFooterCell_v3.self, forCellReuseIdentifier: iPhoneFooterCell_v3.identifier)
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    @objc func refreshList() {
        MAIN_THREAD {
            self.list.reloadData()
        }
    }

}



extension MainFeed_v3_viewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.getCell(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeight(indexPath)
    }
    
}

extension MainFeed_v3_viewController {
    
    func hasColumnBanner(index: Int) -> Bool {
        var result = false
    
        if let _2cols = self.dataProvider[index] as? DP3_iPhoneArticle_2cols {
            for A in _2cols.articles {
                if(A.title == Banner.DEFAULT_TITLE) {
                    result = true
                    break
                }
            }
        }
    
        return result
    }
    
    // Cell(s)
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let item = self.dataProvider[indexPath.row]
        
        if let _groupItem = item as? DP3_groupItem { // Group(s) -------------- //
            if(_groupItem is DP3_iPhoneStory_1Wide) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vImg_cell_v3.identifier)!
//                    if(MUST_SPLIT() == 0) {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vImg_cell_v3.identifier)!
//                    } else {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vTxt_cell_v3.identifier)!
//                    }
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vTxt_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneStory_2cols) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsTxt_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneArticle_2cols) {
                if(self.hasColumnBanner(index: indexPath.row)) {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImgBanner_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxtBanner_cell_v3.identifier)!
                    }
                } else {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)!
                    }
                }
            }
            
            (cell as! GroupItemCell_v3).populate(with: _groupItem)
        } else { // Single cell(s) -------------------------------------------------------- //
            if item is DP3_spacer {
                cell = self.list.dequeueReusableCell(withIdentifier: SpacerCell_v3.identifier)!
                (cell as! SpacerCell_v3).refreshDisplayMode()
            } else if let _item = item as? DP3_headerItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderCell_v3.identifier)!
                (cell as! iPhoneHeaderCell_v3).populate(with: _item)
            } else if let _item = item as? DP3_splitHeaderItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneSplitHeaderCell_v3.identifier)!
                (cell as! iPhoneSplitHeaderCell_v3).populate(with: _item)
            } else if let _item = item as? DP3_more {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneMoreCell_v3.identifier)!
                (cell as! iPhoneMoreCell_v3).populate(with: _item)
                (cell as! iPhoneMoreCell_v3).delegate = self
            } else if item is DP3_banner {
                if(self.data.banner!.isNewsLetter()) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerNLCell_v3.identifier)!
                    (cell as! iPhoneBannerNLCell_v3).populate(with: self.data.banner!)
                } else if(self.data.banner!.isPodcast()) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerPCCell_v3.identifier)!
                    (cell as! iPhoneBannerPCCell_v3).populate(with: self.data.banner!)
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerCell_v3.identifier)!
                    (cell as! iPhoneBannerCell_v3).populate(with: self.data.banner!)
                }
            } else if item is DP3_footer {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneFooterCell_v3.identifier)!
                (cell as! iPhoneFooterCell_v3).refreshDisplayMode()
            }
        }
        
        return cell
    }
    
    ///////////////////////////////////////////////////////////
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        let item = self.dataProvider[indexPath.row]
        var result: CGFloat = 0
        
        if let _item = item as? DP3_spacer {
            result = _item.size
        } else if(item is DP3_headerItem) { // header
            result = (self.getCell(indexPath) as! iPhoneHeaderCell_v3).calculateHeight()
        } else if(item is DP3_splitHeaderItem) { // split header
            result = (self.getCell(indexPath) as! iPhoneSplitHeaderCell_v3).calculateHeight()
        } else if(item is DP3_more) { // more
            result = (self.getCell(indexPath) as! iPhoneMoreCell_v3).calculateHeight()
        } else if(item is DP3_iPhoneStory_1Wide) { // 1 wide story
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPhoneStory_vImg_cell_v3).calculateGroupHeight()
//                if(MUST_SPLIT() == 0) {
//                    result = (self.getCell(indexPath) as! iPhoneStory_vImg_cell_v3).calculateGroupHeight()
//                } else {
//                    result = (self.getCell(indexPath) as! iPhoneStory_vTxt_cell_v3).calculateGroupHeight()
//                }
            } else {
                result = (self.getCell(indexPath) as! iPhoneStory_vTxt_cell_v3).calculateGroupHeight()
            }
        } else if(item is DP3_banner) { // Banners
            if(self.data.banner!.isNewsLetter()) {
                result = (self.getCell(indexPath) as! iPhoneBannerNLCell_v3).calculateHeight()
            } else if(self.data.banner!.isPodcast()) {
                result = (self.getCell(indexPath) as! iPhoneBannerPCCell_v3).calculateHeight()
            } else {
                result = (self.getCell(indexPath) as! iPhoneBannerCell_v3).calculateHeight()
            }
        } else if(item is DP3_iPhoneStory_2cols) { // row: 2 stories
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPhoneStory_2colsImg_cell_v3).calculateGroupHeight()
            } else {
                result = (self.getCell(indexPath) as! iPhoneStory_2colsTxt_cell_v3).calculateGroupHeight()
            }
        } else if(item is DP3_iPhoneArticle_2cols) { // row: 2 articles
            if(self.hasColumnBanner(index: indexPath.row)) {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPhoneArticle_2colsImgBanner_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPhoneArticle_2colsTxtBanner_cell_v3).calculateGroupHeight()
                }
            } else {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPhoneArticle_2colsImg_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPhoneArticle_2colsTxt_cell_v3).calculateGroupHeight()
                }
            }
        } else if(item is DP3_footer) { // footer
            return iPhoneFooterCell_v3.getHeight()
        }
                
        return result.rounded()
    }
    
}

extension MainFeed_v3_viewController: iPhoneMoreCell_v3_delegate {
    
    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3) {
        self.showLoading()

        let topic = sender.topic
        self.data.loadMoreData(topic: topic, bannerClosed: self.bannerClosed) { (error, articlesAdded) in
            if let _error = error {
                // Mostrar algun error?
            } else if let _articlesAdded = articlesAdded {
                let count = self.data.topicsCount[topic]! + _articlesAdded
                
                let A = (count >= MAX_ARTICLES_PER_TOPIC)
                let B = (_articlesAdded == 0)
                
                if(A || B) { self.topicsCompleted[topic] = true }
                
                self.populateDataProvider()
                self.refreshList()
            }

            MAIN_THREAD {
                self.hideLoading()
                self.list.hideRefresher()
                self.refreshList()
            }
            
        }
        
    }
    
}
