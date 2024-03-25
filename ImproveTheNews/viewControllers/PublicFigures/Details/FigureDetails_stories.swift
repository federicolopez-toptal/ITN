//
//  FigureDetails_stories.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/03/2024.
//

import UIKit


extension FigureDetailsViewController {
    
    func addStories(_ stories: [MainFeedArticle], count: Int) {
        let containerView = self.view.viewWithTag(222)!
        let mainView = containerView.superview!
        
        if(self.storiesPage==1) {
            REMOVE_ALL_SUBVIEWS(from: containerView)
        }
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        for (i, ST) in stories.enumerated() {
            let stView = iPhoneStory_vImg_v3(width: item_W)
            stView.tag = 200 + i
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            containerView.addSubview(stView)
            stView.activateConstraints([
                stView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                stView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                stView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            stView.populate(ST)
            
            let buttonArea = UIButton(type: .custom)
            //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
            containerView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: stView.leadingAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: stView.trailingAnchor),
                buttonArea.topAnchor.constraint(equalTo: stView.topAnchor),
                buttonArea.heightAnchor.constraint(equalToConstant: stView.calculateHeight())
            ])
            buttonArea.addTarget(self, action: #selector(storyOnTap(_:)), for: .touchUpInside)
            buttonArea.tag = 700 + i
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += stView.calculateHeight()
                }
            } else {
                val_y += stView.calculateHeight()
            }
            
        }
        
        // Show more --------------
        var extraH: CGFloat = 0
        if(self.stories.count < count) {
            self.addShowMore(at: val_y)
            extraH = 88
        }
        
        // Show more --------------
        
        if(self.storiesContainerViewHeightConstraint == nil) {
            self.storiesContainerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: val_y+extraH)
            self.storiesContainerViewHeightConstraint!.isActive = true
            
            mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: M).isActive = true
        } else {
            self.storiesContainerViewHeightConstraint!.constant = val_y+extraH
        }
    }
    @objc func storyOnTap(_ sender: UIButton) {
        let index = sender.tag - 700
        
        let vc = StoryViewController()
        vc.story = self.stories[index]
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func fillStoriesToShow(_ stories: [MainFeedArticle]) {
        for ST in stories {
            self.storiesBuffer.append(ST)
        }
        
        var limit = self.STORIES_DIV
        if(self.storiesBuffer.count < limit) { limit = self.storiesBuffer.count }
        
        for _ in 0...limit-1 {
            self.stories.append(self.storiesBuffer.first!)
            self.storiesBuffer.remove(at: 0)
        }

    }
    
    func addMoreStories(_ stories: [MainFeedArticle], count: Int) {
        let containerView = self.view.viewWithTag(222)!
        if let _moreView = self.view.viewWithTag(888) {
            print("REMOVE more!")
            _moreView.removeFromSuperview()
        }
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        for (i, ST) in stories.enumerated() {
            if let _STView = containerView.viewWithTag(200+i) as? iPhoneStory_vImg_v3 {
                if(IPAD()) {
                    col += 1
                    if(col==2) {
                        col = 0
                        val_y += _STView.calculateHeight()
                    }
                } else {
                    val_y += _STView.calculateHeight()
                }
                
                continue
            }
            
            let stView = iPhoneStory_vImg_v3(width: item_W)
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            containerView.addSubview(stView)
            stView.activateConstraints([
                stView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                stView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                stView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            stView.populate(ST)
            
            let buttonArea = UIButton(type: .custom)
            //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
            containerView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: stView.leadingAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: stView.trailingAnchor),
                buttonArea.topAnchor.constraint(equalTo: stView.topAnchor),
                buttonArea.heightAnchor.constraint(equalToConstant: stView.calculateHeight())
            ])
            buttonArea.addTarget(self, action: #selector(storyOnTap(_:)), for: .touchUpInside)
            buttonArea.tag = 700 + i
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += stView.calculateHeight()
                }
            } else {
                val_y += stView.calculateHeight()
            }
            
            if(IPAD()) {
                if(col==1 && i==count-1) {
                    val_y += stView.calculateHeight()
                }
            }
        }
        
        var extraH: CGFloat = 0
        if(self.stories.count < count) {
            self.addShowMore(at: val_y)
            extraH = 88
        }
        
        self.storiesContainerViewHeightConstraint!.constant = val_y+extraH
    }
    
    func addShowMore(at val_y: CGFloat) {
        let containerView = self.view.viewWithTag(222)!
        
        let moreView = UIView()
        //moreView.backgroundColor = .purple
        containerView.addSubview(moreView)
        moreView.activateConstraints([
            moreView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
            moreView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            moreView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            moreView.heightAnchor.constraint(equalToConstant: 88)
        ])
        moreView.tag = 888
        
        let button = UIButton(type: .custom)
        moreView.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
        ])
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        button.titleLabel?.font = AILERON(15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        button.addTarget(self, action: #selector(loadMoreStoriesOnTap(_:)), for: .touchUpInside)
    }
    
    @objc func loadMoreStoriesOnTap(_ sender: UIButton) {
        if(self.storiesBuffer.count > 0) {
            var limit = self.STORIES_DIV
            if(self.storiesBuffer.count < limit) { limit = self.storiesBuffer.count }
            
            for _ in 0...limit-1 {
                self.stories.append(self.storiesBuffer.first!)
                self.storiesBuffer.remove(at: 0)
            }
            
            self.addMoreStories(self.stories, count: self.lastStoriesCount)
        } else {
            self.storiesPage += 1
            let T = self.topics[self.currentTopic]
            
            self.showLoading()
            PublicFigureData.shared.loadStories(slug: self.slug, topic: T.slug, page: self.storiesPage) { (error, stories, count) in
                if let _ = error {
                    ALERT(vc: self, title: "Server error",
                    message: "Trouble loading topic stories,\nplease try again later.", onCompletion: {
                        CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    MAIN_THREAD {
                        self.hideLoading()

                        if let _stories = stories, let _count = count {
                            self.fillStoriesToShow(_stories)
                            self.lastStoriesCount = _count
                            
//                            self.addStories(self.stories, count: _count)
                            self.addMoreStories(self.stories, count: _count)
                        }

                    }
                }
            }
        }
    }
    
}
