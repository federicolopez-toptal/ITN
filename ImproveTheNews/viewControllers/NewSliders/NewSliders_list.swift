//
//  NewSliders_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit

extension NewSlidersViewController {
    
    func setupList() {
        if(self.list.superview != nil) {
            self.list.removeFromSuperview()
        }
        self.list = CustomFeedList()
    
        var leadingValue: CGFloat = 0
        if(IPAD()) {
            leadingValue = IPAD_sideOffset()
        }
    
        self.list.backgroundColor = self.view.backgroundColor
        self.list.separatorStyle = .none
        self.list.customDelegate = self
        
        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingValue),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset()),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor,
                constant: NavBarView.HEIGHT() + CSS.shared.topicSelector_height)
        ])
        self.navBar.superview?.bringSubviewToFront(self.navBar)
        //self.topicSelector.superview?.bringSubviewToFront(self.topicSelector)
        
        self.registerCells()
        self.list.delegate = self
        self.list.dataSource = self
        
        if let _parentView = self.slidersPanel.superview {
            _parentView.bringSubviewToFront(self.slidersPanel)
            _parentView.bringSubviewToFront(self.slidersPanel.floatingButton)
        }
        
        let filterImageView = UIImageView(image: UIImage(named: DisplayMode.imageName("filter")))
        self.view.addSubview(filterImageView)
        filterImageView.activateConstraints([
            filterImageView.widthAnchor.constraint(equalToConstant: 32),
            filterImageView.heightAnchor.constraint(equalToConstant: 32),
            filterImageView.topAnchor.constraint(equalTo: self.list.topAnchor, constant: 14),
            filterImageView.trailingAnchor.constraint(equalTo: self.list.trailingAnchor, constant: -16)
        ])
        
        let filterButton = UIButton(type: .custom)
        filterButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.view.addSubview(filterButton)
        filterButton.activateConstraints([
            filterButton.leadingAnchor.constraint(equalTo: filterImageView.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: filterImageView.trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: filterImageView.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: filterImageView.bottomAnchor)
        ])
        filterButton.addTarget(self, action: #selector(filterButtonOnTap(_:)), for: .touchUpInside)
    }
    @objc func filterButtonOnTap(_ sender: UIButton?) {
        var vc: UIViewController!
        if(IPHONE()) {
            vc = SourceFilter_iPhoneViewController()
        }else {
            vc = SourceFilterViewController()
        }
        
        vc.modalPresentationStyle = .fullScreen
        CustomNavController.shared.present(vc, animated: true)
    }
    
    func registerCells() {
        self.list.register(iPhoneArticle_2colsImg_cell_v3.self,
            forCellReuseIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_2colsTxt_cell_v3.self,
            forCellReuseIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)
        
        self.list.register(iPhoneArticle_4colsImg_cell_v3.self,
            forCellReuseIdentifier: iPhoneArticle_4colsImg_cell_v3.identifier)
        self.list.register(iPhoneArticle_4colsTxt_cell_v3.self,
            forCellReuseIdentifier: iPhoneArticle_4colsTxt_cell_v3.identifier)
        
        self.list.register(TopicShownTextCell.self, forCellReuseIdentifier: TopicShownTextCell.identifier)
        self.list.register(iPhoneMoreCell_v3.self, forCellReuseIdentifier: iPhoneMoreCell_v3.identifier)
        self.list.register(iPhoneSplitHeaderCell_v3.self, forCellReuseIdentifier: iPhoneSplitHeaderCell_v3.identifier)
    }
    
    @objc func refreshList() {
        MAIN_THREAD {
            self.list.reloadData()
        }
    }
    
}

// MARK: - CustomFeedListDelegate (List - Pull to Refresh)
extension NewSlidersViewController: CustomFeedListDelegate {

    func feedListOnRefreshPulled(sender: CustomFeedList) {
        self.loadContent()
    }
    func feedListOnScrollToTop(sender: CustomFeedList) {
        // show navBar (?)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewSlidersViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
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
        
        // --------------------------------------------------------
        if let _groupItem = item as? DP3_groupItem { // Group(s) -------------- //
            if(_groupItem is DP3_iPhoneArticle_2cols) { // iPhone, 2 columns
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsImg_cell_v3.identifier)!
                    (cell as! iPhoneArticle_2colsImg_cell_v3).checkSplit = true
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_2colsTxt_cell_v3.identifier)!
                    (cell as! iPhoneArticle_2colsTxt_cell_v3).checkSplit = true
                }
            } else if(_groupItem is DP3_iPhoneArticle_4cols) { // iPhone, 4 columns
                if(Layout.current() == .textImages) {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsImg_cell_v3.identifier)!
                } else {
                    cell = self.list.dequeueReusableCell(withIdentifier: iPhoneArticle_4colsTxt_cell_v3.identifier)!
                }
            }
            
            (cell as! GroupItemCell_v3).populate(with: _groupItem)
        } else { // Single cell(s)  -------------- //
            if let _item = item as? DP3_more {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneMoreCell_v3.identifier)!
                (cell as! iPhoneMoreCell_v3).populate(with: _item)
                (cell as! iPhoneMoreCell_v3).delegate = self
            } else if let _item = item as? DP3_text {
                cell = self.list.dequeueReusableCell(withIdentifier: TopicShownTextCell.identifier)!
                (cell as! TopicShownTextCell).populate(with: _item.text)
            } else if let _item = item as? DP3_splitHeaderItem {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneSplitHeaderCell_v3.identifier)!
                (cell as! iPhoneSplitHeaderCell_v3).populate(with: _item)
            }
        }
        // --------------------------------------------------------
        
        return cell
    }
    
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        var item: DP3_item? = nil
        if(indexPath.row <= self.dataProvider.count-1) {
            item = self.dataProvider[indexPath.row]
        }
        if(item == nil) {
            return 0
        }

        // --------------------------------------------------------
        if(item is DP3_iPhoneArticle_2cols) { // iPhone - 2 rows articles
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPhoneArticle_2colsImg_cell_v3).calculateGroupHeight()
            } else {
                result = (self.getCell(indexPath) as! iPhoneArticle_2colsTxt_cell_v3).calculateGroupHeight()
            }
        } else if(item is DP3_iPhoneArticle_4cols) { // iPhone - 4 rows articles
            if(Layout.current() == .textImages) {
                result = (self.getCell(indexPath) as! iPhoneArticle_4colsImg_cell_v3).calculateGroupHeight()
            } else {
                result = (self.getCell(indexPath) as! iPhoneArticle_4colsTxt_cell_v3).calculateGroupHeight()
            }
        } else if(item is DP3_more) { // more
            result = (self.getCell(indexPath) as! iPhoneMoreCell_v3).calculateHeight()
        } else if(item is DP3_text) { // Topic shown
            result = TopicShownTextCell.height
        } else if(item is DP3_splitHeaderItem) { // split header
            result = (self.getCell(indexPath) as! iPhoneSplitHeaderCell_v3).calculateHeight()
        }
        
        // --------------------------------------------------------
                
        return result.rounded()
    }
    
}

extension NewSlidersViewController: iPhoneMoreCell_v3_delegate {
    
    func onShowMoreButtonTap(sender: iPhoneMoreCell_v3) {
        self.showLoading()
        let topic = sender.topic
        
        self.data.loadMoreArticlesData(topic: topic, amount: self.articlesPerLoad) { (error, addedCount) in
            if let _ = error {
                // Mostrar algun error?
            } else if let _addedCount = addedCount {
                let count = self.data.topicsCount[topic]! + _addedCount
                let A = (count >= MAX_ARTICLES_PER_TOPIC)
                let B = (_addedCount == 0)
                if(A || B) { self.topicsCompleted[topic] = true }
                
                self.populateDataProvider()
                self.refreshList()
            }
            
            self.hideLoading()
        }

    }
    
}
