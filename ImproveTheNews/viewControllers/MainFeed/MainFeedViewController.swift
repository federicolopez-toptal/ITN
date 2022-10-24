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
    var list = CustomCollectionView()

    var topic = "news"
    let data = MainFeed()
    var dataProvider = [DP_item]()
    
    var column = 1 //...


    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(loadData),
            name: Notification_reloadMainFeed, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.logo, .menuIcon]) //.searchIcon
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            self.setupList()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
    // MARK: - Data
    @objc func loadData(showLoading: Bool = true) {
        if(showLoading){ self.showLoading() }
        
        UUID.shared.checkIfGenerated { _ in // generates a new uuid (if needed)
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                self.data.loadData(self.topic) { (error) in
                    self.topicSelector.setTopics(self.data.topicNames())
                    self.populateDataProvider()
                    self.refreshList()
                    
                    self.hideLoading()
                    self.list.hideRefresher()
                }
            }
        }
    }
    
    // MARK: - misc
    func tapOnLogo() { // called from the navBar
        self.topicSelector.scrollToZero()
        self.onTopicSelected(0)
    }

}

// MARK: - Topic selector
extension MainFeedViewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        if(index==0) {
            self.list.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            return
        }
        
        var i = -1
        for (j, dp) in self.dataProvider.enumerated() {
            if let _ = dp as? DP_header {
                i += 1
                if(i == index) {
                    self.list.scrollToItem(at: IndexPath(row: j, section: 0), at: .top, animated: true)
                    break
                }
            }
        }
    }
    
}




