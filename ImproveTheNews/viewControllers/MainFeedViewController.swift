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
    var list: UICollectionView!
    
    var dataProvider = [DP_item]()
    



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
        
//        if(index==0) {
//            self.list.scrollToRow(at: IndexPath(row: 0, section: 0),
//                        at: .top, animated: true)
//            return
//        }
//
//        var i = -1
//        for (j, dp) in self.dataProvider.enumerated() {
//            if let _ = dp as? DP_header {
//                i += 1
//                if(i == index) {
//                    self.list.scrollToRow(at: IndexPath(row: j, section: 0),
//                        at: .top, animated: true)
//                    break
//                }
//            }
//        }
        
    }

}

// MARK: - Data Provider
extension MainFeedViewController {
        
    private func populateDataProvider() {

        /*
            VALID (working) items
            
            h       simple header
            
            sbi     story, big with image
            swt     story, wide only text
            sco     story column
            
            awi     article, wide with image
            awt     article, wide only text
            aco     article column
            
        */
        
        let itemsToShowPerTopic = "h,sbi,awi2,awt3,sco,aco"

        self.dataProvider = [DP_item]()
        for (i, T) in self.data.topics.enumerated() {

            var allItems = itemsToShowPerTopic.components(separatedBy: ",")
            if(i==0 && allItems.count>1){ allItems.swapAt(0, 1) }
            
            for item in allItems {
                let type = item.getCharAt(index: 0) // 1st char: Data type (h: header, s: story, a: article)
                let format = item.subString(from: 1, count: 2) // 2nd + 3rd char: Size and/or format
                let count = item.getCharAt(index: 3) //4th char: Items count
                
                if(type == "h") { // header
                    let header = DP_header(text: T.capitalizedName.uppercased(), isHeadlines: (T.name=="news"))
                    self.dataProvider.append(header)
                } else if(type == "s") {   // story
                    self.addStoryToDataProvider(count: count, format: format, topicIndex: i)
                } else if(type == "a") {   // article
                    self.addArticleToDataProvider(count: count, format: format, topicIndex: i)
                }
                
            }
                        
        }
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
                    
                    if(_format == "bi") {
                        dpItem = DP_Story_BI(T: i, A: _j)
                    } else if(_format == "wt") {
                        dpItem = DP_Story_WT(T: i, A: _j)
                    } else if(_format == "co") {
                        dpItem = DP_Story_CO(T: i, A: _j)
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
                        dpItem = DP_Article_WI(T: i, A: _j)
                    } else if(_format == "wt") {
                        dpItem = DP_Article_WT(T: i, A: _j)
                    } else if(_format == "co") {
                        dpItem = DP_Article_CO(T: i, A: _j)
                    }

                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
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
    
}

// MARK: - CollectionView stuff
extension MainFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private func setupList() {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        
        layout.minimumLineSpacing = 0 // vertical separation
        layout.minimumInteritemSpacing = 0 // horizontal separation
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 10, height: 10) // necessary for cell autoHeight
        /*  UNUSED
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 100, height: 100)
        */
        
        self.list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.list.backgroundColor = self.view.backgroundColor
    
        self.view.addSubview(self.list)
        self.list.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 101 + 44) // navBar + topicSelector
        ])
        
        // Cells registration
        self.list.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        self.list.register(StoryBI_cell.self, forCellWithReuseIdentifier: StoryBI_cell.identifier)
        self.list.register(ArticleWI_cell.self, forCellWithReuseIdentifier: ArticleWI_cell.identifier)
        self.list.register(ArticleWT_cell.self, forCellWithReuseIdentifier: ArticleWT_cell.identifier)
        self.list.register(StoryWT_cell.self, forCellWithReuseIdentifier: StoryWT_cell.identifier)
        self.list.register(StoryCO_cell.self, forCellWithReuseIdentifier: StoryCO_cell.identifier)
        self.list.register(ArticleCO_cell.self, forCellWithReuseIdentifier: ArticleCO_cell.identifier)

        self.list.delegate = self
        self.list.dataSource = self
    }
    
    func refreshList() {
        DispatchQueue.main.async {
            self.list.reloadData()
        }
    }
    
    // ------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let item = self.getDP_item(indexPath)
        
        if let _item = item as? DP_header {
            // Header
            cell = self.list.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            (cell as! HeaderCell).populate(with: _item)
        } else if let _item = item as? DP_Story_BI {
            // Big story with image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryBI_cell.identifier,
                for: indexPath) as! StoryBI_cell
            (cell as! StoryBI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Article_WI {
            // Wide article with image
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWI_cell.identifier,
                for: indexPath) as! ArticleWI_cell
            (cell as! ArticleWI_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Article_WT {
            // Wide article (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleWT_cell.identifier,
                for: indexPath) as! ArticleWT_cell
            (cell as! ArticleWT_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Story_WT {
            // Wide story (only text)
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryWT_cell.identifier,
                for: indexPath) as! StoryWT_cell
            (cell as! StoryWT_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Story_CO {
            // Story column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: StoryCO_cell.identifier,
                for: indexPath) as! StoryCO_cell
            (cell as! StoryCO_cell).populate(with: self.getArticle(from: _item))
        } else if let _item = item as? DP_Article_CO {
            // Article column
            cell = self.list.dequeueReusableCell(withReuseIdentifier: ArticleCO_cell.identifier,
                for: indexPath) as! ArticleCO_cell
            (cell as! ArticleCO_cell).populate(with: self.getArticle(from: _item))
        }
        
        return cell!
    }

    // --------------
    private func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    private func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }

}



