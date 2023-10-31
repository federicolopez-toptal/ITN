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
        
        self.list.register(iPhoneHeader_itemCell.self, forCellReuseIdentifier: iPhoneHeader_itemCell.identifier)
        self.list.register(Spacer_itemCell.self, forCellReuseIdentifier: Spacer_itemCell.identifier)
        self.list.register(iPhoneBigStory_groupItemCell.self, forCellReuseIdentifier: iPhoneBigStory_groupItemCell.identifier)
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    func refreshList() {
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
    
    // Cell(s)
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _dpGroupItem = dpItem as? DP3_groupItem { // Group(s) -------------- //
            if(_dpGroupItem is DP3_iPhoneBigStory) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneBigStory_groupItemCell.identifier) as! iPhoneBigStory_groupItemCell
            }
            
            (cell as! GroupItemCell).populate(with: _dpGroupItem)
        } else { // Single cell(s) -------------------------------------------------------- //
            if(dpItem is DP3_spacer) {
                cell = self.list.dequeueReusableCell(withIdentifier: Spacer_itemCell.identifier) as! Spacer_itemCell
            } else if(dpItem is DP3_headerItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeader_itemCell.identifier) as! iPhoneHeader_itemCell
                (cell as! iPhoneHeader_itemCell).populate(with: (dpItem as! DP3_headerItem))
            }
        }
        
        return cell
    }
    
    ///////////////////////////////////////////////////////////
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        let dpItem = self.dataProvider[indexPath.row]
        var result: CGFloat = 0
        
        if(dpItem is DP3_spacer) {
            result = (dpItem as! DP3_spacer).size
        } else if(dpItem is DP3_headerItem) {
            result = (self.getCell(indexPath) as! iPhoneHeader_itemCell).calculateHeight()
        } else if(dpItem is DP3_iPhoneBigStory) {
            let cell = self.getCell(indexPath) as! iPhoneBigStory_groupItemCell
            result = cell.calculateGroupHeight()
        }
        
        return result
    }
    
}

extension MainFeed_v3_viewController: iPadMoreCellDelegate {
    
    func onShowMoreButtonTap(sender: iPadMoreCell) {
//        self.showLoading()
//
//        let topic = sender.topic
//        self.data.loadMoreData(topic: topic, bannerClosed: self.bannerClosed) { (error, articlesAdded) in
//            let count = self.data.topicsCount[topic]! + 11
//
//            let A = (count >= LOAD_MORE_LIMIT * 11)
//            let B = (articlesAdded == 0)
//
//            if(A || B) {
//                self.topicsCompleted[topic] = true
//            }
//
//            self.populateDataProvider()
//            self.refreshList()
//
//            self.hideLoading()
//            self.list.hideRefresher()
//            self.refreshList()
//        }

    }
    
}
