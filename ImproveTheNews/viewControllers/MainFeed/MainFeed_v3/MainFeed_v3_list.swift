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
        self.list.register(iPhoneStory_vImg_Cell_v3.self, forCellReuseIdentifier: iPhoneStory_vImg_Cell_v3.identifier)
        
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
        let item = self.dataProvider[indexPath.row]
        
        if let _groupItem = item as? DP3_groupItem { // Group(s) -------------- //
            if(_groupItem is DP3_iPhoneBigStory) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneStory_vImg_Cell_v3.identifier) as! iPhoneStory_vImg_Cell_v3
            }
            
            (cell as! GroupItemCell_v3).populate(with: _groupItem)
        } else { // Single cell(s) -------------------------------------------------------- //
            if item is DP3_spacer {
                cell = self.list.dequeueReusableCell(withIdentifier: SpacerCell_v3.identifier) as! SpacerCell_v3
            } else if let _item = item as? DP3_headerItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneHeaderCell_v3.identifier) as! iPhoneHeaderCell_v3
                (cell as! iPhoneHeaderCell_v3).populate(with: _item)
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
        } else if(item is DP3_headerItem) {
            result = (self.getCell(indexPath) as! iPhoneHeaderCell_v3).calculateHeight()
        } else if(item is DP3_iPhoneBigStory) {
            result = (self.getCell(indexPath) as! iPhoneStory_vImg_Cell_v3).calculateGroupHeight()
        }
                
        return result.rounded()
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