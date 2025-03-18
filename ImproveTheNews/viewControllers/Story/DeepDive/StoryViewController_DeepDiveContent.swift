//
//  StoryViewController_DeepDiveContent.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/02/2025.
//

import Foundation
import UIKit

extension StoryViewController {
    
    func showDeepDiveFacts(into vstack: UIStackView) {
    // TITLE
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY( IPHONE() ? 21 : 32 )
        titleLabel.text = "Overview"
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        vstack.addArrangedSubview(titleLabel)
        self.addInfoButtonNextTo(label: titleLabel, index: 1)
        
    // FACTS
        ADD_SPACER(to: vstack, height: 16)
        
        let lineColor: UIColor = CSS.shared.displayMode().factLines_color
        for (i, F) in self.facts.enumerated() {
            if(i==0) {
                let hStackZero = HSTACK(into: vstack)
                ADD_SPACER(to: hStackZero, height: 24)
                
                let vLine = UIView()
                vLine.backgroundColor = lineColor
                hStackZero.addSubview(vLine)
                vLine.activateConstraints([
                    vLine.leadingAnchor.constraint(equalTo: hStackZero.leadingAnchor, constant: 11),
                    vLine.topAnchor.constraint(equalTo: hStackZero.topAnchor),
                    vLine.bottomAnchor.constraint(equalTo: hStackZero.bottomAnchor),
                    vLine.widthAnchor.constraint(equalToConstant: 2.0)
                ])
            }
            
            let HStack = HSTACK(into: vstack)
            HStack.backgroundColor = .clear //.orange
            ADD_SPACER(to: HStack, width: 34)

            let dot = UIView()
            dot.backgroundColor = HStack.backgroundColor
            HStack.addSubview(dot)
            dot.activateConstraints([
                dot.widthAnchor.constraint(equalToConstant: 24),
                dot.heightAnchor.constraint(equalToConstant: 24),
                dot.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 0),
                dot.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 0)
            ])
            dot.layer.cornerRadius = 12
            dot.layer.borderWidth = 2.0
            dot.layer.borderColor = lineColor.cgColor
            
            let extraH: CGFloat = 16
            let vLineBelow = UIView()
            vLineBelow.backgroundColor = lineColor
            HStack.addSubview(vLineBelow)
            vLineBelow.activateConstraints([
                vLineBelow.leadingAnchor.constraint(equalTo: HStack.leadingAnchor, constant: 11),
                vLineBelow.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 24),
                vLineBelow.bottomAnchor.constraint(equalTo: HStack.bottomAnchor, constant: extraH),
                vLineBelow.widthAnchor.constraint(equalToConstant: 2.0)
            ])

            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            contentLabel.font = AILERON_resize(16)
            contentLabel.attributedText = self.attrText(F.title, index: F.sourceIndex+1)
            contentLabel.setLineSpacing(lineSpacing: 7.0)
            HStack.addArrangedSubview(contentLabel)
            
            let numberButton = UIButton(type: .custom)
            numberButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            HStack.addSubview(numberButton)
            numberButton.activateConstraints([
                numberButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
                numberButton.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor),
                numberButton.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor),
                numberButton.heightAnchor.constraint(equalToConstant: 25)
            ])
            numberButton.tag = 77 + F.sourceIndex
            numberButton.addTarget(self, action: #selector(numberButtonOnTap(_:)), for: .touchUpInside)
            
            ADD_SPACER(to: vstack, height: 24) // separation from next item
            
            if(self.show3 && i==2) {
                self.lastSourceIndex =  F.sourceIndex
                break
            }
        }
        
        ADD_SPACER(to: vstack, height: 16)
            
        let showMoreLabel = UILabel()
        showMoreLabel.textColor = CSS.shared.orange
        showMoreLabel.textAlignment = .center
        showMoreLabel.font = CSS.shared.iPhoneStoryContent_textFont
        showMoreLabel.text = self.show3 ? "Show More" : "Show Fewer Facts"
        vstack.addArrangedSubview(showMoreLabel)
        
        let showMoreButton = UIButton(type: .custom)
        vstack.addSubview(showMoreButton)
        showMoreButton.activateConstraints([
            showMoreButton.heightAnchor.constraint(equalToConstant: 22),
            showMoreButton.widthAnchor.constraint(equalToConstant: 180),
            showMoreButton.centerXAnchor.constraint(equalTo: showMoreLabel.centerXAnchor),
            showMoreButton.centerYAnchor.constraint(equalTo: showMoreLabel.centerYAnchor)
        ])
        showMoreButton.addTarget(self, action: #selector(showMoreOverviewButtonOnTap(_:)), for: .touchUpInside)
    }
     
    func showDeepDiveFactsSources(into vstack: UIStackView, width: CGFloat) {
    // SOURCES
        ADD_SPACER(to: vstack, height: 16)
        let SourcesLabel = UILabel()
        SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(17) //MERRIWEATHER_BOLD(17)
        if(IPAD()){ SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) //MERRIWEATHER_BOLD(19)
        }
        SourcesLabel.text = "Sources"
        SourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        vstack.addArrangedSubview(SourcesLabel)
        
        self.addInfoButtonNextTo(label: SourcesLabel, index: 3)
        ADD_SPACER(to: vstack, height: 16)
                
        let VStack_sources = VSTACK(into: vstack)
        VStack_sources.spacing = CSS.shared.iPhoneSide_padding
        //------------------------------------------
        let HSep: CGFloat = 12
        //let W: CGFloat = SCREEN_SIZE().width - 12 - 12 - 13 - 13 - 8 - 8 - HSep
        let W: CGFloat = width
        var sourceHeight: CGFloat = 18
        
        let tmpLabel = UILabel()
        tmpLabel.font = AILERON_resize(16)
        tmpLabel.text = "ABC"
        sourceHeight = tmpLabel.calculateHeightFor(width: SCREEN_SIZE().width/2)
        
        var row = 1
        var val_X: CGFloat = 0
        //------------------------------------------
        var groupedSourcesCopy = [(String, String)]()
        let letters = "abcdefghijklmnopqrstuvwxyz"
        
        for S in self.groupedSources {
            var total = 0
            var current = -1
            for _tmp in self.groupedSources {
                if(_tmp.0 == S.0) {
                    if(_tmp.1 == S.1) {
                        current = total
                    }
                    total += 1
                }
            }
            
            var title = S.0
            let url = S.1
            
            if(total>1) {
                title = S.0 + " (" + letters.getCharAt(index: current)! + ")"
            }
            groupedSourcesCopy.append( (title, url) )
        }
        
        for (i, S) in groupedSourcesCopy.enumerated() {
            let sourceLabel = UILabel()
            sourceLabel.font = AILERON_resize(16) //CSS.shared.iPhoneStoryContent_textFont //ROBOTO(15)
            //sourceLabel.backgroundColor = .blue
            sourceLabel.textColor = CSS.shared.orange
            sourceLabel.text = "[" + String(i+1) + "] " + S.0
            //print("SOURCE:", sourceLabel.text)
            
            sourceLabel.heightAnchor.constraint(equalToConstant: sourceHeight).isActive = true
            let labelWidth = sourceLabel.calculateWidthFor(height: sourceHeight)
            sourceLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            
            var limit = val_X + labelWidth
            if(val_X > 0) { limit += HSep }
            if(limit > W) {
                let HStack_row =  VStack_sources.arrangedSubviews[row-1] as! UIStackView
                ADD_SPACER(to: HStack_row)
                
                row += 1
                val_X = 0
            } else {
                if(val_X == 0) {
                    val_X += labelWidth
                } else {
                    val_X += HSep + labelWidth
                }
            }
            
            var HStack_row: UIStackView
            if(VStack_sources.arrangedSubviews.count < row) {
                HStack_row = HSTACK(into: VStack_sources)
                HStack_row.spacing = HSep
                //HStack_row.backgroundColor = .yellow
                
                if(row>1) {
                    val_X += labelWidth
                }
            } else {
                HStack_row =  VStack_sources.arrangedSubviews[row-1] as! UIStackView
            }
            
            HStack_row.addArrangedSubview(sourceLabel)
            
            var isLast = false
            //if(self.show3 && i==self.lastSourceIndex){ isLast = true }
            if( (i+1 == self.groupedSources.count) || isLast) { // last item
                ADD_SPACER(to: HStack_row)
            }
            
            let sourceButton = UIButton(type: .system)
            //sourceLabel.backgroundColor = .blue.withAlphaComponent(0.3)
            HStack_row.addSubview(sourceButton)
            sourceButton.activateConstraints([
                sourceButton.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
                sourceButton.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor),
                sourceButton.topAnchor.constraint(equalTo: sourceLabel.topAnchor),
                sourceButton.bottomAnchor.constraint(equalTo: sourceLabel.bottomAnchor)
            ])
            sourceButton.tag = 200 + i
            sourceButton.addTarget(self, action: #selector(sourceButtonOnTap(_:)), for: .touchUpInside)
            
            if(isLast) {
                break
            }
        }
        
        ADD_SPACER(to: vstack, height: 16)
    }
    
    @objc func showMoreOverviewButtonOnTap(_ sender: UIButton) {
        self.show3 = !self.show3
        self.showDeepDiveContent(forIndex: 0)
    }
    
    func showDeepDiveStories(into vstack: UIStackView, width: CGFloat, index: Int) {
        let section = self.deepDive!.sections[index-1]
        
        for (i, AR) in section.stories.enumerated() {
            var fontSize: CGFloat = 24
            if(IPAD()){ fontSize = 20 }
        
            let newCell = iPhoneAllNews_vTxtCol_v3_B(width: width, fontSize: fontSize, useMaxNumLines: false)
            newCell.populate(AR)
            newCell.heightAnchor.constraint(equalToConstant: newCell.calculateHeight()).isActive = true
            vstack.addArrangedSubview(newCell)
            
            let last = section.stories.count-1
            if(i<last) {
                let line = UIView()
                line.heightAnchor.constraint(equalToConstant: 2).isActive = true
                ADD_HDASHES(to: line)
                vstack.addArrangedSubview(line)
            }
        }
    }
    
    func showDeepDiveSources(into vstack: UIStackView, index: Int) {
        let section = self.deepDive!.sections[index-1]
    
        self.mediaList = self.mediaList.sorted { // longer strings first
            $0.count > $1.count
        }

        var sources: [SourceForGraph] = []
        for (i, SO) in section.sources.enumerated() {
            if let _url = URL(string: SO), let _domain = _url.host {
                for ME in self.mediaList {
                    if(_domain.contains(ME)) {
                        
                        var name = ""
                        if let _name = Sources.shared.search(identifier: ME)?.name {
                            name = _name
                        }
                        
                        let newItem = SourceForGraph(id: ME, name: name, url: SO)
                        sources.append(newItem)
                        break
                    }
                }
            }
            
            if(sources.count == 3) {
                break
            }
            //print("-----")
        }
            
        ADD_SPACER(to: self.deepDiveContent_VStack, height: 16)

        let hStack = HSTACK(into: vstack)
        hStack.backgroundColor = .clear
        
        let sourcesLabel = UILabel()
        sourcesLabel.font = AILERON(16)
        sourcesLabel.text = "Sources:  "
        sourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        hStack.addArrangedSubview(sourcesLabel)
        sourcesLabel.centerYAnchor.constraint(equalTo: hStack.centerYAnchor)
        
        var extraText: String? = nil
        let diff = section.sources.count - sources.count
        if(diff > 0) {
            extraText = "+" + String(diff)
        }
        
        let RHStack = HSTACK(into: hStack)
        RHStack.backgroundColor = .clear
        self.cSourcesView = CollapsableSources(buildInto: RHStack, sources: sources, extraText: extraText)
        ADD_SPACER(to: self.deepDiveContent_VStack, height: 16)
    }
}

