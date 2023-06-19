//
//  KeywordSearchViewController_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit


extension KeywordSearchViewController {
    
    func listInit() {
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.listRegisterCells()
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    func listRegisterCells() {
        self.list.register(iPadHeaderCell.self, forCellReuseIdentifier: iPadHeaderCell.identifier)
    }
    
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
                (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
        }
        
        return cell
    }
    
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            result = 60
        }
        
        return result
    }
    
}
