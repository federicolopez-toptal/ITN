//
//  FigureDetails_topics.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/03/2024.
//

import UIKit

extension FigureDetailsViewController {

    func addTopics(_ topics: [SimpleTopic]) {
        self.topics = topics
        
        let mainView = self.createContainerView()
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .yellow
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.widthAnchor.constraint(equalToConstant: W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor)
        ])
        containerView.tag = 333
        
        let H: CGFloat = 40
        let SEP: CGFloat = 8.0
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        
        for (i, T) in topics.enumerated() {
            let label = UILabel()
            label.font = AILERON(15)
            label.textColor = CSS.shared.displayMode().sec_textColor
            label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
            label.textAlignment = .center
            label.text = T.name
            label.layer.cornerRadius = 20
            label.layer.borderWidth = 1.0
            label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
            label.clipsToBounds = true
            
            let _W = label.calculateWidthFor(height: H) + 42
            let trailing = val_x + _W
            if(trailing > W()) {
                val_x = 0
                val_y += H + SEP
            }
            
            containerView.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                label.widthAnchor.constraint(equalToConstant: _W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 400 + i
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            containerView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(topicButtonOnTap(_:)), for: .touchUpInside)
            
            val_x += SEP + _W
        }
        
        containerView.heightAnchor.constraint(equalToConstant: val_y + H).isActive = true
        mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: M*2).isActive = true
        
        self.selectTopic(index: 0, mustLoad: false)
    }
    @objc func topicButtonOnTap(_ sender: UIButton) {
        let i = sender.tag - 400
        self.selectTopic(index: i)
    }
    
    func selectTopic(index: Int, mustLoad: Bool = true) {
        if let containerView = self.view.viewWithTag(333) {
            var i = -1
            for V in containerView.subviews {
                if let label = V as? UILabel {
                    i += 1
                    if(i == index) {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                        label.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                        label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor 
                    }
                }
            }
        }
        
        if(mustLoad) {
            self.currentTopic = index
            self.storiesPage = 1
            self.stories = []
            self.storiesBuffer = []
            
            let T = self.topics[index]
            self.loadTopicData(T.slug, page: self.storiesPage)
        }
    }
    
    func loadTopicData(_ T: String, page P: Int) {
        self.showLoading()
        
        PublicFigureData.shared.loadMore(slug: self.slug, topic: T, page: P) { (error, figure) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading topic stories,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()

                    if let _figure = figure {
                        self.fillStories(_figure.stories)
                        self.storiesCount = _figure.storiesCount
                        self.addStories(self.stories, count: self.storiesCount)
                    }
                    
                }
            }
        }
    }

}