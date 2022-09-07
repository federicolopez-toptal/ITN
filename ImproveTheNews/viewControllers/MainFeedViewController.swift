//
//  MainFeedViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class MainFeedViewController: BaseViewController {

    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(loadData),
            name: Notification_reloadMainFeed, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(self.view)
            self.navBar.addComponents([.logo, .menuIcon, .searchIcon])
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
        }
    }
    
    @objc func loadData() {
        self.showLoading()
        UUID.shared.check { _ in // generates a new uuid (if needed)
            let data = MainFeed()
            data.loadData { (error) in
                self.topicSelector.setTopics(data.topics)
                self.hideLoading()
            }
        }
    }
    
    func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
    }

}

// MARK: - Event(s)
extension MainFeedViewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        print("Scroll to topic", index)
    }

}
