//
//  Preferences_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import Foundation
import UIKit


enum PreferenceItem {
    case checkboxes
}

extension PreferencesViewController {

    func getCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let item = self.dataProvider[indexPath.row]
        
        if(item == .checkboxes) {
            cell = self.list.dequeueReusableCell(withIdentifier: PrefCheckboxes_cell.identifier,
                for: indexPath) as! PrefCheckboxes_cell
        }
        
        return cell
    }
    
    func getCellHeight(_ indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 10
        let item = self.dataProvider[indexPath.row]
        
        if(item == .checkboxes) {
            result = PrefCheckboxes_cell.heigth
        }
        
        return result
    }

}
