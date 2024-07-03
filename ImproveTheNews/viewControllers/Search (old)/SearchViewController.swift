//
//  SearchViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/11/2022.
//

import UIKit

class SearchViewController: BaseViewController {

    private let tagsContainerHeight: CGFloat = 300
    
    var searchText = SearchTextView()
    let subTitleLabel = UILabel()
    let tagsContainer = UIView()



    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.buildContent()
    }
    
    // MARK: - misc
    func buildContent() {
        let topValue: CGFloat = Y_TOP_NOTCH_FIX(56)
        let robotoBold = ROBOTO_BOLD(12)
    
        self.searchText.delegate = self
        self.searchText.buildInto(viewController: self)
        self.searchText.activateConstraints([
            self.searchText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 11),
            self.searchText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -11),
            self.searchText.heightAnchor.constraint(equalToConstant: 48),
            self.searchText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue)
        ])
        
        self.subTitleLabel.font = robotoBold
        self.subTitleLabel.text = "POPULAR TOPICS"
        self.subTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.subTitleLabel.addCharacterSpacing(kernValue: 1.5)
        self.view.addSubview(self.subTitleLabel)
        self.subTitleLabel.activateConstraints([
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 11),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.searchText.bottomAnchor, constant: 25)
        ])
        
        self.tagsContainer.backgroundColor = .clear
        self.view.addSubview(self.tagsContainer)
        self.tagsContainer.activateConstraints([
            self.tagsContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 11),
            self.tagsContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -11),
            self.tagsContainer.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 20),
            self.tagsContainer.heightAnchor.constraint(equalToConstant: self.tagsContainerHeight)
        ])
        
        self.showPopularTopics()
    }
    
    func showTopicTags(_ topics: [String]) {
        let H: CGFloat = 28.0
        let SEP: CGFloat = 8.0
        let LIMIT = SCREEN_SIZE().width - 22
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        
        REMOVE_ALL_SUBVIEWS(from: self.tagsContainer)
        for (i, T) in topics.enumerated() {
            let label = UILabel()
            label.font = ROBOTO(13)
            label.textColor = UIColor(hex: 0xFF643C)
            label.backgroundColor = UIColor(hex: 0xFF643C).withAlphaComponent(0.2)
            label.textAlignment = .center
            label.text = T
            label.layer.cornerRadius = H/2
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor(hex: 0xFF643C).cgColor
            label.clipsToBounds = true
            label.tag = 100 + i
            
            let W = label.calculateWidthFor(height: H) + 26
            let trailing = val_x + W
            if(trailing > LIMIT) {
                val_x = 0
                val_y += H + SEP
                
                if(val_y + H > self.tagsContainerHeight) {
                    break
                }
            }

            self.tagsContainer.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: self.tagsContainer.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: self.tagsContainer.topAnchor, constant: val_y),
                label.widthAnchor.constraint(equalToConstant: W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 200 + i
            button.backgroundColor = .clear //.blue.withAlphaComponent(0.5)
            self.tagsContainer.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(tagButtonOnTap(_:)), for: .touchUpInside)
            
            val_x += SEP + W
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let text = self.searchText.text()

        if(text.isEmpty) {
            self.subTitleLabel.text = "POPULAR TOPICS"
            self.showPopularTopics()
        } else {
            self.subTitleLabel.text = "TOPIC RESULTS"
            self.searchForText(text)
        }
    }
    
    @objc func tagButtonOnTap(_ sender: UIButton) {
        let tag = sender.tag - 100
        let label = self.tagsContainer.viewWithTag(tag) as! UILabel
        let topic = label.text!
        if let code = self.topicsForSearch()[topic] { self.loadTopic(code) }
    }
    
    func loadTopic(_ topic: String) {
        if(IPHONE()) {
            let vc = MainFeedViewController()
            vc.topic = topic
            CustomNavController.shared.viewControllers = [vc]

            DELAY(0.1) {
                CustomNavController.shared.dismiss(animated: true)
            }
        } else {
            let vc = MainFeed_v2ViewController()
            vc.topic = topic
            CustomNavController.shared.viewControllers = [vc]

            DELAY(0.1) {
                CustomNavController.shared.dismiss(animated: true)
            }
        }
    }

}

extension SearchViewController: SearchTextViewDelegate {
    func SearchTextView_onTextChange(sender: SearchTextView, text: String) {
        if(text.isEmpty) {
            self.subTitleLabel.text = "POPULAR TOPICS"
            self.showPopularTopics()
        } else {
            self.subTitleLabel.text = "TOPIC RESULTS"
            self.searchForText(text)
        }
    }
}

extension SearchViewController {
    func showPopularTopics() {
        self.showTopicTags( self.popularTopicKeys() )
    }
    
    func searchForText(_ text: String) {
        let topics = self.topicsForSearch()
        
        let result = topics.filter { (key, value) in
            key.lowercased().contains(text.lowercased())
        }
        let sortedResult = result.sorted(by: { $0.key < $1.key })
        
        var keys = [String]()
        for item in sortedResult {
            keys.append(item.key)
        }
        
        self.showTopicTags(keys)
    }
}
