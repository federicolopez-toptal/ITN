//
//  CustomCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit

let IPAD_ITEMS_SEP: CGFloat = 16
let IPAD_INNER_MARGIN: CGFloat = 16


func ROBOTO_TEXT() -> UILabel {
    let result = UILabel()
    
    result.backgroundColor = .clear //.red.withAlphaComponent(0.25)
    result.textColor = UIColor(hex: 0x1D242F)
    result.numberOfLines = 0
    result.font = ROBOTO_BOLD(18)
    result.text = "Lorem ipsum"
    
    return result
}

func ARTICLE_TITLE() -> UILabel {
    let result = UILabel()
    
    result.backgroundColor = .clear //.red.withAlphaComponent(0.25)
    result.textColor = UIColor(hex: 0x1D242F)
    result.numberOfLines = 0
    result.font = IPHONE() ? DM_SERIF_DISPLAY_fixed(18) : DM_SERIF_DISPLAY_fixed(20)
    //MERRIWEATHER_BOLD(18) : MERRIWEATHER_BOLD(20)
    result.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
    //result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
    
    return result
}

func ARTICLE_IMG() -> UIImageView {
    let result = UIImageView()
    
    result.backgroundColor = .gray
    result.contentMode = .scaleAspectFill
    result.clipsToBounds = true
    
    return result
}

func STORY_PILL(bgColor: UIColor = UIColor(hex: 0xDA4933), text: String = "STORY")  -> UILabel {
    let result = UILabel()
    result.backgroundColor = bgColor
    result.textColor = .white
    result.text = text
    result.textAlignment = .center
    result.font = AILERON_BOLD(11)
    result.layer.masksToBounds = true
    result.layer.cornerRadius = 12
    result.addCharacterSpacing(kernValue: 1.0)
    
    var W: CGFloat = 65
    if(text != "STORY"){ W = 80 }
    result.activateConstraints([
        result.widthAnchor.constraint(equalToConstant: W),
        result.heightAnchor.constraint(equalToConstant: 23)
    ])
    
    return result
}



// ---------------------------------
// ---------------------------------
class CustomCellView: UIView {

    func populate(_ article: MainFeedArticle) {
    }
    
    func refreshDisplayMode() {
    }
    
    func getHeight(forColumnWidth columnW: CGFloat) -> CGFloat {
        return 1
    }

}
