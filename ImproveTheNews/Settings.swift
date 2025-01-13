//
//  Settings.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/11/2023.
//

import Foundation
import UIKit

//////////////////////////////////////////////////
let NEWS_REQ_ITEMS_TOTAL: Int = 9
let NEWS_REQ_STORIES_COUNT: Int = 5
let NEWS_REQ_MORE_ITEMS_TOTAL: Int = 8
let NEWS_REQ_MORE_STORIES_COUNT: Int = 4

let NEWS_REQ_SPLIT_ITEMS_TOTAL: Int = 8
let NEWS_REQ_SPLIT_STORIES_COUNT: Int = 2
let NEWS_REQ_SPLIT_MORE_ITEMS_TOTAL: Int = 8
let NEWS_REQ_SPLIT_MORE_STORIES_COUNT: Int = 2


let MAX_ARTICLES_PER_TOPIC: Int = (NEWS_REQ_MORE_ITEMS_TOTAL * 15) + NEWS_REQ_ITEMS_TOTAL

let SPACER_COLOR: UIColor? = nil //.systemPink
//////////////////////////////////////////////////
func ITN_URL(shorten: Bool = false) -> String {
//    let value = "https://www.improvethenews.org"      // prod 1


//    let value = "https://verity.news"                   // prod 2
    let value = "https://www.improvemynews.com"       // stage

    if(shorten){
        return value.replacingOccurrences(of: "https://", with: "")
    } else {
        return value
    }
}

func BIASPEDIA_URL() -> String {
//    return "https://biaspost.org/api/" // stage
    return "https://biaspedia.org/api/" // prod
}
//////////////////////////////////////////////////
func NAV_MAINFEED_VC(topic: String? = nil) -> UIViewController {
    var vc: UIViewController!
    
//    ControversiesViewController.topic = "us-election-2024"
//    vc = ControversiesViewController()
//    return vc
    
    if(IPHONE()) {
        vc = MainFeed_v3_viewController()
        if(topic != nil){ (vc as! MainFeed_v3_viewController).topic = topic! }
    } else {
        vc = MainFeediPad_v3_viewController()
        if(topic != nil){ (vc as! MainFeediPad_v3_viewController).topic = topic! }
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
