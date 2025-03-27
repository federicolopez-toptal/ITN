//
//  StoryViewController_newSources.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/03/2025.
//

import Foundation
import UIKit


extension StoryViewController {

    func populateSources() {
        let VStack = self.view.viewWithTag(150) as! UIStackView
        REMOVE_ALL_SUBVIEWS(from: VStack)
        
        let SourcesLabel = UILabel()
        SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(17) //MERRIWEATHER_BOLD(17)
        if(IPAD()){ SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) } //MERRIWEATHER_BOLD(19)

        SourcesLabel.text = "Sources"
        SourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        VStack.addArrangedSubview(SourcesLabel)
        self.addInfoButtonNextTo(label: SourcesLabel, index: 3)
        ADD_SPACER(to: VStack, height: CSS.shared.iPhoneSide_padding)
        
        let HStack_sources = HSTACK(into: VStack)
        ADD_SPACER(to: HStack_sources, width: 8)
        
        let VStack_sources = VSTACK(into: HStack_sources)
        ADD_SPACER(to: HStack_sources, width: 8)
        
        //------------------------------------------
        ADD_SPACER(to: VStack_sources, height: 8)
        VStack_sources.spacing = 16 //+ 8
        
        for (i, currentSource) in self.groupedSources.enumerated() {
            //print("SOURCE", currentItem.0, currentItem.1)
            
            let sourceLabel = UILabel()
            sourceLabel.font = AILERON_resize(16)
            sourceLabel.textColor = CSS.shared.orange
            sourceLabel.text = currentSource.0
            VStack_sources.addArrangedSubview(sourceLabel)
            
            let buttonArea = UIButton(type: .system)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            buttonArea.tag = i
            VStack_sources.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor),
                buttonArea.topAnchor.constraint(equalTo: sourceLabel.topAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: sourceLabel.bottomAnchor)
            ])
            buttonArea.addTarget(self, action: #selector(self.newSourceOnButtonTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc func newSourceOnButtonTap(_ sender: UIButton?) {
        let i = sender!.tag
        let url = self.groupedSources[i].1
        
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: url)
        vc.showComponentsOnClose = false
        CustomNavController.shared.pushViewController(vc, animated: true)
    }

}
