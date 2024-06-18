//
//  NewsLetterContentUI.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/06/2024.
//

import Foundation
import UIKit


extension NewsLetterContentViewController {
    
    // WEEKLY
    func addWeeklyContent() {
        self.addWeeklyTopData()
        self.addWeeklyStories()
        self.addBottomLinks()
    }
    
    func addBottomLinks() {
        let data = self.data as! WeeklyNewsletter
        if(data.prev == nil && data.next == nil) {
            return
        }
    
        var H: CGFloat = 64
        if(IPAD()){ H += 40 }
        let extraH: CGFloat = SAFE_AREA()!.bottom
        
        let mainView = UIView()
        mainView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xe3e3e3)
        self.view.addSubview(mainView)
        mainView.activateConstraints([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainView.heightAnchor.constraint(equalToConstant: H+extraH)
        ])
        
        let subView = UIView()
        subView.backgroundColor = mainView.backgroundColor
        mainView.addSubview(subView)
        subView.activateConstraints([
            subView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            subView.topAnchor.constraint(equalTo: mainView.topAnchor),
            subView.heightAnchor.constraint(equalToConstant: H)
        ])
        
        var _W = self.W() / 2.5
        if(IPHONE()){ _W = self.W()/3.25 }
        
        if(data.prev != nil) {
        
            let icon = UIImageView(image: UIImage(named: "newsLetterLeft"))
            subView.addSubview(icon)
            icon.activateConstraints([
                icon.widthAnchor.constraint(equalToConstant: 32),
                icon.heightAnchor.constraint(equalToConstant: 32),
                icon.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: self.M()),
                icon.centerYAnchor.constraint(equalTo: subView.centerYAnchor)
            ])
        
            let vStack = VSTACK(into: subView)
            //vStack.backgroundColor = .orange
            vStack.activateConstraints([
                vStack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: self.M()),
                vStack.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
                vStack.widthAnchor.constraint(equalToConstant: _W)
            ])
            
            let dateLabel = UILabel()
            dateLabel.text = self.formatDate(data.prev.date)
            dateLabel.font = AILERON(15)
            dateLabel.textColor = CSS.shared.displayMode().sec_textColor
            vStack.addArrangedSubview(dateLabel)
        
            if(IPAD()) {
                let titleLabel = UILabel()
                titleLabel.numberOfLines = 2
                titleLabel.font = DM_SERIF_DISPLAY(20)
                titleLabel.text = data.prev.title
                titleLabel.textColor = CSS.shared.displayMode().main_textColor
                vStack.addArrangedSubview(titleLabel)
            }
        
            let button = UIButton(type: .custom)
//            button.backgroundColor = .red.withAlphaComponent(0.25)
            subView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
                button.topAnchor.constraint(equalTo: vStack.topAnchor),
                button.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: vStack.bottomAnchor)
            ])
            button.tag = 1
            button.addTarget(self, action: #selector(goToOtherNewsletterButtonOnTap(_:)), for: .touchUpInside)
        }
        
        if(data.next != nil) {
        
            let icon = UIImageView(image: UIImage(named: "newsLetterRight"))
            subView.addSubview(icon)
            icon.activateConstraints([
                icon.widthAnchor.constraint(equalToConstant: 32),
                icon.heightAnchor.constraint(equalToConstant: 32),
                icon.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -self.M()),
                icon.centerYAnchor.constraint(equalTo: subView.centerYAnchor)
            ])
        
            let vStack = VSTACK(into: subView)
            //vStack.backgroundColor = .orange
            vStack.activateConstraints([
                vStack.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -self.M()),
                vStack.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
                vStack.widthAnchor.constraint(equalToConstant: _W)
            ])
            
            let dateLabel = UILabel()
            dateLabel.textAlignment = .right
            dateLabel.text = self.formatDate(data.next.date)
            dateLabel.font = AILERON(15)
            dateLabel.textColor = CSS.shared.displayMode().sec_textColor
            vStack.addArrangedSubview(dateLabel)
        
            if(IPAD()) {
                let titleLabel = UILabel()
                titleLabel.textAlignment = .right
                titleLabel.numberOfLines = 2
                titleLabel.font = DM_SERIF_DISPLAY(20)
                titleLabel.text = data.next.title
                titleLabel.textColor = CSS.shared.displayMode().main_textColor
                vStack.addArrangedSubview(titleLabel)
            }
        
            let button = UIButton(type: .custom)
//            button.backgroundColor = .red.withAlphaComponent(0.25)
            subView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                button.topAnchor.constraint(equalTo: vStack.topAnchor),
                button.trailingAnchor.constraint(equalTo: icon.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: vStack.bottomAnchor)
            ])
            button.tag = 2
            button.addTarget(self, action: #selector(goToOtherNewsletterButtonOnTap(_:)), for: .touchUpInside)
        }
        
        ADD_SPACER(to: self.vStack, height: H)
    }
    
    @objc func goToOtherNewsletterButtonOnTap(_ sender: UIButton?) {
        let tag = sender!.tag
        let data = self.data as! WeeklyNewsletter
        
        if(tag == 1) { // Prev
            self.gotoNewsLetterWithDate(data.prev.date, type: 2)
        } else {
            self.gotoNewsLetterWithDate(data.next.date, type: 2)
        }
    }
    
    func gotoNewsLetterWithDate(_ date: String, type: Int) {
        let refData = NewsLetterStory([
            "pubdate": date,
            "newsletter_title": "abc",
            "image_url": "abc",
            "type": type
        ])
        
        let vc = NewsLetterContentViewController()
        vc.refData = refData
        
        var viewControllers = CustomNavController.shared.viewControllers
        viewControllers.removeLast()
        viewControllers.append(vc)
        
        CustomNavController.shared.viewControllers = viewControllers
    }
    
    func addWeeklyStories() {
        let data = self.data as! WeeklyNewsletter
    
        for (i, ST) in data.stories.enumerated() {
            ADD_SPACER(to: self.vStack, height: self.M())
        
            // Title
            let titleLabel = UILabel()
            titleLabel.font = DM_SERIF_DISPLAY(20)
            titleLabel.text = ST.title
            titleLabel.textColor = CSS.shared.displayMode().main_textColor
            self.addHStackViewWith(subview: titleLabel)
            
            // Content
            ADD_SPACER(to: self.vStack, height: self.M())
            let contentLabel = HyperlinkLabel.parrafo2(text: ST.parsedContent,
                                                        linkTexts: ST.linkedTexts,
                                                        urls: ST.urls,
                                                        onTap: self.onLinkTap(_:))
            self.addHStackViewWith(subview: contentLabel)
            ADD_SPACER(to: self.vStack, height: self.M()*2)
            
            if(!ST.topic.isEmpty) {
                self.addWeeklyStoryButton(index: i)
                ADD_SPACER(to: self.vStack, height: self.M()*2)
            }
            
            self.addLine()
        }
        
        ADD_SPACER(to: self.vStack, height: self.M() * 2)
    }
    
    func addWeeklyStoryButton(index: Int) {
        let button = UIButton(type: .custom)
        button.tag = index
        button.titleLabel?.font = AILERON(16)
        button.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        button.setTitle("Read this week's stories", for: .normal)
        button.backgroundColor = CSS.shared.cyan
        button.layer.cornerRadius = 6.0
        
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        button.addTarget(self, action: #selector(weeklyStoryButtonOnTap(_:)), for: .touchUpInside)
        self.addHStackViewWith(subview: button, addExtraHSpacer: true)
    }
    
    @objc func weeklyStoryButtonOnTap(_ sender: UIButton?) {
        let index = sender!.tag
        let data = self.data as! WeeklyNewsletter
        let topic = data.stories[index].topic
        
        if let _vc = CustomNavController.shared.viewControllers.first {
            if(_vc is MainFeed_v3_viewController) {
                (_vc as! MainFeed_v3_viewController).topic = topic
            } else if(_vc is MainFeediPad_v3_viewController) {
                (_vc as! MainFeediPad_v3_viewController).topic = topic
            }
        }
        
        NOTIFY(Notification_reloadMainFeedOnShow)
        CustomNavController.shared.popToRootViewController(animated: true)
    }
    
    func onLinkTap(_ url: URL) {
        let story = MainFeedArticle(url: url.absoluteString)
        
        let vc = StoryViewController()
        vc.story = story
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func addWeeklyTopData() {
        let data = self.data as! WeeklyNewsletter
        
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
        titleLabel.text = "Weekly Newsletter"
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addHStackViewWith(subview: titleLabel)
        
        ADD_SPACER(to: self.vStack, height: self.M())
        let imageView = CustomImageView()
        self.vStack.addArrangedSubview(imageView)
        imageView.showCorners(true)

        imageView.sd_setImage(with: URL(string: data.image)) { (img, error, cacheType, url) in
            if let _img = img {
                let H = (_img.size.height * self.W())/_img.size.width
                imageView.activateConstraints([
                    imageView.heightAnchor.constraint(equalToConstant: H)
                ])
            }
        }
    }
    
    
}

// MARK: UI misc
extension NewsLetterContentViewController {

    func addHStackViewWith(subview: UIView, addExtraHSpacer: Bool = false) {
        let hstack = HSTACK(into: self.vStack)
        ADD_SPACER(to: hstack, width: self.M())
        hstack.addArrangedSubview(subview)
        if(addExtraHSpacer) {
            ADD_SPACER(to: hstack)
        }
        ADD_SPACER(to: hstack, width: self.M())
    }

    func addLine() {
        let line = UIView()
        line.backgroundColor = .clear
        self.vStack.addArrangedSubview(line)
        line.activateConstraints([
            line.heightAnchor.constraint(equalToConstant: 4)
        ])
        ADD_HDASHES(to: line)
    }

    func W() -> CGFloat {
        if(IPHONE()){
            return SCREEN_SIZE().width
        } else {
            var value: CGFloat = 0
            let w = SCREEN_SIZE().width
            let h = SCREEN_SIZE().height
            
            value = w
            if(h<w){ value = h }
            
            return value
        }
    }
    
    func M() -> CGFloat {
        return CSS.shared.iPhoneSide_padding
    }
    
    func formatDate(_ strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: strDate)!
        
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }

}
