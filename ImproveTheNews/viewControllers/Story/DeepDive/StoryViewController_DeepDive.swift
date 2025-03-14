//
//  StoryViewController_DeepDive.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/02/2025.
//

import Foundation
import UIKit


extension StoryViewController {
    
    func deepDiveWidth() -> CGFloat {
        var W: CGFloat = SCREEN_SIZE().width-16-16
        if(IPAD()) {
            var dim = SCREEN_SIZE().width
            if(SCREEN_SIZE().height < dim){ dim = SCREEN_SIZE().height }
            W = dim-16-16
        }
        
        return W
    }
    
    func addDeepDiveSections() {
        if(self.deepDive == nil) {
            return
        }

        ADD_SPACER(to: self.VStack, height: 8)

        let fullWidthContainerView = UIView()
        fullWidthContainerView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.VStack.addArrangedSubview(fullWidthContainerView)
        fullWidthContainerView.activateConstraints([
            fullWidthContainerView.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT)
        ])
        
        let centeredContainerView = UIView()
        centeredContainerView.backgroundColor = CSS.shared.displayMode().main_bgColor
        fullWidthContainerView.addSubview(centeredContainerView)
        centeredContainerView.activateConstraints([
            centeredContainerView.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT),
            centeredContainerView.topAnchor.constraint(equalTo: fullWidthContainerView.topAnchor),
            centeredContainerView.leadingAnchor.constraint(equalTo: fullWidthContainerView.leadingAnchor, constant: 16),
            centeredContainerView.widthAnchor.constraint(equalToConstant: self.deepDiveWidth())
        ])
                
        let selector = SectionSelector()
        selector.buildInto(centeredContainerView)
        selector.delegate = self
        selector.setSections(self.deepDive!.sectionNames())

        ADD_SPACER(to: self.VStack, height: 16)
    }
    
    func addDeepDiveContentStructure() {
        ADD_SPACER(to: self.VStack, height: 16)
        
        let mainView = UIView()
        mainView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.VStack.addArrangedSubview(mainView)
                
        self.deepDiveContent_VStack = VSTACK(into: mainView)
        self.deepDiveContent_VStack.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.deepDiveContent_VStack.activateConstraints([
            self.deepDiveContent_VStack.topAnchor.constraint(equalTo: mainView.topAnchor),
            self.deepDiveContent_VStack.widthAnchor.constraint(equalToConstant: self.deepDiveWidth()),
            //self.deepDiveContent_VStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
            
            self.deepDiveContent_VStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16)
        
  
//            self.deepDiveContent_VStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
//            self.deepDiveContent_VStack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
        ])
        
        mainView.bottomAnchor.constraint(equalTo: self.deepDiveContent_VStack.bottomAnchor).isActive = true
    }
    
}

extension StoryViewController: SectionSelectorViewDelegate {
    
    func onSectionSelected(_ index: Int) {
        self.showDeepDiveContent(forIndex: index)
    }
    
}

extension StoryViewController: UITextViewDelegate {

    func showDeepDiveContent(forIndex index: Int) {
        REMOVE_ALL_SUBVIEWS(from: self.deepDiveContent_VStack)
        
        let sep: CGFloat = 16
        let side: CGFloat = 360
        
        if(IPHONE()) {
            if(index > 0) {
                self.addDeepDiveSection(index: index, width: self.deepDiveWidth(), into: self.deepDiveContent_VStack)
                self.showDeepDiveSources(into: self.deepDiveContent_VStack, index: index)
                self.showDeepDiveStories(into: self.deepDiveContent_VStack, width: side, index: index)
            } else {
                self.showDeepDiveFacts(into: self.deepDiveContent_VStack)
                self.showDeepDiveFactsSources(into: self.deepDiveContent_VStack, width: self.deepDiveWidth())
            }
        } else { // IPAD
            let LWidth = self.deepDiveWidth()-sep-side
        
            let hStack = HSTACK(into: self.deepDiveContent_VStack)
            let LVStack = VSTACK(into: hStack)
            LVStack.widthAnchor.constraint(equalToConstant: LWidth).isActive = true
            //LVStack.backgroundColor = .orange

            if(index > 0) {
                self.addDeepDiveSection(index: index, width: LWidth, into: LVStack)
            } else {
                self.showDeepDiveFacts(into: LVStack)
            }
            
            ADD_SPACER(to: hStack, width: 16)
            let RVStack = VSTACK(into: hStack)
            //RVStack.backgroundColor = .orange
            RVStack.widthAnchor.constraint(equalToConstant: side).isActive = true
            
            if(index==0) {
                self.showDeepDiveFactsSources(into: RVStack, width: side)
            } else {
                self.showDeepDiveStories(into: RVStack, width: side, index: index)
                ADD_SPACER(to: RVStack)
                self.showDeepDiveSources(into: self.deepDiveContent_VStack, index: index)
            }
            
            //ADD_SPACER(to: self.deepDiveContent_VStack, backgroundColor: .green, height: 16)
        }
    }
        
    func addDeepDiveSection(index: Int, width: CGFloat, into vstack: UIStackView) {
        self.deepDiveImageLinks = []
        let section = self.deepDive!.sections[index-1]
                
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY( IPHONE() ? 21 : 32 )
        titleLabel.text = section.title
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        vstack.addArrangedSubview(titleLabel)
        
        for (i, contentItem) in section.newContent.enumerated() {
            if(contentItem.type == "HTML") { // Text
                ADD_SPACER(to: vstack, height: 8)
                //let attributedContent = self.attributedContent(withText: section.content.1)
            print(contentItem.content) //HTML
                
                let attributedContent = self.attributedContent(withText: contentItem.content,
                    bold: (i==0) ? true : false)

                let tmpContentLabel = UILabel()
                tmpContentLabel.numberOfLines = 0
                tmpContentLabel.attributedText = attributedContent
                //tmpContentLabel.textAlignment = .justified

                let contentTextView = UITextView()
                contentTextView.delegate = self
                contentTextView.isScrollEnabled = false
                contentTextView.textContainer.lineFragmentPadding = 0
                contentTextView.textContainerInset = .zero
                //contentTextView.isSelectable = false
                contentTextView.backgroundColor = CSS.shared.displayMode().main_bgColor
                contentTextView.attributedText = attributedContent
                //contentTextView.font = UIFont.systemFont(ofSize: 16)
                contentTextView.tintColor = CSS.shared.displayMode().main_textColor
                //contentTextView.textAlignment = .justified
                vstack.addArrangedSubview(contentTextView)
                contentTextView.activateConstraints([
                    contentTextView.heightAnchor.constraint(equalToConstant: tmpContentLabel.calculateHeightFor(width: width))
                ])
                
//                vstack.addSubview(tmpContentLabel)
//                tmpContentLabel.backgroundColor = .red.withAlphaComponent(0.3)
//                tmpContentLabel.textColor = .red
//                tmpContentLabel.activateConstraints([
//                    tmpContentLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 0),
//                    tmpContentLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: 0),
//                    tmpContentLabel.widthAnchor.constraint(equalTo: contentTextView.widthAnchor)
//                ])
//                vstack.bringSubviewToFront(tmpContentLabel)
                
                //ADD_SPACER(to: vstack, backgroundColor: .orange) // filler
            } else if(contentItem.type == "IMAGE") { // Image
                if let _contentItem_IMG = contentItem as? DeepDiveContent_IMG {
                    let imageView = CustomImageView()
                    imageView.showCorners(false)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    
                    imageView.sd_setImage(with: URL(string: _contentItem_IMG.src)) { (img, error, cacheType, url) in
                        if let _img = img {
                            let img_width: CGFloat = _img.size.width
                            let img_height: CGFloat = _img.size.height
                            let H = (width * img_height)/img_width
                            
                            imageView.heightAnchor.constraint(equalToConstant: H).isActive = true
                        }
                    }
                    vstack.addArrangedSubview(imageView)
                    
                    ADD_SPACER(to: vstack, height: 8)
                    
                let hstackDescr = HSTACK(into: vstack)
                    
                    let vLine = UIView()
                    vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x424345) : UIColor(hex: 0xD6D6D6)
                    vLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
                    hstackDescr.addArrangedSubview(vLine)
                    ADD_SPACER(to: hstackDescr, width: 13)
                    
                    let text = _contentItem_IMG.content + ", Image copyright: " + _contentItem_IMG.linkText
                    let descrLabel = UILabel()
                    self.setLabelAsImageCredit(descrLabel, text: text, boldText: _contentItem_IMG.linkText)
                    hstackDescr.addArrangedSubview(descrLabel)

                    let descrButton = UIButton(type: .system)
                    descrLabel.backgroundColor = .clear
                    vstack.addSubview(descrButton)
                    descrButton.activateConstraints([
                        descrButton.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
                        descrButton.trailingAnchor.constraint(equalTo: descrLabel.trailingAnchor),
                        descrButton.topAnchor.constraint(equalTo: descrLabel.topAnchor),
                        descrButton.bottomAnchor.constraint(equalTo: descrLabel.bottomAnchor)
                    ])
                    descrButton.addTarget(self, action: #selector(descrButtonOnTap(_:)), for: .touchUpInside)
                    self.deepDiveImageLinks.append(_contentItem_IMG.link)
                    descrButton.tag = self.deepDiveImageLinks.count-1

                    ADD_SPACER(to: vstack, height: 12)
                }
            }
        }
        
        // ADDITIONAL INFO
        if(!section.additionalInfo.0.isEmpty && !section.additionalInfo.1.isEmpty) {
            let infoViewHStack = HSTACK(into: vstack)
            infoViewHStack.backgroundColor = .clear
            ADD_SPACER(to: infoViewHStack, width: 24) ///
            
            let infoViewVStack = VSTACK(into: infoViewHStack)
            ADD_SPACER(to: infoViewVStack, height: 24)
            
            let infoTitleLabel = UILabel()
            infoTitleLabel.font = DM_SERIF_DISPLAY(18)
            infoTitleLabel.text = section.additionalInfo.0
            infoTitleLabel.numberOfLines = 0
            infoTitleLabel.textColor = CSS.shared.displayMode().main_textColor
            infoViewVStack.addArrangedSubview(infoTitleLabel)
            ADD_SPACER(to: infoViewVStack, height: 12)
            
            let infoContentLabel = UILabel()
            infoContentLabel.font = AILERON_resize(14)
            infoContentLabel.numberOfLines = 0
            infoContentLabel.text = section.additionalInfo.1
            infoContentLabel.textColor = CSS.shared.displayMode().sec_textColor
            infoViewVStack.addArrangedSubview(infoContentLabel)
            
            ADD_SPACER(to: infoViewVStack, height: 24)
            ADD_SPACER(to: infoViewHStack, width: 24) ///

            let bgView = RectangularDashedView()
            bgView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
            bgView.cornerRadius = 16
            bgView.dashWidth = 1
            bgView.dashColor = CSS.shared.displayMode().sec_textColor
            bgView.dashLength = 5
            bgView.betweenDashesSpace = 5
            
            infoViewHStack.addSubview(bgView)
            bgView.activateConstraints([
                bgView.leadingAnchor.constraint(equalTo: infoViewHStack.leadingAnchor),
                bgView.trailingAnchor.constraint(equalTo: infoViewHStack.trailingAnchor),
                bgView.topAnchor.constraint(equalTo: infoViewHStack.topAnchor),
                bgView.bottomAnchor.constraint(equalTo: infoViewHStack.bottomAnchor)
            ])
            
            infoViewHStack.sendSubviewToBack(bgView)
            ADD_SPACER(to: vstack, height: 16)
        }
        
        ///
        ADD_SPACER(to: vstack)
    }
    
    @objc func descrButtonOnTap(_ sender: UIButton?) {
        if let _index = sender?.tag {
            let link = self.deepDiveImageLinks[_index]
            OPEN_URL(link)
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction) -> Bool {
        
        let _url = URL.absoluteString
        if(_url.contains("/story")) {
            let vc = StoryViewController()
            vc.story = MainFeedArticle(url: URL.absoluteString)
            CustomNavController.shared.pushViewController(vc, animated: true)
        } else {
            let vc = ArticleViewController()
            vc.article = MainFeedArticle(url: _url)
            CustomNavController.shared.pushViewController(vc, animated: true)
        }

        return false
    }
}


extension StoryViewController { // Deep Dive Utils

    func setLabelAsImageCredit(_ label: UILabel, text: String, boldText: String) {
        label.numberOfLines = 0
        label.tintColor = CSS.shared.displayMode().main_textColor
        
        let fullString = text as NSString
        let font = ROBOTO(14)
        let boldFont = ROBOTO_BOLD(14)
        let boldPartsOfString = [boldText as NSString]
        
        let nonBoldFontAttribute = [NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: CSS.shared.displayMode().sec_textColor]
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont,
            NSAttributedString.Key.foregroundColor: CSS.shared.displayMode().main_textColor,
                                 NSAttributedString.Key.underlineStyle: 1] as [NSAttributedString.Key : Any]
        
        let boldString = NSMutableAttributedString(string: fullString as String, attributes: nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        
        label.attributedText = boldString
    }
    
    func attributedContent(withText text: String, bold: Bool = false) -> NSAttributedString? {
        var _text = text.replacingOccurrences(of: "<p></p>", with: "")
        _text = _text.replacingOccurrences(of: "’", with: "'")
        
        let _p_regular_style = " style=\"font-family:Aileron; font-size:13px;\""
        let _p_title_style = " style=\"font-family:Aileron; font-size:15px;\""
        _text = _text.replacingOccurrences(of: "<p>", with: "<p" + _p_regular_style + ">")
        _text = _text.replacingOccurrences(of: "<h3>", with: "<h3" + _p_title_style + "><strong>")
        _text = _text.replacingOccurrences(of: "</h3>", with: "</strong></h3>")
        
        let data = _text.data(using: .utf8)!
        if let attributedText = try? NSMutableAttributedString(data: data,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil) {
            
            let all = NSRange(location: 0, length: attributedText.length)
            
            attributedText.addAttribute(.foregroundColor, value: CSS.shared.displayMode().sec_textColor, range: all)
            attributedText.addAttribute(.backgroundColor, value: CSS.shared.displayMode().main_bgColor, range: all)




//            attributedText.addAttribute(.backgroundColor, value: UIColor.red, range: all)
            
//            attributedText.addAttribute(.font, value: AILERON(14), range: all)
            
//            if(!bold) {
//                attributedText.addAttribute(.font, value: AILERON(16), range: all)
//            } else {
//                attributedText.addAttribute(.font, value: AILERON_BOLD(16), range: all)
//            }
            
            return attributedText
        } else {
            return nil
        }
  
    }
    
}
