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
        
        self.list.register(iPadGroupItem_topCell.self, forCellReuseIdentifier: iPadGroupItem_topCell.identifier)
        
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
        let cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCell.identifier) as! iPadGroupItem_topCell
        cell.populate(with: self.dataProvider[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000 //(IPAD_ITEMS_SEP*3) + 100 + 50 + 50
    }
    
}
