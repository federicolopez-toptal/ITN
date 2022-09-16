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
//        print("Scroll to topic", index)
        
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

        /*
            1st char: Type
                h   header
                s   story
                a   article
                c   columns
                
            // ---------------------------------
            2nd + 3rd char: Size and/or format
                li              large + image
                wi              wide + image
                wt              wide + text
                sa, as, aa, ss  story and/or aticles (for columns)
            
            // ---------------------------------
            4th char: count
                
        */
        let itemsToShow = "h,sli,awi2,awt3,swt,csa"

        self.dataProvider = [DP_item]()
        for (i, T) in self.data.topics.enumerated() {

            var allItems = itemsToShow.components(separatedBy: ",")
            if(i==0){ allItems.swapAt(0, 1) }
            
            for item in allItems {
                let type = item.getCharAt(index: 0)
                let format = item.subString(from: 1, count: 2)
                let count = item.getCharAt(index: 3)
                
                if(type == "h") { // header
                    let header = DP_header(text: T.capitalizedName.uppercased(), isHeadlines: (T.name=="news"))
                    self.dataProvider.append(header)
                } else if(type == "s") {   // story
                    self.addStoryToDataProvider(count: count, format: format, topicIndex: i)
                } else if(type == "a") {   // article
                    self.addArticleToDataProvider(count: count, format: format, topicIndex: i)
                } else if(type=="c") { // columns
                    self.addColumnsToDataProvider(count: count, format: format, topicIndex: i)
                }
                
            }
                        
        }
    }
    
    func getNextArticle(topicIndex i: Int, isStory: Bool = false) -> Int? {
        var result: Int? = nil
        for (j, A) in self.data.topics[i].articles.enumerated() {
            if(A.isStory==isStory && !A.used) {
                self.data.topics[i].articles[j].used = true
                result = j
                break
            }
        }
        return result
    }
    
    func addStoryToDataProvider(count: String?, format: String?, topicIndex i: Int) {
        var mCount = 1
        if let _count = count {
            mCount = Int(_count)!
        }
    
        for _ in 1...mCount {
            if let _j = self.getNextArticle(topicIndex: i, isStory: true) {
                if let _format = format {
                    var dpItem: DP_itemPointingData?
                    
                    if(_format == "li") {
                        dpItem = DP_Story(T: i, A: _j)
                    }
                    
                    if(_format == "wt") {
                        dpItem = DP_TextStory(T: i, A: _j)
                    }
                    
                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
    }
    
    func addArticleToDataProvider(count: String?, format: String?, topicIndex i: Int) {
        var mCount = 1
        if let _count = count {
            mCount = Int(_count)!
        }

        for _ in 1...mCount {
            if let _j = self.getNextArticle(topicIndex: i) {
                if let _format = format {
                    var dpItem: DP_itemPointingData?

                    if(_format == "wi") {
                        dpItem = DP_Article(T: i, A: _j)
                    }
                    if(_format == "wt") {
                        dpItem = DP_TextArticle(T: i, A: _j)
                    }

                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
    }
    
    func addColumnsToDataProvider(count: String?, format: String?, topicIndex i: Int) {

        var mCount = 1
        if let _count = count {
            mCount = Int(_count)!
        }

        for _ in 1...mCount {
            if let _format = format {
                var j1: Int?
                var j2: Int?
                
                for (k, F) in _format.enumerated() {
                    if(F=="s") {
                        var storyIndex = self.getNextArticle(topicIndex: i, isStory: true)
                        if(storyIndex == nil) {
                            storyIndex = self.getNextArticle(topicIndex: i)
                        }
                        if(k==0){ j1 = storyIndex } else { j2 = storyIndex }
                    } else if(F=="a") {
                        if(k==0){ j1 = self.getNextArticle(topicIndex: i) }
                        else{ j2 = self.getNextArticle(topicIndex: i) }
                    }
                }
                
                if(j1==nil && j2==nil){ return }
                
                var dpItem: DP_Columns?
                if(j1 != nil && j2 != nil) {
                    dpItem = DP_Columns(T1: i, A1: j1!, T2: i, A2: j2)
                } else if(j1 != nil && j2==nil) {
                    dpItem = DP_Columns(T1: i, A1: j1!, T2: nil, A2: nil)
                } else if(j2 != nil && j1==nil) {
                    dpItem = DP_Columns(T1: i, A1: j2!, T2: nil, A2: nil)
                }
                
                if let _dpItem = dpItem {
                    self.dataProvider.append(_dpItem)
                }
            }
            
            
        } //-----
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
        self.list.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        self.list.register(ArticleTextCell.self, forCellReuseIdentifier: ArticleTextCell.identifier)
        self.list.register(StoryTextCell.self, forCellReuseIdentifier: StoryTextCell.identifier)
        self.list.register(ColumnsCell.self, forCellReuseIdentifier: ColumnsCell.identifier)
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
        } else if let _item = item as? DP_Article {
            cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier) as! ArticleCell
            (cell as! ArticleCell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_TextArticle {
            cell = tableView.dequeueReusableCell(withIdentifier: ArticleTextCell.identifier) as! ArticleTextCell
            (cell as! ArticleTextCell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_TextStory {
            cell = tableView.dequeueReusableCell(withIdentifier: StoryTextCell.identifier) as! StoryTextCell
            (cell as! StoryTextCell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Columns {
            let articles = self.getArticles(from: _item)
            cell = tableView.dequeueReusableCell(withIdentifier: ColumnsCell.identifier) as! ColumnsCell
            (cell as! ColumnsCell).populate(with: articles)
        }
        
        return cell
    }
    
    private func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    private func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }
    
    private func getArticles(from item: DP_itemPointing_2Data) -> [MainFeedArticle?] {
        var result = [MainFeedArticle?]()
        result.append( self.data.topics[item.topicIndex_1].articles[item.articleIndex_1] )
        if let _i2 = item.topicIndex_2, let _j2 = item.articleIndex_2 {
            result.append( self.data.topics[_i2].articles[_j2] )
        } else {
            result.append(nil)
        }
        
        return result
    }
    
}

