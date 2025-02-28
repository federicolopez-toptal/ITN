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
        self.deepDiveContent_VStack.backgroundColor = CSS.shared.displayMode().main_bgColor //.orange
        self.deepDiveContent_VStack.activateConstraints([
            self.deepDiveContent_VStack.topAnchor.constraint(equalTo: mainView.topAnchor),
            self.deepDiveContent_VStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            self.deepDiveContent_VStack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
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
            let hStack = HSTACK(into: self.deepDiveContent_VStack)
            let LVStack = VSTACK(into: hStack)
            
            if(index > 0) {
                self.addDeepDiveSection(index: index, width: self.deepDiveWidth()-sep-side, into: LVStack)
            } else {
                self.showDeepDiveFacts(into: LVStack)
            }
            
            ADD_SPACER(to: hStack, width: 16)
            let RVStack = VSTACK(into: hStack)
            RVStack.widthAnchor.constraint(equalToConstant: side).isActive = true
            
            if(index==0) {
                self.showDeepDiveFactsSources(into: RVStack, width: side)
            } else {
                self.showDeepDiveStories(into: RVStack, width: side, index: index)
                self.showDeepDiveSources(into: self.deepDiveContent_VStack, index: index)
            }
        }
    }
        
    func addDeepDiveSection(index: Int, width: CGFloat, into vstack: UIStackView) {
        let section = self.deepDive!.sections[index-1]
        
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY( IPHONE() ? 21 : 32 )
        titleLabel.text = section.title
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        vstack.addArrangedSubview(titleLabel)
        
        ADD_SPACER(to: vstack, height: 8)
        let attributedContent = self.attributedContent(withText: section.content.1)

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
        contentTextView.tintColor = CSS.shared.orange
        //contentTextView.textAlignment = .justified
        vstack.addArrangedSubview(contentTextView)
        contentTextView.activateConstraints([
            contentTextView.heightAnchor.constraint(equalToConstant: tmpContentLabel.calculateHeightFor(width: width))
        ])
        
        ADD_SPACER(to: vstack)
    }
    
    func attributedContent(withText text: String) -> NSAttributedString? {
        var _text = text.replacingOccurrences(of: "<p></p>", with: "")
        let data = _text.data(using: .utf8)!
                        
        if let attributedText = try? NSMutableAttributedString(data: data,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil) {
            
            let all = NSRange(location: 0, length: attributedText.length)
            attributedText.addAttribute(.foregroundColor, value: CSS.shared.displayMode().sec_textColor, range: all)
            attributedText.addAttribute(.backgroundColor, value: CSS.shared.displayMode().main_bgColor, range: all)
            attributedText.addAttribute(.font, value: AILERON(16), range: all)
            
            return attributedText
        } else {
            return nil
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

