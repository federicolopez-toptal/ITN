//
//  StoryViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/01/2023.
//

import UIKit
import SDWebImage


class StoryViewController: BaseViewController {
    
    var story: MainFeedArticle?
    var storyData = StoryContent()
    
    let navBar = NavBarView()
    let line = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    var imageHeightConstraint: NSLayoutConstraint? = nil
    
    
    
    
    
    deinit {
        CustomNavController.shared.showPanelAndButtonWithAnimation()
        self.hideLoading()
    }
    
    // MARK: - Init/Start
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.backToFeedIcon])
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.line)
        self.line.backgroundColor = .red
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.line.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .green
        self.VStack.spacing = 8
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -13),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        self.scrollView.hide()
        self.refreshDisplayMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
    
}

// MARK: - Data
extension StoryViewController {
    
    private func loadContent() {
        self.showLoading()
        
        self.storyData.load(url: self.story!.url) { (story) in
            MAIN_THREAD {
                self.hideLoading()
                self.scrollView.show()
                
                if let _story = story {
                    self.addContent(_story)
                }
            }
        }
    }
    
}

// MARK: - Content
extension StoryViewController {

    func addContent(_ story: MainFeedStory) {
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
        
        self.addPill()
        self.addTitle(text: story.title)
        self.addImage(imageUrl: story.image_src)
        
        if(!story.time.isEmpty) {
            self.addTime(time: story.time)
        }
        
        self.addFacts()
        self.populateFacts(facts: story.facts)
        
        // TMP //------------------------------------------
//        self.scrollView.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
//        self.VStack.backgroundColor = .clear

        DELAY(1.0) {
            self.scrollToBottom()
        }
    }

    // ------------------------------------------
    private func populateFacts(facts: [Fact]) {
        let VStack = self.view.viewWithTag(140) as! UIStackView
        VStack.backgroundColor = .systemPink
        REMOVE_ALL_SUBVIEWS(from: VStack)
        ADD_SPACER(to: VStack, height: 15)
        
        if(facts.count==0) {
            let noFactsLabel = UILabel()
            noFactsLabel.font = MERRIWEATHER_BOLD(18)
            noFactsLabel.text = "No facts available"
            noFactsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(noFactsLabel)
        } else {
            let FactsLabel = UILabel()
            FactsLabel.font = MERRIWEATHER_BOLD(18)
            FactsLabel.text = "Facts"
            FactsLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(FactsLabel)
            
            ADD_SPACER(to: VStack, height: 12)
            
            for (i, F) in facts.enumerated() {
                let HStack = HSTACK(into: VStack)
                HStack.backgroundColor = .green
                
                ADD_SPACER(to: HStack, width: 15)

                let dot = UIView()
                dot.backgroundColor = UIColor(hex: 0xFF643C)
                HStack.addSubview(dot)
                dot.activateConstraints([
                    dot.widthAnchor.constraint(equalToConstant: 8),
                    dot.heightAnchor.constraint(equalToConstant: 8),
                    dot.leadingAnchor.constraint(equalTo: HStack.leadingAnchor),
                    dot.topAnchor.constraint(equalTo: HStack.topAnchor, constant: 5)
                ])

                let contentLabel = UILabel()
                contentLabel.numberOfLines = 0
                contentLabel.font = MERRIWEATHER(14)
                //contentLabel.text = F.title
                contentLabel.attributedText = self.attrText(F.title, index: i+1)
                HStack.addArrangedSubview(contentLabel)
                
                ADD_SPACER(to: VStack, height: 5) // separation from next item
            }
            
            ADD_SPACER(to: VStack, height: 15)
            let SourcesLabel = UILabel()
            SourcesLabel.font = MERRIWEATHER_BOLD(18)
            SourcesLabel.text = "Sources"
            SourcesLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
            VStack.addArrangedSubview(SourcesLabel)
            ADD_SPACER(to: VStack, height: 15)
            
            let VStack_sources = VSTACK(into: VStack)
            VStack_sources.spacing = 5
            VStack_sources.backgroundColor = .blue
            //------------------------------------------
            let HSep: CGFloat = 8
            let W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 13 - 13 - HSep
            let sourceHeight: CGFloat = 18
            
            var row = 1
            var val_X: CGFloat = 0
            //------------------------------------------
            for (i, F) in facts.enumerated() {
                let sourceLabel = UILabel()
                sourceLabel.font = ROBOTO(15)
                sourceLabel.backgroundColor = .blue
                sourceLabel.textColor = UIColor(hex: 0xFF643C)
                sourceLabel.text = "[" + String(i+1) + "] " + F.source_title
                print("SOURCE:", sourceLabel.text)
                
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
                    HStack_row.backgroundColor = .yellow
                    
                    if(row>1) {
                        val_X += labelWidth
                    }
                } else {
                    HStack_row =  VStack_sources.arrangedSubviews[row-1] as! UIStackView
                }
                
                HStack_row.addArrangedSubview(sourceLabel)
                if(i+1 == facts.count) { // last item
                    ADD_SPACER(to: HStack_row)
                }
            }
        }
        
        ADD_SPACER(to: VStack, height: 15)
        print("--------------------")
    }
    
    private func addFacts() {
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        let VStack_borders = VSTACK(into: HStack)
        ADD_SPACER(to: HStack, width: 13)
        VStack_borders.layer.borderWidth = 7.0
        VStack_borders.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x1D2530).cgColor : UIColor(hex: 0xE1E3E3).cgColor

        let innerHStack = HSTACK(into: VStack_borders)
        //innerHStack.backgroundColor = .blue
        ADD_SPACER(to: innerHStack, width: 13)
        let innerVStack = VSTACK(into: innerHStack)
        innerVStack.tag = 140
        ADD_SPACER(to: innerHStack, width: 13)
    }
    
    private func addTime(time: String) {
        let updatedLabel = UILabel()
        updatedLabel.font = ROBOTO(14)
        updatedLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
        updatedLabel.text = "Updated " + time
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(updatedLabel)
        ADD_SPACER(to: HStack, width: 13)
    }

    private func addImage(imageUrl: String) {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        self.VStack.addArrangedSubview(imageView)
        self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
        self.imageHeightConstraint?.isActive = true
        
        imageView.sd_setImage(with: URL(string: imageUrl)) { (img, error, cacheType, url) in
            if let _img = img {
                let W: CGFloat = SCREEN_SIZE().width
                let H = (_img.size.height * W)/_img.size.width
                self.imageHeightConstraint?.constant = H
            }
        }
    }

    private func addTitle(text: String) {
        let titleLabel = UILabel()
        titleLabel.font = MERRIWEATHER_BOLD(19)
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 13)
        HStack.addArrangedSubview(titleLabel)
        ADD_SPACER(to: HStack, width: 13)
    }

    private func addPill() {
        let HStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack, width: 10)
        
        let storyPillLabel = UILabel()
        storyPillLabel.backgroundColor = UIColor(hex: 0xFF643C)
        storyPillLabel.textColor = .white
        storyPillLabel.text = "STORY"
        storyPillLabel.textAlignment = .center
        storyPillLabel.font = ROBOTO_BOLD(11)
        storyPillLabel.layer.masksToBounds = true
        storyPillLabel.layer.cornerRadius = 12
        storyPillLabel.addCharacterSpacing(kernValue: 1.0)
        HStack.addArrangedSubview(storyPillLabel)
        storyPillLabel.activateConstraints([
            storyPillLabel.widthAnchor.constraint(equalToConstant: 65),
            storyPillLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        ADD_SPACER(to: HStack)
    }

}

// MARK: - misc + Utils
extension StoryViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func attrText(_ text: String, index: Int) -> NSAttributedString {
        let font = UIFont(name: "Merriweather", size: 14)
        let fontItalic = UIFont(name: "Merriweather-Italic", size: 14)
        //let fontItalic = UIFont(name: "Merriweather-LightItalic", size: 14)
        let extraText = " [" + String(index) + "]"
        let mText = text + extraText
        
        let attr = prettifyText(fullString: mText as NSString, boldPartsOfString: [],
            font: font, boldFont: font, paths: [], linkedSubstrings: [], accented: [])
        
        let mAttr = NSMutableAttributedString(attributedString: attr)
        
        var range = NSRange(location: 0, length: attr.string.count)
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F),
            range: range)
        
        range = NSRange(location: attr.string.count - extraText.count, length: extraText.count)
        
        mAttr.addAttribute(NSAttributedString.Key.foregroundColor,
            value: UIColor(hex: 0xFF643C),
            range: range)
        mAttr.addAttribute(NSAttributedString.Key.font,
            value: fontItalic!,
            range: range)
            
            
        return mAttr
    }
    
    private func prettifyText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, paths: [String], linkedSubstrings: [String], accented: [String]) -> NSAttributedString {

    let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font!, NSAttributedString.Key.foregroundColor: UIColor.label]
    let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
    let accentedAttribute:  [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xD3592D), NSAttributedString.Key.strokeWidth: -5]
    
    let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
    for i in 0 ..< boldPartsOfString.count {
        boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
    }
    for l in 0..<paths.count {
        let sbstrRange = fullString.range(of: linkedSubstrings[l])
        boldString.addAttribute(.link, value: paths[l], range: sbstrRange)
    }
    for a in 0..<accented.count {
        let sbstrRange = fullString.range(of: accented[a])
        
        boldString.addAttributes(accentedAttribute, range: sbstrRange)
    }
    return boldString
}
    
}
