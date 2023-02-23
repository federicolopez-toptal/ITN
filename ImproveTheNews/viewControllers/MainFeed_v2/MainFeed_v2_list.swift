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
            if(_dpGroupItem is iPadGroupItem_top) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCell.identifier)
                    as! iPadGroupItem_topCell
            } else if(_dpGroupItem is iPadGroupItem_row) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_rowCell.identifier)
                    as! iPadGroupItem_rowCell
            }
            
            (cell as! GroupItemCell).populate(with: _dpGroupItem)
        } else { // Single cell(s)
            if(dpItem is DataProviderHeaderItem) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
                (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
            }
        }
    
    
//        var cell: GroupItemCell!
//        let item = self.dataProvider[indexPath.row]
//
//        if(item is DataProviderGroupItem) {
//            if(item is iPadGroupItem_top) {
//                cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCell.identifier)
//                    as! iPadGroupItem_topCell
//                cell.populate(with: item as! DataProviderGroupItem)
//            }
//        }
//
//        if(item is iPadGroupItem_header) {
//            cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_headerCell.identifier)
//                as! iPadGroupItem_headerCell
//            (cell as! iPadGroupItem_headerCell).customPopulate("SARASA")
//        } else if(item is iPadGroupItem_top) {
//            cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_topCell.identifier)
//                as! iPadGroupItem_topCell
//            cell.populate(with: item)
//        } else if(item is iPadGroupItem_row) {
//            cell = self.list.dequeueReusableCell(withIdentifier: iPadGroupItem_rowCell.identifier)
//                as! iPadGroupItem_rowCell
//            cell.populate(with: item)
//        }
//
        return cell
    }
    
    // SIZE / width
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        let dpItem = self.dataProvider[indexPath.row]
        var result: CGFloat = 0
        
        if(dpItem is DataProviderHeaderItem) {
            result = 60
        } else if(dpItem is iPadGroupItem_top) {
            result = 675
        } else if(dpItem is iPadGroupItem_row) {
            result = 350+16
        }
        
        return result
    }
}
