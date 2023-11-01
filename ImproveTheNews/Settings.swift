//
//  Settings.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/11/2023.
//

import Foundation
import UIKit


func NAV_MAINFEED_VC() -> UIViewController {
    var vc: UIViewController!
        
    if(IPHONE()) {
//        vc = MainFeedViewController()
        vc = MainFeed_v3_viewController()
    } else {
        vc = MainFeed_v2ViewController()
    }
    
    return vc
}
