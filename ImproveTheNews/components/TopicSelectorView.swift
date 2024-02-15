//
//  TopicSelectorView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/09/2022.
//

import UIKit

protocol TopicSelectorViewDelegate: AnyObject {
    func onTopicSelected(_ index: Int)
}

class TopicSelectorView: UIView {

    weak var delegate: TopicSelectorViewDelegate?

    var displayModeComponents = [Any]()
    private var viewHeightConstraint: NSLayoutConstraint?
    let scrollView = UIScrollView()
    let contentView = UIView()

    var selectedTopicIndex: Int = -1
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView, yOffset: CGFloat = NavBarView.HEIGHT()) {
        self.backgroundColor = .white
        container.addSubview(self)
        self.viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: CSS.shared.topicSelector_height)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: yOffset),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.viewHeightConstraint!
        ])
        
        //top line
        let line1 = UIView()
        line1.backgroundColor = .red
        self.addSubview(line1)
        line1.activateConstraints([
            line1.topAnchor.constraint(equalTo: self.topAnchor),
            line1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line1.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line1.heightAnchor.constraint(equalToConstant: 1),
        ])
        line1.tag = 1
        self.displayModeComponents.append(line1)
        
        //bottom line
        let line2 = UIView()
        line2.backgroundColor = .red
        self.addSubview(line2)
        line2.activateConstraints([
            line2.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            line2.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line2.heightAnchor.constraint(equalToConstant: 1),
        ])
        line2.tag = 1
        self.displayModeComponents.append(line2)
        
        // scrollView
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.heightAnchor.constraint(equalToConstant: CSS.shared.topicSelector_height)
        ])
        
        // contentView
        let W = self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        W.priority = .defaultLow

        self.contentView.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        self.scrollView.addSubview(self.contentView)
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            W, self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        ])
                
        self.refreshDisplayMode()
    }

    func setTopics(_ topics: [String]) {
        MAIN_THREAD {
            REMOVE_ALL_SUBVIEWS(from: self.contentView)

            let HStack = HSTACK(into: self.contentView)
            HStack.backgroundColor = .clear
            HStack.activateConstraints([
                HStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                HStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                HStack.heightAnchor.constraint(equalToConstant: CSS.shared.topicSelector_height),
                HStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
            
            for (i, T) in topics.enumerated() {
                if(i==0) {
                    ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
                }
            
                let topicView = UIView()
                topicView.backgroundColor = .clear
                HStack.addArrangedSubview(topicView)
                topicView.activateConstraints([
                    HStack.topAnchor.constraint(equalTo: HStack.topAnchor),
                    HStack.heightAnchor.constraint(equalToConstant: CSS.shared.topicSelector_height)
                ])
            
                let label = UILabel()
                label.font = CSS.shared.topicSelector_font
                label.backgroundColor = .clear
                
                label.text = T //T.capitalized
                if(T.lowercased() == "headlines") {
                    label.text = "Home"
                }
                
                topicView.addSubview(label)
                label.activateConstraints([
                    label.leadingAnchor.constraint(equalTo: topicView.leadingAnchor),
                    label.topAnchor.constraint(equalTo: topicView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: topicView.bottomAnchor),
                    label.trailingAnchor.constraint(equalTo: topicView.trailingAnchor)
                ])
                
                let bottomLine = UIView()
                bottomLine.backgroundColor = CSS.shared.orange
                topicView.addSubview(bottomLine)
                bottomLine.activateConstraints([
                    bottomLine.leadingAnchor.constraint(equalTo: topicView.leadingAnchor),
                    bottomLine.trailingAnchor.constraint(equalTo: topicView.trailingAnchor),
                    bottomLine.bottomAnchor.constraint(equalTo: topicView.bottomAnchor),
                    bottomLine.heightAnchor.constraint(equalToConstant: 4)
                ])
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                topicView.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: topicView.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: topicView.trailingAnchor),
                    button.bottomAnchor.constraint(equalTo: topicView.bottomAnchor),
                    button.topAnchor.constraint(equalTo: topicView.topAnchor)
                ])
                button.tag = 30 + i
                button.addTarget(self, action: #selector(self.onTopicTap(_:)), for: .touchUpInside)
                
                if(i==topics.count-1) {
                    ADD_SPACER(to: HStack, width: CSS.shared.iPhoneSide_padding)
                } else {
                    ADD_SPACER(to: HStack, width: 25)
                }
            }
            
            self.selectTopic(index: 0)
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func selectTopic(index: Int) {
        self.selectedTopicIndex = index
        let HStack = self.contentView.subviews.first as! UIStackView
        
        var i = 0
        for view in HStack.arrangedSubviews {
            if(view.tag != -1) {
                // each topicView
                let label = view.subviews.first as! UILabel
                let bottomLine = view.subviews[1]
                
                label.textColor = CSS.shared.displayMode().topicSelector_textColor
                if(i == index) {
                    bottomLine.show()
                } else {
                    bottomLine.hide()
                }
                
                i += 1
            }
        }
    }
    
    func scrollToZero() {
        self.selectTopic(index: 0)
    
        self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint.zero,
            size: CGSize(width: 10, height: 10)),
            animated: true)
    }

}

extension TopicSelectorView {
    
    // MARK: - Event(s)
    @objc func onTopicTap(_ sender: UIButton) {
        let tag = sender.tag - 30
        
        if(tag==0){ self.selectTopic(index: tag) }
        self.delegate?.onTopicSelected(tag)
    }
    
    // MARK: - Display mode
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor        
        
        for C in self.displayModeComponents {
            if(C is UIView) {
                let view = (C as! UIView)
                if(view.tag == 1) { // lines
                    view.backgroundColor = self.backgroundColor
                    ADD_HDASHES(to: view)                    
                }
            }
        }
        
        if(self.selectedTopicIndex != -1) {
            self.selectTopic(index: self.selectedTopicIndex)
        }
    }
    

    static func HEIGHT() -> CGFloat {
        return CSS.shared.topicSelector_height
    }
    
}
