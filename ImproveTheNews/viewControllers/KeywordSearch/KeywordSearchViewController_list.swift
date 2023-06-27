//
//  KeywordSearchViewController_list.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit


extension KeywordSearchViewController {
    
    // MARK: - Start
    func listInit() {
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.listRegisterCells()
        
        self.list.delegate = self
        self.list.dataSource = self
    }
    
    // MARK: - Cell registration
    func listRegisterCells() {
        self.list.register(iPadHeaderCell.self, forCellReuseIdentifier: iPadHeaderCell.identifier)
        self.list.register(iPadSpacerCell.self, forCellReuseIdentifier: iPadSpacerCell.identifier)
        self.list.register(iPhoneGroupItem_1AR_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1AR_Cell.identifier)
        self.list.register(iPhoneGroupItem_1ST_Cell.self, forCellReuseIdentifier: iPhoneGroupItem_1ST_Cell.identifier)
        self.list.register(TopicsCell.self, forCellReuseIdentifier: TopicsCell.identifier)
        self.list.register(CenteredTextCell.self, forCellReuseIdentifier: CenteredTextCell.identifier)
    }
    
    // MARK: - Cell component
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadHeaderCell.identifier) as! iPadHeaderCell
            (cell as! iPadHeaderCell).populate(with: (dpItem as! DataProviderHeaderItem))
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            // preguntar x iphone
            if(!article.isStory) {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1AR_Cell.identifier) as! iPhoneGroupItem_1AR_Cell
                (cell as! iPhoneGroupItem_1AR_Cell).populate(with: _group)
            } else {
                cell = self.list.dequeueReusableCell(withIdentifier: iPhoneGroupItem_1ST_Cell.identifier) as! iPhoneGroupItem_1ST_Cell
                (cell as! iPhoneGroupItem_1ST_Cell).populate(with: _group)
            }

        } else if let _group = dpItem as? DataProviderTopicsItem {
            cell = self.list.dequeueReusableCell(withIdentifier: TopicsCell.identifier) as! TopicsCell
            (cell as! TopicsCell).populate(with: _group.topics)
        } else if let _item = dpItem as? DataProviderSpacer {
            cell = self.list.dequeueReusableCell(withIdentifier: iPadSpacerCell.identifier) as! iPadSpacerCell
            (cell as! iPadSpacerCell).refreshDisplayMode()
        } else if let _item = dpItem as? DataProviderCenteredText {
            cell = self.list.dequeueReusableCell(withIdentifier: CenteredTextCell.identifier) as! CenteredTextCell
            (cell as! CenteredTextCell).populate(with: _item.text, offsetY: -15)
        }
        
        return cell
    }
    
    // MARK: - Cell height
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0
        let dpItem = self.dataProvider[indexPath.row]
        
        if let _ = dpItem as? DataProviderHeaderItem {
            result = 30
        } else if let _group = dpItem as? DataProviderGroupItem {
            let article = _group.articles.first!
            
            // preguntar x iphone
            if(!article.isStory) {
                result = iPhoneGroupItem_1AR_Cell.calculateHeightFor(_group.articles) + 5
            } else {
                result = iPhoneGroupItem_1ST_Cell.calculateHeightFor(_group.articles) + 10
            }
        } else if let _group = dpItem as? DataProviderTopicsItem {
            result = TopicsCell.calculateHeightFor(topics: _group.topics) + 10
        } else if let _item = dpItem as? DataProviderSpacer  {
            return _item.size
        } else if let _ = dpItem as? DataProviderCenteredText {
            return CenteredTextCell.height + 10
        }
        
        return result
    }
    
}
