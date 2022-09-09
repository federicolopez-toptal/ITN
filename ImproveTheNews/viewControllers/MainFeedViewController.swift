//
//  MainFeedViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class MainFeedViewController: BaseViewController {

    let data = MainFeed()

    let navBar = NavBarView()
    let topicSelector = TopicSelectorView()
    let list = UITableView()



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
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
    
    @objc func loadData() {
        self.showLoading()
        UUID.shared.check { _ in // generates a new uuid (if needed)
            self.data.loadData { (error) in
                self.topicSelector.setTopics(self.data.topicNames())
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

// MARK: - List stuff
extension MainFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
    
        self.view.addSubview(self.list)
        self.list.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 101 + 44) // navBar + topicSelector
        ])
        
        self.list.separatorStyle = .singleLine
        self.list.tableFooterView = UIView()
        self.list.delegate = self
        self.list.dataSource = self
        self.list.register(StoryCell.self, forCellReuseIdentifier: StoryCell.identifier)
    }
    
    // TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.identifier) as! StoryCell
        if(data.topics.count>0) {
            cell.populate(with: self.data.topics.first!.articles.first!)
        }
        return cell
    }
    
}
