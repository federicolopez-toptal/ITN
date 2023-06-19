//
//  KeywordSearchViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit

class KeywordSearchViewController: BaseViewController {

    var searchTextfield = KeywordSearchTextView()
    var lastKeyTapTime: Date?
    let searchSelector = TopicSelectorView()
    var resultType: Int = 0
    

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.buildContent()
    }
    
    // MARK: - misc
    func buildContent() {
        let topValue: CGFloat = Y_TOP_NOTCH_FIX(56)
        
        let closeIcon = UIImageView(image: UIImage(named: "menu.close"))
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.view.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
                
        self.searchTextfield.delegate = self
        self.searchTextfield.buildInto(viewController: self)
        self.searchTextfield.activateConstraints([
            self.searchTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 11),
            self.searchTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -11),
            self.searchTextfield.heightAnchor.constraint(equalToConstant: 40),
            self.searchTextfield.topAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 10)
        ])
        
        self.searchSelector.buildInto(self.view, yOffset: topValue+32+10+40+22)
        self.searchSelector.setTopics(["ALL", "TOPICS", "ARTICLES", "STORIES"])
        self.searchSelector.delegate = self
    }

}

// MARK: - Event(s)
extension KeywordSearchViewController {
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - KeywordSearchTextViewDelegate
extension KeywordSearchViewController: KeywordSearchTextViewDelegate {
    func KeywordSearchTextView_onTextChange(sender: KeywordSearchTextView, text: String) {
        
        let limitDiff: TimeInterval = 0.8
        self.lastKeyTapTime = Date()
        
        DELAY(limitDiff) {
            let diff = Date().timeIntervalSince(self.lastKeyTapTime!)
            if(diff >= limitDiff) {
                self.search(self.searchTextfield.text(), type: .all)
            }
        }
    }
}

// MARK: -
extension KeywordSearchViewController: TopicSelectorViewDelegate {
    
    func onTopicSelected(_ index: Int) {
        self.searchSelector.selectTopic(index: index)
        self.resultType = index
    }
    
}

// MARK: - Search
extension KeywordSearchViewController {
    
    func search(_ text: String, type sType: searchType) {
        print("SEARCHING...")
        KeywordSearch.shared.search(text, type: sType) { (success) in
            if(success) {
                print("TOPICS", KeywordSearch.shared.topics.count)
                print("ARTICLES", KeywordSearch.shared.articles.count)
                print("STORIES", KeywordSearch.shared.stories.count)
            } else {
                print("ERROR")
            }
        }
    }
    
    
}
