//
//  MainFeed_v2_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import Foundation
import UIKit


// ----------------------------------------------------------------------
extension MainFeed_v2ViewController {
    
    func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
        self.list.separatorStyle = .none
        self.list.customDelegate = self
        
        let topValue: CGFloat = NavBarView.HEIGHT() + TopicSelectorView.HEIGHT()

        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue) // navBar + topicSelector
        ])
        
        self.list.register(iPadHeaderCell.self, forCellReuseIdentifier: iPadHeaderCell.identifier)
        self.list.register(iPadGroupItem_topCell.self, forCellReuseIdentifier: iPadGroupItem_topCell.identifier)
        self.list.register(iPadGroupItem_rowCell.self, forCellReuseIdentifier: iPadGroupItem_rowCell.identifier)
        self.list.register(iPadMoreCell.self, forCellReuseIdentifier: iPadMoreCell.identifier)
        self.list.register(iPadGroupItem_splitCell.self, forCellReuseIdentifier: iPadGroupItem_splitCell.identifier)
        self.list.register(iPadSplitHeaderCell.self, forCellReuseIdentifier: iPadSplitHeaderCell.identifier)
        self.list.register(iPadBannerCell.self, forCellReuseIdentifier: iPadBannerCell.identifier)
        self.list.register(iPadFooterCell.self, forCellReuseIdentifier: iPadFooterCell.identifier)
        
        self.list.register(iPadGroupItem_topCellText.self, forCellReuseIdentifier: iPadGroupItem_topCellText.identifier)
        self.list.register(iPadGroupItem_rowCellText.self, forCellReuseIdentifier: iPadGroupItem_rowCellText.identifier)
        self.list.register(iPadGroupItem_splitCellText.self, forCellReuseIdentifier: iPadGroupItem_splitCellText.identifier)
        self.list.register(iPadGroupItem_splitStoriesCell.self, forCellReuseIdentifier: iPadGroupItem_splitStoriesCell.identifier)
        self.list.register(iPadGroupItem_splitStoriesCellText.self,
            forCellReuseIdentifier: iPadGroupItem_splitStoriesCellText.identifier)
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
}

extension MainFeed_v2ViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension MainFeed_v2ViewController {
    
    // CELL(s)
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let dpItem = self.dataProvider[indexPath.row]
    
        if let _dpGroupItem = dpItem as? DataProviderGroupItem { // Group(s)
            if(_dpGroupItem is DataProvideriPadGroup_top) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCell.identifier)
                    as! iPadGroupItem_topCell
            } else if(_dpGroupItem is DataProvideriPadGroup_row) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_rowCell.identifier)
                    as! iPadGroupItem_rowCell
            } else if(_dpGroupItem is DataProvideriPadGroupItem_split) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_splitCell.identifier)
                    as! iPadGroupItem_splitCell
            } else if(_dpGroupItem is DataProvideriPadGroupItem_splitText) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_splitCellText.identifier)
                    as! iPadGroupItem_splitCellText
            } else if(_dpGroupItem is DataProvideriPadGroup_topText) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCellText.identifier)
                    as! iPadGroupItem_topCellText
            } else if(_dpGroupItem is DataProvideriPadGroup_rowText) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_rowCellText.identifier)
                    as! iPadGroupItem_rowCellText
            } else if(_dpGroupItem is DataProvideriPadGroupItem_splitStory) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_splitStoriesCell.identifier)
                    as! iPadGroupItem_splitStoriesCell
            } else if(_dpGroupItem is DataProvideriPadGroupItem_splitStoryText) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_splitStoriesCellText.identifier)
                    as! iPadGroupItem_splitStoriesCellText
            }
            
            // ...
            (cell as! GroupItemCell).populate(with: _dpGroupItem)
        } else { // Single cell(s)
            if(dpItem is DataProviderHeaderItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
                (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
            } else if(dpItem is DataProviderMoreItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadMoreCell.identifier) as! iPadMoreCell
                (cell as! iPadMoreCell).populate(with: (dpItem as! DataProviderMoreItem))
                (cell as! iPadMoreCell).delegate = self
            } else if(dpItem is DataProviderSplitHeaderItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadSplitHeaderCell.identifier) as! iPadSplitHeaderCell
                (cell as! iPadSplitHeaderCell).populate()
            } else if(dpItem is DataProviderBannerItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadBannerCell.identifier) as! iPadBannerCell
                (cell as! iPadBannerCell).populate(with: self.data.banner!)
            } else if(dpItem is DataProviderFooterItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadFooterCell.identifier) as! iPadFooterCell
                (cell as! iPadFooterCell).viewController = self
                (cell as! iPadFooterCell).refreshDisplayMode()
            }
        }
    
        return cell
    }
    
    // SIZE / width
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        let dpItem = self.dataProvider[indexPath.row]
        var result: CGFloat = 0
        
        if(dpItem is DataProviderHeaderItem) {
            result = 60
        } else if(dpItem is DataProviderSplitHeaderItem) {
            result = 50
        } else if(dpItem is DataProvideriPadGroup_top) {
            let count = (dpItem as! DataProvideriPadGroup_top).articles.count
            result = iPadGroupItem_topCell.getHeightForCount(count)
        } else if(dpItem is DataProvideriPadGroup_topText) {
            let count = (dpItem as! DataProvideriPadGroup_topText).articles.count
            result = iPadGroupItem_topCellText.getHeightForCount(count)
        } else if(dpItem is DataProvideriPadGroup_row) {
            result = 350+16
        } else if(dpItem is DataProvideriPadGroup_rowText) {
            result = 250+16
        } else if(dpItem is DataProviderMoreItem) {
            result = 95
        } else if(dpItem is DataProvideriPadGroupItem_split) {
            result = 350
        } else if(dpItem is DataProvideriPadGroupItem_splitText) {
            result = 180
        } else if(dpItem is DataProviderBannerItem) {
            result = iPadBannerCell.heightFor(banner: self.data.banner!)
        } else if(dpItem is DataProviderFooterItem) {
            result = 330
        } else if(dpItem is DataProvideriPadGroupItem_splitStory) {
            let count = (dpItem as! DataProvideriPadGroupItem_splitStory).articles.count
            result = iPadGroupItem_splitStoriesCell.getHeightForCount(count)
        } else if(dpItem is DataProvideriPadGroupItem_splitStoryText) {
            let count = (dpItem as! DataProvideriPadGroupItem_splitStoryText).articles.count
            result = iPadGroupItem_splitStoriesCellText.getHeightForCount(count)
        }
        
        return result
    }
}

extension MainFeed_v2ViewController: iPadMoreCellDelegate {
    func onShowMoreButtonTap(sender: iPadMoreCell) {
        self.showLoading()

        let topic = sender.topic
        self.data.loadMoreData(topic: topic) { (error, articlesAdded) in
            let count = self.data.topicsCount[topic]! + 11
            if(count >= LOAD_MORE_LIMIT * 11) {
                self.topicsCompleted[topic] = true
            }
        
//            if(articlesAdded == 0) { // No more articles
//                self.topicsCompleted[topic] = true
//            }
            
            self.populateDataProvider()
            self.refreshList()
            
            self.hideLoading()
            self.list.hideRefresher()
            self.refreshList()
//            self.list.forceUpdateLayoutForVisibleItems()
//            self.refreshVLine()
        }

    }
}
