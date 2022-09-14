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
    
    var dataProvider = [DP_item]()
    



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        
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
        UUID.shared.checkIfGenerated { _ in // generates a new uuid (if needed)
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                self.data.loadData { (error) in
                    self.topicSelector.setTopics(self.data.topicNames())
                    self.populateDataProvider()
                    self.refreshList()
                    self.hideLoading()
                }
            }
        }
    }
    
    func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }

}

// MARK: - Event(s)
extension MainFeedViewController: TopicSelectorViewDelegate {

    func onTopicSelected(_ index: Int) {
        print("Scroll to topic", index)
        
        if(index==0) {
            self.list.scrollToRow(at: IndexPath(row: 0, section: 0),
                        at: .top, animated: true)
            return
        }
        
        var i = -1
        for (j, dp) in self.dataProvider.enumerated() {
            if let _ = dp as? DP_header {
                i += 1
                if(i == index) {
                    self.list.scrollToRow(at: IndexPath(row: j, section: 0),
                        at: .top, animated: true)
                    break
                }
            }
        }
        
    }

}

// MARK: - Data Provider
extension MainFeedViewController {
    
    private func populateDataProvider() {
        self.dataProvider = [DP_item]()
        
        for (i, T) in self.data.topics.enumerated() {
            let newHeader = DP_header(text: T.capitalizedName.uppercased(), isHeadlines: (T.name=="news"))
            if(i>0){ self.dataProvider.append(newHeader) }
        
            for (j, _) in T.articles.enumerated() {
                switch(j) {
                    case 0:
                        let newDP_item = DP_Story(T: i, A: j)
                        self.dataProvider.append(newDP_item)
                        if(i==0){
                            self.dataProvider.append(newHeader)
                        }
                    case 1...10:
                        let newDP_item = DP_wideArticle(T: i, A: j)
                        self.dataProvider.append(newDP_item)
                    default:
                        print("")
                }
            }
        }
        
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
        
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.list.delegate = self
        self.list.dataSource = self
        
        // Cells registration
        self.list.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
        self.list.register(StoryCell.self, forCellReuseIdentifier: StoryCell.identifier)
        self.list.register(WideArticleCell.self, forCellReuseIdentifier: WideArticleCell.identifier)
    }
    
    func refreshList() {
        DispatchQueue.main.async {
            self.list.reloadData()
        }
    }
    
    // TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dpItem = self.getDP_item(indexPath)
        if let _height = dpItem.height {
            return _height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        let item = self.getDP_item(indexPath)

        if let _item = item as? DP_header {
            cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
        } else if let _item = item as? DP_Story {
            cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.identifier) as! StoryCell
            (cell as! StoryCell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_wideArticle {
            cell = tableView.dequeueReusableCell(withIdentifier: WideArticleCell.identifier) as! WideArticleCell
            (cell as! WideArticleCell).populate(with: self.getArticle(from: _item))
        }
        
        return cell
    }
    
    private func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    private func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }
    
}

