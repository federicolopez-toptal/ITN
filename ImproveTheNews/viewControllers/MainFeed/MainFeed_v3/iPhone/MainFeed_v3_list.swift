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
        
        var topOffset: CGFloat = 0
        if let _safeAreaTop = SAFE_AREA()?.top {
            topOffset += _safeAreaTop
        }
        
        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset()),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topOffset) //, constant: topValue)
        ])
        self.navBar.superview?.bringSubviewToFront(self.navBar)
        self.topicSelector.superview?.bringSubviewToFront(self.topicSelector)
//        self.navBar.alpha = 0.2
//        self.topicSelector.alpha = 0.2
        
        self.list.register(SpacerCell_v3.self, forCellReuseIdentifier: SpacerCell_v3.identifier)
        self.list.register(iPhoneHeaderCell_v3.self, forCellReuseIdentifier: iPhoneHeaderCell_v3.identifier)
        self.list.register(iPhoneHeaderLineCell_v3.self, forCellReuseIdentifier: iPhoneHeaderLineCell_v3.identifier)
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
        
        self.list.register(iPhoneControversyCell_v3.self, forCellReuseIdentifier: iPhoneControversyCell_v3.identifier)
        self.list.register(iPhoneLineSeparatorCell_v3.self, forCellReuseIdentifier: iPhoneLineSeparatorCell_v3.identifier)
        self.list.register(iPhoneStory_vImgDescr_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vImgDescr_cell_v3.identifier)
        self.list.register(iPhoneStory_vTxtDescr_cell_v3.self, forCellReuseIdentifier: iPhoneStory_vTxtDescr_cell_v3.identifier)
        
        self.list.register(newAdCell_v3.self, forCellReuseIdentifier: newAdCell_v3.identifier)
        
        self.list.register(CenteredTextCell.self, forCellReuseIdentifier: CenteredTextCell.identifier)
        self.list.register(iPhoneGoDeeper_2colsImg_cell_v3.self, forCellReuseIdentifier: iPhoneGoDeeper_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneGoDeeper_2colsTxt_cell_v3.self, forCellReuseIdentifier: iPhoneGoDeeper_2colsTxt_cell_v3.identifier)
        
        
        
        self.list.delegate = self
        self.list.dataSource = self
        
//        self.view.addSubview(self.debugText)
//        self.debugText.activateConstraints([
//            self.debugText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32),
//            self.debugText.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -32),
//            self.debugText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32*2),
//            self.debugText.heightAnchor.constraint(equalToConstant: 300)
//        ])
//        self.debugText.backgroundColor = .white
//        self.debugText.text = "Lorem ipsum"
//        
//        self.view.bringSubviewToFront(self.debugText)
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
        //print( indexPath.row, self.dataProvider[indexPath.row] )
        
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
        
        var item: DP3_item? = nil
        if(indexPath.row <= self.dataProvider.count-1) {
            item = self.dataProvider[indexPath.row]
        }
        if(item == nil) {
            return cell
        }
        
        if let _groupItem = item as? DP3_groupItem { // Group(s) -------------- //
            if(_groupItem is DP3_iPhoneStory_1Wide) {
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vImgDescr_cell_v3.identifier)!
//                    if(MUST_SPLIT() == 0) {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vImg_cell_v3.identifier)!
//                    } else {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vTxt_cell_v3.identifier)!
//                    }
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vTxtDescr_cell_v3.identifier)!
                }
            } else if(_groupItem is DP3_iPhoneStory_2cols) {
                if(Layout.current() == .textImages) {
//                    if(indexPath.row == 5) {
//                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)!
//                        (cell as! iPhoneArticle_2colsTxt_cell_v3).customPopulate = true
//                    } else {
                        cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_2colsImg_cell_v3.identifier)!
//                    }
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)!
                    (cell as! iPhoneArticle_2colsTxt_cell_v3).customPopulate = true
                }
            } else if(_groupItem is DP3_iPhoneGoDeeper_2cols) { // GO DEEPER
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGoDeeper_2colsImg_cell_v3.identifier)!
                } else {
//                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGoDeeper_2colsImg_cell_v3.identifier)!
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGoDeeper_2colsTxt_cell_v3.identifier)!
                }
            }
            
            else if(_groupItem is DP3_iPhoneArticle_2cols) {
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
            } else if let _item = item as? DP3_lineSeparator {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneLineSeparatorCell_v3.identifier)!
                (cell as! iPhoneLineSeparatorCell_v3).addLineWith(type: _item.type)
            } else if let _item = item as? DP3_headerItem {
                if(_item.title == "-----") {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderLineCell_v3.identifier)!
                    (cell as! iPhoneHeaderLineCell_v3).refreshDisplayMode()
                    //(cell as! iPhoneHeaderLineCell_v3).populate(with: _item)
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderCell_v3.identifier)!
                    (cell as! iPhoneHeaderCell_v3).populate(with: _item)
                }
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
            } else if let _item = item as? DP3_controversy {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneControversyCell_v3.identifier)!
                (cell as! iPhoneControversyCell_v3).populate(item: _item.controversy)
            } else if let _item = item as? DP3_newAd {
                cell = self.list.dequeueReusableCell(withIdentifier: newAdCell_v3.identifier)!
                (cell as! newAdCell_v3).populateWithType(_item.type)
                //cell.setNeedsDisplay()
            } else if let _item = item as? DP3_text {
                cell = self.list.dequeueReusableCell(withIdentifier: CenteredTextCell.identifier) as! CenteredTextCell
                (cell as! CenteredTextCell).populate(with: _item.text, offsetY: -15)
                (cell as! CenteredTextCell).showLoading(true)
            }
        }
        
        return cell
    }
    
    ///////////////////////////////////////////////////////////
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        var item: DP3_item? = nil
        if(indexPath.row <= self.dataProvider.count-1) {
            item = self.dataProvider[indexPath.row]
        }
        if(item == nil) {
            return 0
        }

        if let _item = item as? DP3_spacer {
            result = _item.size
        //} else if(item is DP3_headerItem) { // header
        } else if let _item = item as? DP3_headerItem { // header
            if(_item.title == "-----") {
                result = iPhoneHeaderLineCell_v3.getHeight()
                //result = (self.getCell(indexPath) as! iPhoneHeaderLineCell_v3).getHeight()
            } else {
                if let _cell = self.getCell(indexPath) as? iPhoneHeaderCell_v3 {
                    result = _cell.calculateHeight()
                }
            }
        } else if(item is DP3_splitHeaderItem) { // split header
            if let _cell = self.getCell(indexPath) as? iPhoneSplitHeaderCell_v3 {
                result = _cell.calculateHeight()
            }
        } else if(item is DP3_more) { // more
            if let _cell = self.getCell(indexPath) as? iPhoneMoreCell_v3 {
                result = _cell.calculateHeight()
            }
        } else if(item is DP3_iPhoneStory_1Wide) { // 1 wide story
            if(Layout.current() == .textImages) {
                if let _cell = self.getCell(indexPath) as? iPhoneStory_vImgDescr_cell_v3 {
                    result = _cell.calculateGroupHeight()
                }
                
//                if(MUST_SPLIT() == 0) {
//                    result = (self.getCell(indexPath) as! iPhoneStory_vImg_cell_v3).calculateGroupHeight()
//                } else {
//                    result = (self.getCell(indexPath) as! iPhoneStory_vTxt_cell_v3).calculateGroupHeight()
//                }
            } else {
                if let _cell = self.getCell(indexPath) as? iPhoneStory_vTxtDescr_cell_v3 {
                    result = _cell.calculateGroupHeight()
                }
            }
        } else if(item is DP3_banner) { // Banners
            if(self.data.banner!.isNewsLetter()) {
                if let _cell = self.getCell(indexPath) as? iPhoneBannerNLCell_v3 {
                    result = _cell.calculateHeight()
                }
            } else if(self.data.banner!.isPodcast()) {
                if let _cell = self.getCell(indexPath) as? iPhoneBannerPCCell_v3 {
                    result = _cell.calculateHeight()
                }
            } else {
                if let _cell = self.getCell(indexPath) as? iPhoneBannerCell_v3 {
                    result = _cell.calculateHeight()
                }
            }
        } else if(item is DP3_iPhoneStory_2cols) { // row: 2 stories
            if(Layout.current() == .textImages) {
//                if(indexPath.row == 5) {
//                    if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsTxt_cell_v3 {
//                        result = _cell.calculateGroupHeight()
//                    }
//                } else {
                    if let _cell = self.getCell(indexPath) as? iPhoneStory_2colsImg_cell_v3 {
                        result = _cell.calculateGroupHeight()
//                    }
                }
            } else {
//                if let _cell = self.getCell(indexPath) as? iPhoneStory_2colsTxt_cell_v3 {
                if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsTxt_cell_v3 {
                    result = _cell.calculateGroupHeight()
                }
            }
        } else if(item is DP3_iPhoneGoDeeper_2cols) { // GO DEEPER
            if(Layout.current() == .textImages) {
                if let _cell = self.getCell(indexPath) as? iPhoneGoDeeper_2colsImg_cell_v3 {
                    result = _cell.calculateGroupHeight()
                }
            } else {
//                if let _cell = self.getCell(indexPath) as? iPhoneGoDeeper_2colsImg_cell_v3 {
                if let _cell = self.getCell(indexPath) as? iPhoneGoDeeper_2colsTxt_cell_v3 {
                    result = _cell.calculateGroupHeight()
                }
            }
        }
        
        else if(item is DP3_iPhoneArticle_2cols) { // row: 2 articles
            if(self.hasColumnBanner(index: indexPath.row)) {
                if(Layout.current() == .textImages) {
                    if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsImgBanner_cell_v3 {
                        result = _cell.calculateGroupHeight()
                    }
                } else {
                    if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsTxtBanner_cell_v3 {
                        result = _cell.calculateGroupHeight()
                    }
                }
            } else {
                if(Layout.current() == .textImages) {
                    if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsImg_cell_v3 {
                        result = _cell.calculateGroupHeight()
                    }
                } else {
                    if let _cell = self.getCell(indexPath) as? iPhoneArticle_2colsTxt_cell_v3 {
                        result = _cell.calculateGroupHeight()
                    }
                }
            }
        } else if(item is DP3_footer) { // footer
            result = iPhoneFooterCell_v3.getHeight()
        } else if(item is DP3_lineSeparator) { // line separator
            result = iPhoneLineSeparatorCell_v3.getHeight()
        } else if(item is DP3_controversy) {
            if let _cell = self.getCell(indexPath) as? iPhoneControversyCell_v3 {
                result = _cell.calculateHeight()
            }
        } else if(item is DP3_newAd) {
            if let _cell = self.getCell(indexPath) as? newAdCell_v3 {
                result = _cell.calculateHeight()
            }
        } else if(item is DP3_text) {
            return CenteredTextCell.height + 10
        } 
        
//        else if let _item = item as? DP3_newAd {
//            
//                
//                cell = self.list.dequeueReusableCell(withIdentifier: newAdCell_v3.identifier)!
//                //(cell as! newAdCell_v3).populate(item: _item.controversy)
//        }
                  
        return result.rounded()
    }
    
}

extension MainFeed_v3_viewController: iPhoneMoreCell_v3_delegate {
    
    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3) {
        self.showLoading()
        let topic = sender.topic
        
        if( topic != self.topic && topic != "godeeper" ) {
            let vc = MainFeed_v3_viewController()
            vc.topic = topic
            
            CustomNavController.shared.tour_old?.cancel()
            CustomNavController.shared.pushViewController(vc, animated: true)
        
            return
        }
        
        if(topic != "godeeper") {
            self.data.loadMoreData(topic: topic, bannerClosed: self.bannerClosed) { (error, articlesAdded) in
                if let _ = error {
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
                    
                    self.refreshList()
                }
                self.hideLoading()
            }
        } else {
            self.goDeeperPage += 1
            self.loadGoDeeper()
        }
    }
    
}
