//
//  NewsLetterContentUI_daily.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/06/2024.
//

import Foundation
import UIKit


extension NewsLetterContentViewController {

    func addDailyContent() {
        self.addDailyTopData()
        self.addDailyStories()
        self.addBottomLinks()
    }
    
    func addDailyStories() {
        let data = self.data as! DailyNewsletter
        
        self.narrativesTag = 333
        for (i, ST) in data.stories.enumerated() {
            ADD_SPACER(to: self.vStack, height: self.M())
            
        // Title
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.font = DM_SERIF_DISPLAY(20)
            titleLabel.text = ST.title
            titleLabel.textColor = CSS.shared.displayMode().main_textColor
            self.addHStackViewWith(subview: titleLabel)
            
        // Image
            ADD_SPACER(to: self.vStack, height: self.M())
            let imageView = CustomImageView()
            self.vStack.addArrangedSubview(imageView)
            imageView.showCorners(true)

            imageView.sd_setImage(with: URL(string: ST.imageUrl)) { (img, error, cacheType, url) in
                if let _img = img {
                    let H = (_img.size.height * self.W())/_img.size.width
                    imageView.activateConstraints([
                        imageView.heightAnchor.constraint(equalToConstant: H)
                    ])
                }
            }
            self.vStack.addArrangedSubview(imageView)
            ADD_SPACER(to: self.vStack, height: 5)
            
        // Image credit
            let creditHStack = UIStackView()
            creditHStack.axis = .horizontal
            creditHStack.spacing = 0
            self.addHStackViewWith(subview: creditHStack)
            
            let photoVStack = VSTACK(into: creditHStack)
            let photoLabel = UILabel()
            photoLabel.font = AILERON(15)
            photoLabel.text = "Photo:"
            photoLabel.textColor = CSS.shared.displayMode().main_textColor
            photoVStack.addArrangedSubview(photoLabel)
            ADD_SPACER(to: photoVStack)
            
            ADD_SPACER(to: creditHStack, width: 5)
            
            let photoCredit = UILabel()
            photoCredit.font = AILERON(15)
            photoCredit.numberOfLines = 0
            photoCredit.text = ST.imageCreditText
            photoCredit.textColor = CSS.shared.orange
            creditHStack.addArrangedSubview(photoCredit)
            
            let creditButton = UIButton(type: .custom)
            //creditButton.backgroundColor = .red.withAlphaComponent(0.25)
            self.contentView.addSubview(creditButton)
            creditButton.activateConstraints([
                creditButton.leadingAnchor.constraint(equalTo: creditHStack.leadingAnchor),
                creditButton.topAnchor.constraint(equalTo: creditHStack.topAnchor),
                creditButton.trailingAnchor.constraint(equalTo: creditHStack.trailingAnchor),
                creditButton.heightAnchor.constraint(equalToConstant: 25)
            ])
            creditButton.tag = i
            creditButton.addTarget(self, action: #selector(imageCreditButtonOnTap(_:)), for: .touchUpInside)
            
        // Facts
            ADD_SPACER(to: self.vStack, height: self.M())
            let factsTitle = UILabel()
            factsTitle.font = DM_SERIF_DISPLAY(20)
            factsTitle.text = "The Facts"
            factsTitle.textColor = CSS.shared.displayMode().main_textColor
            self.addHStackViewWith(subview: factsTitle)
            self.addInfoButtonNextTo(label: factsTitle, index: 1)
            ADD_SPACER(to: self.vStack, height: self.M())
            
            let factsContainer = UIStackView()
            factsContainer.tag = 555 + i
            //factsContainer.backgroundColor = .orange
            factsContainer.axis = .vertical
            factsContainer.spacing = 16
            self.addHStackViewWith(subview: factsContainer)
            self.factsOpened.append(false)
            self.updateFacts(index: i)
            
            ADD_SPACER(to: self.vStack, height: self.M())
            self.addLine()
            
        // Narratives
            ADD_SPACER(to: self.vStack, height: self.M())
            let spinsTitle = UILabel()
            spinsTitle.font = DM_SERIF_DISPLAY(20)
            spinsTitle.text = "The Spin"
            spinsTitle.textColor = CSS.shared.displayMode().main_textColor
            self.addHStackViewWith(subview: spinsTitle)
            ADD_SPACER(to: self.vStack, height: self.M())
            
            if(IPHONE()) {
                self.addNarratives_iPhone(story: ST)
            } else {
                self.addNarratives_iPad(story: ST, index: i)
            }
            
        // Narratives button
            ADD_SPACER(to: self.vStack, height: self.M()/2)
            let nButton = UIButton(type: .custom)
            nButton.titleLabel?.font = AILERON(16)
            nButton.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
            nButton.setTitle("See sources", for: .normal)
            nButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xbbbdc0)
            nButton.layer.cornerRadius = 6.0
            
            nButton.activateConstraints([
                nButton.heightAnchor.constraint(equalToConstant: 50),
                nButton.widthAnchor.constraint(equalToConstant: 150)
            ])
            
            let nButtonContainer = UIView()
//            nButtonContainer.backgroundColor = .orange
            self.addHStackViewWith(subview: nButtonContainer)
            nButtonContainer.activateConstraints([
                nButtonContainer.heightAnchor.constraint(equalToConstant: 50)
            ])
            nButtonContainer.addSubview(nButton)
            nButton.activateConstraints([
                nButton.centerXAnchor.constraint(equalTo: nButtonContainer.centerXAnchor)
            ])
            nButton.tag = i
            nButton.addTarget(self, action: #selector(dailyNarrativeButtonOnTap(_:)), for: .touchUpInside)
            ADD_SPACER(to: self.vStack, height: self.M()*2)
            
            self.addLine()
            ADD_SPACER(to: self.vStack, height: self.M())
        }
    }
    
    func addNarratives_iPad(story: DailyStory, index: Int) {
        var col = 1
        for N in story.narratives {
            if(col == 1) {
                self.narrativesTag += 1
            
                let colsHStack = UIStackView()
                colsHStack.tag = self.narrativesTag
                colsHStack.axis = .horizontal
                colsHStack.spacing = self.M()
                //colsHStack.backgroundColor = .orange
                self.addHStackViewWith(subview: colsHStack)
                
//                colsHStack.activateConstraints([
//                    colsHStack.heightAnchor.constraint(equalToConstant: 50)
//                ])
            }
            // ------------------------
            let _w = self.W()/2-self.M()
            let colsHStack = self.view.viewWithTag(self.narrativesTag) as! UIStackView
            let colView = VSTACK(into: colsHStack)
            //colView.backgroundColor = .red
            colView.activateConstraints([
                colView.widthAnchor.constraint(equalToConstant: _w)
            ])
            
            let nData = self.narrativeData(from: N)
            
            let nTitle = UILabel()
            nTitle.font = DM_SERIF_DISPLAY(20)
            nTitle.numberOfLines = 0
            nTitle.text = nData.0
            nTitle.textColor = CSS.shared.displayMode().sec_textColor
            colView.addArrangedSubview(nTitle)
            
            ADD_SPACER(to: colView, height: self.M())
            
            let nContent = UILabel()
            nContent.font = AILERON(15)
            nContent.numberOfLines = 0
            nContent.text = nData.1
            nContent.textColor = CSS.shared.displayMode().main_textColor
            colView.addArrangedSubview(nContent)
            
            ADD_SPACER(to: colView) // fill empty space
            
            // ------------------------
            if(N == story.narratives.last!) {
                if(col<2) {
                    ADD_SPACER(to: colsHStack, width: _w)
                }
            }
            
            col += 1
            if(col == 3){
                ADD_SPACER(to: self.vStack, height: self.M())
                col = 1
            }
            
//            let nData = self.narrativeData(from: N)
//        
//            let nTitle = UILabel()
//            nTitle.font = DM_SERIF_DISPLAY(20)
//            nTitle.numberOfLines = 0
//            nTitle.text = nData.0
//            nTitle.textColor = CSS.shared.displayMode().sec_textColor
//            self.addHStackViewWith(subview: nTitle)
//            
//            ADD_SPACER(to: self.vStack, height: self.M())
//            
//            let nContent = UILabel()
//            nContent.font = AILERON(15)
//            nContent.numberOfLines = 0
//            nContent.text = nData.1
//            nContent.textColor = CSS.shared.displayMode().main_textColor
//            self.addHStackViewWith(subview: nContent)
//
        }
        
        ADD_SPACER(to: self.vStack, height: self.M())
    }
    
    func addNarratives_iPhone(story: DailyStory) {
        for N in story.narratives {
            let nData = self.narrativeData(from: N)
        
            let nTitle = UILabel()
            nTitle.font = DM_SERIF_DISPLAY(20)
            nTitle.numberOfLines = 0
            nTitle.text = nData.0
            nTitle.textColor = CSS.shared.displayMode().sec_textColor
            self.addHStackViewWith(subview: nTitle)
            
            ADD_SPACER(to: self.vStack, height: self.M())
            
            let nContent = UILabel()
            nContent.font = AILERON(15)
            nContent.numberOfLines = 0
            nContent.text = nData.1
            nContent.textColor = CSS.shared.displayMode().main_textColor
            self.addHStackViewWith(subview: nContent)
            
            ADD_SPACER(to: self.vStack, height: self.M())
        }
    }
    
    func updateFacts(index: Int) {
        let data = self.data as! DailyNewsletter
        let facts = data.stories[index].facts
        
        let factsContainer = self.view.viewWithTag(555 + index) as! UIStackView
        factsContainer.removeAllArrangedSubviews()
        REMOVE_ALL_SUBVIEWS(from: factsContainer)
        
        var limit = 2
        if(self.factsOpened[index]){ limit = facts.count }
        
        let vLineBelow = UIView()
        vLineBelow.backgroundColor = CSS.shared.displayMode().factLines_color
        factsContainer.addSubview(vLineBelow)
        vLineBelow.activateConstraints([
            vLineBelow.leadingAnchor.constraint(equalTo: factsContainer.leadingAnchor, constant: 11),
            vLineBelow.topAnchor.constraint(equalTo: factsContainer.topAnchor, constant: 24),
            vLineBelow.bottomAnchor.constraint(equalTo: factsContainer.bottomAnchor),
            vLineBelow.widthAnchor.constraint(equalToConstant: 2.0)
        ])
        
        for i in 1...limit {
            let hStack = HSTACK(into: factsContainer)
            hStack.backgroundColor = .clear
            
            let dot = UIView()
            dot.backgroundColor = CSS.shared.displayMode().main_bgColor
            hStack.addSubview(dot)
            dot.activateConstraints([
                dot.widthAnchor.constraint(equalToConstant: 24),
                dot.heightAnchor.constraint(equalToConstant: 24),
                dot.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: 0),
                dot.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 0)
            ])
            dot.layer.cornerRadius = 12
            dot.layer.borderWidth = 2.0
            dot.layer.borderColor = CSS.shared.displayMode().factLines_color.cgColor
            ADD_SPACER(to: hStack, width: 24+8)
            
            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            contentLabel.font = AILERON(15)
            contentLabel.text = facts[i-1]
            contentLabel.textColor = CSS.shared.displayMode().main_textColor
            hStack.addArrangedSubview(contentLabel)
        }
        ADD_SPACER(to: factsContainer, height: 8)
        
        // Button
        var showMoreText = "Show more"
        if(self.factsOpened[index]) {
            showMoreText = "Show less"
        }
        
        let showMoreButton = UIButton(type: .custom)
        showMoreButton.backgroundColor = CSS.shared.displayMode().main_bgColor
        showMoreButton.titleLabel?.font = AILERON(15)
        showMoreButton.setTitleColor(CSS.shared.orange, for: .normal)
        showMoreButton.setTitle(showMoreText, for: .normal)
        self.addHStackViewWith(subview: showMoreButton)
        showMoreButton.activateConstraints([
            showMoreButton.heightAnchor.constraint(equalToConstant: 50),
            showMoreButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        showMoreButton.tag = index
        showMoreButton.addTarget(self, action: #selector(factsShowMoreButtonOnTap(_:)), for: .touchUpInside)
    }
    
    @objc func factsShowMoreButtonOnTap(_ sender: UIButton?) {
        let index = sender!.tag
        self.factsOpened[index] = !self.factsOpened[index]
        
        var showMoreText = "Show more"
        if(self.factsOpened[index]) {
            showMoreText = "Show less"
        }
        sender!.setTitle(showMoreText, for: .normal)
        
        self.updateFacts(index: index)
    }
    
    @objc func imageCreditButtonOnTap(_ sender: UIButton?) {
        let data = self.data as! DailyNewsletter
        let index = sender!.tag
        OPEN_URL(data.stories[index].imageCreditUrl)
    }
    
    func narrativeData(from text: String) -> (String, String) {
        var title = ""
        var content = ""
        
        for i in 0...text.count-1 {
            if(text[i]==":") {
                title = text.subString(from: 0, count: i-1)!
                content = text.replacingOccurrences(of: title + ":", with: "")
                break
            }
        }
        
        return (title, content)
    }
    
    @objc func dailyNarrativeButtonOnTap(_ sender: UIButton?) {
        let data = self.data as! DailyNewsletter
        let index = sender!.tag
        let strUrl = ITN_URL() + "/" + data.stories[index].slug
        
        let story = MainFeedArticle(url: strUrl)
        let vc = StoryViewController()
        vc.story = story
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func addDailyTopData() {
        let data = self.data as! DailyNewsletter
        
        // Date
        //ADD_SPACER(to: self.vStack, height: self.M())
        let dateLabel = UILabel()
        dateLabel.text = self.formatDate(data.date)
        dateLabel.font = AILERON(15)
        dateLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.addHStackViewWith(subview: dateLabel)
        
        // Title
        ADD_SPACER(to: self.vStack, height: 5)
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY(20)
        titleLabel.text = "Daily Newsletter"
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addHStackViewWith(subview: titleLabel)
    }

}

extension NewsLetterContentViewController {
    
    func addInfoButtonNextTo(label: UILabel, index: Int) {

        if let _superview = label.superview {
            let label2 = UILabel()
            label2.text = label.text
            label2.font = label.font
            label2.textColor = .clear
            _superview.addSubview(label2)
            label2.activateConstraints([
                label2.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                label2.topAnchor.constraint(equalTo: label.topAnchor)
            ])
        
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: DisplayMode.imageName("storyInfo"))
            _superview.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 5),
                iconImageView.centerYAnchor.constraint(equalTo: label2.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 72/3),
                iconImageView.heightAnchor.constraint(equalToConstant: 72/3)
            ])
            
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            _superview.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -5),
                button.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
                button.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5)
            ])
            button.tag = index
            button.addTarget(self, action: #selector(infoButtonOnTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc func infoButtonOnTap(_ sender: UIButton?) {
        if let _sender = sender {
            let index = _sender.tag
            
            let popup = StoryInfoPopupView(title: self.getTitleFrom(index: index),
                    description: self.getDescriptionFrom(index: index),
                    linkedTexts: [], links: [], height: self.getHeightFor(index: index))
                
            popup.pushFromBottom()
        }
    }
    
    func getDescriptionFrom(index: Int) -> String {
        var descr = ""
        
        switch(index) {
            case 1:
                descr = """
        We select the key facts for each story as agreed upon by a wide variety of outlets. Our sources include mainstream and establishment-critical media, public figure posts, and academic publications, among others. Our facts are carefully curated to provide the most important context, stripped of narrative and bias. These are thoroughly fact-checked against the sources by a dedicated team to ensure accuracy.
        """
        
            default:
                NOTHING()
        }
        
        
        return descr
    }
    
    func getTitleFrom(index: Int) -> String {
        switch(index) {
            case 1:
                return "The Facts"
               
            default:
                return ""
        }
    }
    
    func getHeightFor(index: Int) -> CGFloat {
        var result: CGFloat = 0
        
        switch(index) {
            case 1:
                return 280
                
            default:
                NOTHING()
        }
        
        return result
    }
    
    
}
