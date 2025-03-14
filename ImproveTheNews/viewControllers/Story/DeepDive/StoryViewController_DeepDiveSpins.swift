//
//  Untitled.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/03/2025.
//

import Foundation
import UIKit

extension StoryViewController {

    func showDeepDiveSpins(into vstack: UIStackView, index: Int) {
        let section = self.deepDive!.sections[index]
        self.spins = section.spins
        ADD_SPACER(to: vstack, height: CSS.shared.iPhoneSide_padding)
    
        let HStack = HSTACK(into: vstack)
//        HStack.backgroundColor = .yellow.withAlphaComponent(0.1)
        HStack.tag = 160
        
        let innerHStack = VSTACK(into: HStack)
        
       if(spins.count == 0) {
            let noSpinsLabel = UILabel()
            noSpinsLabel.font = CSS.shared.iPhoneStoryContent_subTitleFont
            if(IPAD()){ noSpinsLabel.font = DM_SERIF_DISPLAY_fixed(19) //MERRIWEATHER_BOLD(19)
            }
            noSpinsLabel.text = "    No spin available"
            noSpinsLabel.textColor = CSS.shared.displayMode().main_textColor
            
            innerHStack.addArrangedSubview(noSpinsLabel)
            
            ADD_SPACER(to: vstack, height: CSS.shared.iPhoneSide_padding)
        } else {
            let titleHStack = HSTACK(into: innerHStack)
            //ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
            
                let SpinsLabel = UILabel()
                SpinsLabel.font = DM_SERIF_DISPLAY_resize(20) //CSS.shared.iPhoneStoryContent_subTitleFont
                if(IPAD()){ SpinsLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
                }
                SpinsLabel.text = "The Spin"
                SpinsLabel.textColor = CSS.shared.displayMode().main_textColor
                titleHStack.addArrangedSubview(SpinsLabel)
                self.addInfoButtonNextTo(label: SpinsLabel, index: 2)
                
            //ADD_SPACER(to: titleHStack, width: CSS.shared.iPhoneSide_padding)
            ADD_SPACER(to: innerHStack, height: 12)
            
            if(IPHONE()) {
                self.addSpins_iPhone(spins, innerHStack: innerHStack, margins: false)
            } else {
                self.addSpins_iPad(spins, innerHStack: innerHStack)
            }
        }
        
        ADD_SPACER(to: vstack, height: CSS.shared.iPhoneSide_padding)
    }

}
