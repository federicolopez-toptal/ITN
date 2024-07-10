//
//  NewSliders_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit

extension NewSlidersViewController {
    
    func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
        self.list.separatorStyle = .none
        self.list.customDelegate = self
        
        var topOffset: CGFloat = 0
        if let _safeAreaTop = SAFE_AREA()?.top {
            topOffset += _safeAreaTop
        }
        self.list.fixRefresher_yOffset(topOffset)
        
        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset()),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topOffset) //, constant: topValue)
        ])
        self.navBar.superview?.bringSubviewToFront(self.navBar)
        //self.topicSelector.superview?.bringSubviewToFront(self.topicSelector)
        
        self.registerCells()
        
        self.list.delegate = self
        self.list.dataSource = self 
    }
    
    func registerCells() {
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
//        let cell = self.getCell(indexPath)
//        return cell

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return self.getHeight(indexPath)
        
        return 100
    }
    
}
