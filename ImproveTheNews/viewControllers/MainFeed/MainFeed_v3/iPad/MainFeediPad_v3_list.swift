//
//  MainFeed_v3_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import Foundation
import UIKit

extension MainFeediPad_v3_viewController {

    func setupList() {
        if(self.list.superview != nil) {
            self.list.removeFromSuperview()
        }        
        self.list = CustomFeedList()
        
        var topOffset: CGFloat = 0
        if let _safeAreaTop = SAFE_AREA()?.top {
            topOffset += _safeAreaTop
        }
        
        self.list.backgroundColor = self.view.backgroundColor
        self.list.separatorStyle = .none
        self.list.customDelegate = self
        
        if(self.topValue == -1) {
            self.topValue = NavBarView.HEIGHT() + CSS.shared.topicSelector_height
        }

//        if(self.prevOffsetY != nil) {
//            self.list.hide()
//        }
        
        self.view.addSubview(self.list)
        self.listAdded = true
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topOffset)
        ])
        self.navBar.superview?.bringSubviewToFront(self.navBar)
        self.topicSelector.superview?.bringSubviewToFront(self.topicSelector)
        
        self.list.register(SpacerCell_v3.self, forCellReuseIdentifier: SpacerCell_v3.identifier)
        self.list.register(iPhoneHeaderCell_v3.self, forCellReuseIdentifier: iPhoneHeaderCell_v3.identifier)
        self.list.register(iPhoneSplitHeaderCell_v3.self, forCellReuseIdentifier: iPhoneSplitHeaderCell_v3.identifier)
        
        self.list.register(iPhoneStory_vImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vImg_cell_v3.identifier)
        self.list.register(iPhoneStory_vTxt_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vTxt_cell_v3.identifier)
        
        self.list.register(iPadStory_vImg_cell_v3.self, forCellReuseIdentifier: iPadStory_vImg_cell_v3.identifier)
        self.list.register(iPadStory_vTxt_cell_v3.self, forCellReuseIdentifier: iPadStory_vTxt_cell_v3.identifier)
        
        
        self.list.register(iPhoneStory_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneStory_4colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneStory_4colsImg_cell_v3.identifier)
        self.list.register(iPhoneStory_2colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneStory_2colsTxt_cell_v3.identifier)
        self.list.register(iPhoneStory_4colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneStory_4colsTxt_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_4colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_4colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsImgBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsImgBanner_cell_v3.identifier)
        self.list.register(iPhoneArticle_4colsImgBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_4colsImgBanner_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)
        self.list.register(iPhoneArticle_4colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_4colsTxt_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsTxtBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_2colsTxtBanner_cell_v3.identifier)
        self.list.register(iPhoneArticle_4colsTxtBanner_cell_v3.self, forCellReuseIdentifier: iPhoneArticle_4colsTxtBanner_cell_v3.identifier)
        
        self.list.register(iPhoneBannerCell_v3.self, forCellReuseIdentifier: iPhoneBannerCell_v3.identifier)
        self.list.register(iPhoneBannerPCCell_v3.self, forCellReuseIdentifier: iPhoneBannerPCCell_v3.identifier)
        self.list.register(iPhoneBannerNLCell_v3.self, forCellReuseIdentifier: iPhoneBannerNLCell_v3.identifier)
        self.list.register(iPhoneMoreCell_v3.self, forCellReuseIdentifier: iPhoneMoreCell_v3.identifier)
        self.list.register(iPadFooterCell_v3.self, forCellReuseIdentifier: iPadFooterCell_v3.identifier)
        
        self.list.register(iPhoneHeaderLineCell_v3.self, forCellReuseIdentifier: iPhoneHeaderLineCell_v3.identifier)
        self.list.register(iPadControversyCell_v3.self, forCellReuseIdentifier: iPadControversyCell_v3.identifier)
        
        self.list.register(iPad5items_type1_cell_v3.self, forCellReuseIdentifier: iPad5items_type1_cell_v3.identifier)
        self.list.register(iPad5items_type2_cell_v3.self, forCellReuseIdentifier: iPad5items_type2_cell_v3.identifier)
        self.list.register(iPad5items_type3_cell_v3.self, forCellReuseIdentifier: iPad5items_type3_cell_v3.identifier)
        self.list.register(iPhoneLineSeparatorCell_v3.self, forCellReuseIdentifier: iPhoneLineSeparatorCell_v3.identifier)
        
        self.list.register(iPad5items_type1txt_cell_v3.self, forCellReuseIdentifier: iPad5items_type1txt_cell_v3.identifier)
        self.list.register(iPad5items_type2txt_cell_v3.self, forCellReuseIdentifier: iPad5items_type2txt_cell_v3.identifier)
        self.list.register(iPad5items_type3txt_cell_v3.self, forCellReuseIdentifier: iPad5items_type3txt_cell_v3.identifier)
        self.list.register(newAdCell_v3.self, forCellReuseIdentifier: newAdCell_v3.identifier)
        
        self.list.delegate = self
        self.list.dataSource = self
        
        DELAY(0.2) {
            if let _middleIndexPath = self.middleIndexPath {
                self.list.scrollToRow(at: _middleIndexPath, at: .middle, animated: false)
            }
        }
        
    }
    
    @objc func refreshList() {
        MAIN_THREAD {
            self.list.reloadData()
        }
    }

}



extension MainFeediPad_v3_viewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension MainFeediPad_v3_viewController {
    
    func has2ColumnBanner(index: Int) -> Bool {
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
    
    func has4ColumnBanner(index: Int) -> Bool {
        var result = false
    
        if let _4cols = self.dataProvider[index] as? DP3_iPhoneArticle_4cols {
            for A in _4cols.articles {
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
            if let _item = _groupItem as? DP3_iPad5items {
                if(_item.type==1) {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type1_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type1txt_cell_v3.identifier)!
                    }
                } else if(_item.type==2) {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type2_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type2txt_cell_v3.identifier)!
                    }
                } else if(_item.type==3) {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type3_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPad5items_type3txt_cell_v3.identifier)!
                    }
                }
            } else if(_groupItem is DP3_iPhoneStory_1Wide) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPadStory_vImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPadStory_vTxt_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneStory_2cols) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsTxt_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneStory_4cols) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_4colsImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_4colsTxt_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneArticle_2cols) {
                if(self.has2ColumnBanner(index: indexPath.row)) {
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
            } else if(_groupItem is DP3_iPhoneArticle_4cols) {
                if(self.has4ColumnBanner(index: indexPath.row)) {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsImgBanner_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsTxtBanner_cell_v3.identifier)!
                    }
                } else {
                    if(Layout.current() == .textImages) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsImg_cell_v3.identifier)!
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsTxt_cell_v3.identifier)!
                    }
                }
            
//                if(self.hasColumnBanner(index: indexPath.row)) {
//                    if(Layout.current() == .textImages) {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImgBanner_cell_v3.identifier)!
//                    } else {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxtBanner_cell_v3.identifier)!
//                    }
//                } else {
//                    if(Layout.current() == .textImages) {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)!
//                    } else {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)!
//                    }
//                }
            }
            
            (cell as! GroupItemCell_v3).populate(with: _groupItem)
        } else { // Single cell(s) -------------------------------------------------------- //
            if item is DP3_spacer {
                cell = self.list.dequeueReusableCell(withIdentifier: SpacerCell_v3.identifier)!
                (cell as! SpacerCell_v3).refreshDisplayMode()
            } else if let _item = item as? DP3_lineSeparator {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneLineSeparatorCell_v3.identifier)!
                (cell as! iPhoneLineSeparatorCell_v3).addLineWith(type: _item.type)
            } else if let _item = item as? DP3_headerItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderCell_v3.identifier)!
                (cell as! iPhoneHeaderCell_v3).populate(with: _item)
                if(indexPath.row == 0) {
                    if(MUST_SPLIT()==0) {
                        (cell as! iPhoneHeaderCell_v3).secTitleLabel.show()
                    } else {
                        (cell as! iPhoneHeaderCell_v3).secTitleLabel.hide()
                    }
                } else {
                    (cell as! iPhoneHeaderCell_v3).secTitleLabel.hide()
                }
            } else if let _item = item as? DP3_splitHeaderItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneSplitHeaderCell_v3.identifier)!
                (cell as! iPhoneSplitHeaderCell_v3).populate(with: _item)
            } else if let _item = item as? DP3_more {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneMoreCell_v3.identifier)!
                (cell as! iPhoneMoreCell_v3).populate(with: _item)
                (cell as! iPhoneMoreCell_v3).delegate = self
            } else if item is DP3_banner {
                if let _banner = self.data.banner {
                    if(_banner.isNewsLetter()) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerNLCell_v3.identifier)!
                        (cell as! iPhoneBannerNLCell_v3).populate(with: self.data.banner!)
                    } else if(_banner.isPodcast()) {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerPCCell_v3.identifier)!
                        (cell as! iPhoneBannerPCCell_v3).populate(with: self.data.banner!)
                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBannerCell_v3.identifier)!
                        (cell as! iPhoneBannerCell_v3).populate(with: self.data.banner!)
                    }
                }
            } else if item is DP3_footer {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadFooterCell_v3.identifier)!
                (cell as! iPadFooterCell_v3).refreshDisplayMode()
            } else if let _item = item as? DP3_controversies_x2 {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadControversyCell_v3.identifier)!
                (cell as! iPadControversyCell_v3).populate(item1: _item.controversy1, item2: _item.controversy2)
            } else if let _item = item as? DP3_newAd {
                cell = self.list.dequeueReusableCell(withIdentifier: newAdCell_v3.identifier)!
                (cell as! newAdCell_v3).populateWithType(_item.type)      
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
            if let _cell = self.getCell(indexPath) as? iPhoneMoreCell_v3 {
                result = _cell.calculateHeight()
            } else {
                result = 13 + 48 + 13
            }
        } else if(item is DP3_iPhoneStory_1Wide) { // 1 wide story
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPadStory_vImg_cell_v3).calculateGroupHeight()
            } else {
                result = (self.getCell(indexPath) as! iPadStory_vTxt_cell_v3).calculateGroupHeight()
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
        } else if(item is DP3_iPhoneStory_4cols) { // row: 4 stories
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPhoneStory_4colsImg_cell_v3).calculateGroupHeight()
            } else {
                result = (self.getCell(indexPath) as! iPhoneStory_4colsTxt_cell_v3).calculateGroupHeight()
            }
        } else if(item is DP3_iPhoneArticle_2cols) { // row: 2 articles
            if(self.has2ColumnBanner(index: indexPath.row)) {
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
        } else if(item is DP3_iPhoneArticle_4cols) { // row: 4 articles
            if(self.has4ColumnBanner(index: indexPath.row)) {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPhoneArticle_4colsImgBanner_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPhoneArticle_4colsTxtBanner_cell_v3).calculateGroupHeight()
                }
            } else {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPhoneArticle_4colsImg_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPhoneArticle_4colsTxt_cell_v3).calculateGroupHeight()
                }
            }
        } else if(item is DP3_footer) { // footer
            return iPadFooterCell_v3.getHeight()
        } else if(item is DP3_lineSeparator) { // line separator
            result = iPhoneLineSeparatorCell_v3.getHeight()
        } else if(item is DP3_controversies_x2) {
            result = (self.getCell(indexPath) as! iPadControversyCell_v3).calculateHeight()
        } else if let _item = item as? DP3_iPad5items {
            if(_item.type==1) {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPad5items_type1_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPad5items_type1txt_cell_v3).calculateGroupHeight()
                }
            } else if(_item.type==2) {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPad5items_type2_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPad5items_type2txt_cell_v3).calculateGroupHeight()
                }
            } else if(_item.type==3) {
                if(Layout.current() == .textImages) {
                    result = (self.getCell(indexPath) as! iPad5items_type3_cell_v3).calculateGroupHeight()
                } else {
                    result = (self.getCell(indexPath) as! iPad5items_type3txt_cell_v3).calculateGroupHeight()
                }
            }
        } else if(item is DP3_newAd) {
            if let _cell = self.getCell(indexPath) as? newAdCell_v3 {
                result = _cell.calculateHeight()
            }
        }
                
        return result.rounded()
    }
    
}

extension MainFeediPad_v3_viewController: iPhoneMoreCell_v3_delegate {
    
    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3) {
        self.showLoading()

        let topic = sender.topic
        if(topic != self.topic) {
            let vc = MainFeediPad_v3_viewController()
            vc.topic = topic
            
            CustomNavController.shared.tour_old?.cancel()
            CustomNavController.shared.pushViewController(vc, animated: true)
        
            return
        }
        
        
        self.data.loadMoreData(topic: topic, bannerClosed: self.bannerClosed) { (error, articlesAdded) in
            if let _error = error {
                // Mostrar algun error?
            } else if let _articlesAdded = articlesAdded {
                let count = self.data.topicsCount[topic]! + _articlesAdded
                let A = (count >= MAX_ARTICLES_PER_TOPIC)
                let B = (_articlesAdded == 0)
                if(A || B) { self.topicsCompleted[topic] = true }
                
                self.populateDataProvider()
                
                if(self.topic == "ai") {
                    self.addControversiesToMainFeed(mustRefresh: false)
                    
                    for (i, DP) in self.dataProvider.enumerated() {
                        if(DP is DP3_more) {
                            self.dataProvider.remove(at: i)
                            break
                        }
                    }
                }
                
//                if(self.controversiesTotal > 0) {
//                    self.addControversiesToMainFeed(mustRefresh: false)
//                }
            }

            MAIN_THREAD {
                self.hideLoading()
                self.list.hideRefresher()
                self.refreshList()
            }
            
        }
        
    }
    
}
