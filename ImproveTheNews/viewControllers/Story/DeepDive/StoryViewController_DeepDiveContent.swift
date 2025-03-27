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
                vLineBelow.bottomAnchor.constraint(equalTo: HStack.bottomAnchor, constant: extraH+16+31),
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
            
            // Fact multiple sources ---
                ADD_SPACER(to: vstack, height: 16)
                let hStackSources = HSTACK(into: vstack)
                hStackSources.heightAnchor.constraint(equalToConstant: 31).isActive = true
                ADD_SPACER(to: hStackSources, width: 35)
                let hStackSources2 = HSTACK(into: hStackSources)
                hStackSources2.backgroundColor = CSS.shared.displayMode().main_bgColor
                hStackSources2.heightAnchor.constraint(equalToConstant: 31).isActive = true
                
                let cSources = CollapsableSources_v2(buildInto: hStackSources2, sources: F.sources)
                self.collapsableFactSources.append(cSources)
            // Fact multiple sources ---
            
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
        ADD_SPACER(to: vstack, height: 16)
        
        let SourcesLabel = UILabel()
        SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(17) //MERRIWEATHER_BOLD(17)
        if(IPAD()){ SourcesLabel.font = DM_SERIF_DISPLAY_fixed_resize(19) } //MERRIWEATHER_BOLD(19)

        SourcesLabel.text = "Sources"
        SourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        vstack.addArrangedSubview(SourcesLabel)
        
        self.addInfoButtonNextTo(label: SourcesLabel, index: 3)
        ADD_SPACER(to: vstack, height: CSS.shared.iPhoneSide_padding)
        
        let VStack_sources = VSTACK(into: vstack)
        VStack_sources.spacing = 16 //+ 8
        ADD_SPACER(to: VStack_sources, height: 8)
        
        //------------------------------------------
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
        
        ADD_SPACER(to: vstack, height: 16)
        
        /*
    
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
        */
    }
    
    @objc func showMoreOverviewButtonOnTap(_ sender: UIButton) {
        self.show3 = !self.show3
        self.showDeepDiveContent(forIndex: 0)
    }
    
    func showDeepDiveStories(into vstack: UIStackView, width: CGFloat, index: Int) {
        let section = self.deepDive!.sections[index-1]
        
        if(IPAD()) {
            ADD_SPACER(to: vstack, height: 48)
        }
        
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
    
    func showDeepDiveStories_2COLS(into vstack: UIStackView, width: CGFloat, index: Int) {
        ADD_SPACER(to: vstack, height: 16)
        
        let section = self.deepDive!.sections[index-1]
        
        var col = 1
        let _W: CGFloat = (SCREEN_SIZE().width-32-16)/2
        var row: UIStackView?
        
        for (i, AR) in section.stories.enumerated() {
            if(col==1) {
                row = HSTACK(into: vstack)
            } else {
                row = vstack.arrangedSubviews.last as? UIStackView
            }
            
            let newCell = iPhoneAllNews_vTxtCol_v3_B(width: _W, fontSize: 19, useMaxNumLines: false, sourceIconsSize: 28)
            newCell.populate(AR)
            newCell.activateConstraints([
                newCell.widthAnchor.constraint(equalToConstant: _W),
                newCell.heightAnchor.constraint(equalToConstant: newCell.calculateHeight())
            ])
            row!.addArrangedSubview(newCell)
            
            if(col==1) {
                ADD_SPACER(to: row!, width: 16)
            }
            

            let last = section.stories.count-1
            if(i==last && col==1) {
                ADD_SPACER(to: row!)
                break
//                let line = UIView()
//                line.heightAnchor.constraint(equalToConstant: 2).isActive = true
//                ADD_HDASHES(to: line)
//                vstack.addArrangedSubview(line)
            }
            
            col += 1
            if(col==3){
                col = 1
            }
        }
    }
    
    func showDeepDiveSources(into vstack: UIStackView, index: Int) {
        let section = self.deepDive!.sections[index-1]
    
//        self.mediaList = self.mediaList.sorted { // longer strings first
//            $0.count > $1.count
//        }
  
        let sortedMediaList = self.mediaList.sorted(by: { $0.key.count > $1.key.count }) // longer strings first
  
        var sources: [SourceForGraph] = []
        
        print(section.sources.count)
        for SO in section.sources {
            if let _url = URL(string: SO), let _domain = _url.host {
                
                var found = false
                sortedMediaList.forEach { (key, value) in
                    if(!found) {
                        if(_domain.contains(key)) {
                            var name = ""
                            if let _name = Sources.shared.search(identifier: key)?.name {
                                name = _name
                            }
                            
                            let newItem = SourceForGraph(id: key, name: name, url: SO)
                            sources.append(newItem)
                            found = true
                        }
                    }
                }
                
                if(!found) {
                    let newItem = SourceForGraph(id: "unknown", name: _domain, url: SO)
                    sources.append(newItem)
                }
            }
        }

        ADD_SPACER(to: self.deepDiveContent_VStack, height: 16)

        let hStack = HSTACK(into: vstack)
        hStack.backgroundColor = .clear
        
        let sourcesLabel = UILabel()
        sourcesLabel.font = AILERON(16)
        sourcesLabel.text = "Sources:"
        sourcesLabel.textColor = CSS.shared.displayMode().sec_textColor
        hStack.addArrangedSubview(sourcesLabel)
        sourcesLabel.centerYAnchor.constraint(equalTo: hStack.centerYAnchor)
        
        ADD_SPACER(to: hStack, width: 10)
        
//        var extraText: String? = nil
//        let diff = section.sources.count - sources.count
//        if(diff > 0) {
//            extraText = "+" + String(diff)
//        }
        
        let RHStack = HSTACK(into: hStack)
        RHStack.backgroundColor = .clear
//        self.cSourcesView = CollapsableSources(buildInto: RHStack, sources: sources, extraText: extraText)
        self.cSourcesView = CollapsableSources_v2(buildInto: RHStack, sources: sources, showInfoButton: true)
        
        ADD_SPACER(to: self.deepDiveContent_VStack, height: 16)
    }
    
    func addDeepDiveBottomMenu() {
        let C: UIColor = DARK_MODE() ? UIColor(hex: 0x232326) : .white
        let rectView = UIView()
        rectView.backgroundColor = C
        
        self.view.addSubview(rectView)
        rectView.activateConstraints([
            rectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            rectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            rectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset()),
            rectView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        let _W: CGFloat = (SCREEN_SIZE().width/2)-(16*2)
        
    // BACK
        let backView = UIView()
        backView.backgroundColor = C
        rectView.addSubview(backView)
        backView.activateConstraints([
            backView.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 16),
            backView.centerYAnchor.constraint(equalTo: rectView.centerYAnchor),
            backView.widthAnchor.constraint(equalToConstant: _W),
            backView.heightAnchor.constraint(equalToConstant: 44)
        ])
        backView.tag = 973
        
        let backCircleView = UIView()
        backCircleView.backgroundColor = C
        backView.addSubview(backCircleView)
        backCircleView.activateConstraints([
            backCircleView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            backCircleView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            backCircleView.widthAnchor.constraint(equalToConstant: 36),
            backCircleView.heightAnchor.constraint(equalToConstant: 36)
        ])
        backCircleView.layer.cornerRadius = 36/2
        backCircleView.layer.borderWidth = 1.0
        backCircleView.layer.borderColor = CSS.shared.displayMode().sec_textColor.cgColor
        
        let backArrow = UIImageView(image: UIImage(named: DisplayMode.imageName("closeArrow"))?.withRenderingMode(.alwaysTemplate))
        backArrow.tintColor = CSS.shared.displayMode().main_textColor
        backCircleView.addSubview(backArrow)
        backArrow.activateConstraints([
            backArrow.widthAnchor.constraint(equalToConstant: 18),
            backArrow.heightAnchor.constraint(equalToConstant: 18),
            backArrow.centerXAnchor.constraint(equalTo: backCircleView.centerXAnchor),
            backArrow.centerYAnchor.constraint(equalTo: backCircleView.centerYAnchor)
        ])
        
        let backLabel = UILabel()
        backLabel.text = "Back"
        backLabel.textColor = CSS.shared.displayMode().main_textColor
        backLabel.textAlignment = .left
        backLabel.numberOfLines = 0
        backLabel.font = AILERON(14)
        backView.addSubview(backLabel)
        backLabel.activateConstraints([
            backLabel.leadingAnchor.constraint(equalTo: backCircleView.trailingAnchor, constant: 8),
            backLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8),
            backLabel.centerYAnchor.constraint(equalTo: backCircleView.centerYAnchor)
        ])
        
        let backButton = UIButton(type: .system)
        backButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        backView.addSubview(backButton)
        backButton.activateConstraints([
            backButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: backView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        ])
        backButton.tag = -1
        backButton.addTarget(self, action: #selector(self.onDeepDiveMenuButtonTap(_:)), for: .touchUpInside)
        
    //  FORWARD
        let forwardView = UIView()
        forwardView.backgroundColor = C
        rectView.addSubview(forwardView)
        forwardView.activateConstraints([
            forwardView.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -16),
            forwardView.centerYAnchor.constraint(equalTo: rectView.centerYAnchor),
            forwardView.widthAnchor.constraint(equalToConstant: _W),
            forwardView.heightAnchor.constraint(equalToConstant: 44)
        ])
        forwardView.tag = 974
        
        let forwardCircleView = UIView()
        forwardCircleView.backgroundColor = C
        forwardView.addSubview(forwardCircleView)
        forwardCircleView.activateConstraints([
            forwardCircleView.trailingAnchor.constraint(equalTo: forwardView.trailingAnchor),
            forwardCircleView.centerYAnchor.constraint(equalTo: forwardView.centerYAnchor),
            forwardCircleView.widthAnchor.constraint(equalToConstant: 36),
            forwardCircleView.heightAnchor.constraint(equalToConstant: 36)
        ])
        forwardCircleView.layer.cornerRadius = 36/2
        forwardCircleView.layer.borderWidth = 1.0
        forwardCircleView.layer.borderColor = CSS.shared.displayMode().sec_textColor.cgColor
        
        let forwardArrow = UIImageView(image: UIImage(named: DisplayMode.imageName("deployArrow"))?.withRenderingMode(.alwaysTemplate))
        forwardArrow.tintColor = CSS.shared.displayMode().main_textColor
        forwardCircleView.addSubview(forwardArrow)
        forwardArrow.activateConstraints([
            forwardArrow.widthAnchor.constraint(equalToConstant: 18),
            forwardArrow.heightAnchor.constraint(equalToConstant: 18),
            forwardArrow.centerXAnchor.constraint(equalTo: forwardCircleView.centerXAnchor),
            forwardArrow.centerYAnchor.constraint(equalTo: forwardCircleView.centerYAnchor)
        ])
        
        let forwardLabel = UILabel()
        forwardLabel.text = "asdasd asdasdd"
        forwardLabel.textColor = CSS.shared.displayMode().main_textColor
        forwardLabel.textAlignment = .right
        forwardLabel.numberOfLines = 0
        forwardLabel.font = backLabel.font
        forwardView.addSubview(forwardLabel)
        forwardLabel.activateConstraints([
            forwardLabel.leadingAnchor.constraint(equalTo: forwardView.leadingAnchor, constant: 8),
            forwardLabel.trailingAnchor.constraint(equalTo: forwardCircleView.leadingAnchor, constant: -8),
            forwardLabel.centerYAnchor.constraint(equalTo: forwardView.centerYAnchor)
        ])
        
        let forwardButton = UIButton(type: .system)
        forwardButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        forwardView.addSubview(forwardButton)
        forwardButton.activateConstraints([
            forwardButton.leadingAnchor.constraint(equalTo: forwardView.leadingAnchor),
            forwardButton.trailingAnchor.constraint(equalTo: forwardView.trailingAnchor),
            forwardButton.topAnchor.constraint(equalTo: forwardView.topAnchor),
            forwardButton.bottomAnchor.constraint(equalTo: forwardView.bottomAnchor)
        ])
        forwardButton.tag = 1
        forwardButton.addTarget(self, action: #selector(self.onDeepDiveMenuButtonTap(_:)), for: .touchUpInside)
        
        self.view.bringSubviewToFront(rectView)
        self.updateDeepDiveMenu(index: 0)
    }
    
    @objc func onDeepDiveMenuButtonTap(_ sender: UIButton?) {
        let i = self.deepDiveSectionIndex + sender!.tag
        //print(i)
        
        if let _selector = self.view.viewWithTag(367) as? SectionSelector {
            _selector.selectSection(index: i)
        }
        self.updateDeepDiveMenu(index: i, scrollSelector: true)
    }
        
    func updateDeepDiveMenu(index i: Int, scrollSelector: Bool = false) {
        if(scrollSelector) {
            if let _selector = self.view.viewWithTag(367) as? SectionSelector {
                _selector.scrollToItem(index: i)
            }
        }
    
        if let _backView = self.view.viewWithTag(973), let _deepDive = self.deepDive {
            if(i==0) {
                _backView.hide()
            } else {
                for V in _backView.subviews {
                    if let _label = V as? UILabel {
                        if(i==1) {
                            _label.text = "Overview"
                        } else {
                            _label.text = _deepDive.sections[i-2].title
                        }
                    }
                }
            
                _backView.show()
            }
        }
        if let _forwardView = self.view.viewWithTag(974), let _deepDive = self.deepDive {
            if(i==_deepDive.sections.count) {
                _forwardView.hide()
            } else {
                for V in _forwardView.subviews {
                    if let _label = V as? UILabel {
                        _label.text = _deepDive.sections[i].title
                    }
                }
            
                _forwardView.show()
            }
        }
        
        self.showDeepDiveContent(forIndex: i)
    }
}

