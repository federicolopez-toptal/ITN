//
//  Settings.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/11/2023.
//

import Foundation
import UIKit

//////////////////////////////////////////////////
let NEWS_INIT_REQ_COUNT: Int = 9
let NEWS_INIT_REQ_STORIES: Int = 5

let NEWS_MORE_REQ_COUNT: Int = 8
let NEWS_MORE_REQ_STORIES: Int = 4

let MAX_ARTICLES_PER_TOPIC: Int = (NEWS_MORE_REQ_COUNT * 15) + NEWS_INIT_REQ_COUNT

let SPACER_COLOR: UIColor? = nil //.systemPink
//////////////////////////////////////////////////
func ITN_URL() -> String {
    return "https://www.improvemynews.com"
}

func BIASPEDIA_URL() -> String {
    return "https://biaspedia.org/api/"
}
//////////////////////////////////////////////////
func NAV_MAINFEED_VC() -> UIViewController {
    var vc: UIViewController!
        
    if(IPHONE()) {
        //vc = MainFeedViewController()
        vc = MainFeed_v3_viewController()
    } else {
        vc = MainFeed_v2ViewController()
    }
    
    return vc
}




/*
    vc = MainFeedViewController()
    vc = MainFeed_v3_viewController()

    return "https://www.improvemynews.com"
    return "https://www.improvethenews.org"

    return "https://biaspost.org/api/"
    return "https://biaspedia.org/api/"

    let dict = Bundle.main.infoDictionary!
    return dict["API_BASE_URL"] as! String
*/
