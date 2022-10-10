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
    var list = CustomCollectionView()
    
    var dataProvider = [DP_item]()
    var column = 1


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
        
//        DELAY(2.0) {
//            let popup = NoInternetPopupView()
//            popup.pushFromBottom()
//        }
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
                    self.list.hideRefresher()
                }
            }
        }
    }
    
    override func refreshDisplayMode() {
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
        
        let itemsToShowPerTopic = "h,sbi,awi2,awt3,swt,sco,aco"
        
        //let itemsToShowPerTopic = "h,sbi,awi2,awt3,swt,sco,aco3"
        
        //"h,sbi,awi2,awt3,swt" // sco,aco
        //"h,sbi,sco,aco3,awt2"
//        "h,sbi,awi2,awt3,swt,sco2"
        // "h,sbi,awi2,awt3,swt,sco,aco"

        self.dataProvider = [DP_item]()
        for (i, T) in self.data.topics.enumerated() {

            self.column = 1
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
             
//            if(i==0 && self.data.banners.count>0) {
//                let banner = DP_banner(index: 0)
//                self.dataProvider.append(banner)
//            }
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
                        dpItem = DP_Story_CO(T: i, A: _j, column: self.column)
                        self.addColumn()
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
                        dpItem = DP_Article_CO(T: i, A: _j, column: self.column)
                        self.addColumn()
                    }

                    if let _dpItem = dpItem {
                        self.dataProvider.append(_dpItem)
                    }
                }
            }
        } //-----
    }
    
    private func addColumn() {
        self.column += 1
        if(self.column == 3) {
            self.column = 1
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
    
}

// MARK: - CollectionView stuff
extension MainFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    CustomCollectionViewDelegate {

    private func setupList() {
        self.list.backgroundColor = self.view.backgroundColor
        self.list.customDelegate = self
        
        self.view.addSubview(self.list)
        self.list.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor,
                constant: NavBarView.HEIGHT() + 44) // navBar + topicSelector
        ])
        
        // Cells registration
        self.list.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        self.list.register(StoryBI_cell.self, forCellWithReuseIdentifier: StoryBI_cell.identifier)
        self.list.register(ArticleWI_cell.self, forCellWithReuseIdentifier: ArticleWI_cell.identifier)
        self.list.register(ArticleWT_cell.self, forCellWithReuseIdentifier: ArticleWT_cell.identifier)
        self.list.register(StoryWT_cell.self, forCellWithReuseIdentifier: StoryWT_cell.identifier)
        self.list.register(StoryCO_cell.self, forCellWithReuseIdentifier: StoryCO_cell.identifier)
        self.list.register(ArticleCO_cell.self, forCellWithReuseIdentifier: ArticleCO_cell.identifier)
        
        self.list.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)


        self.list.delegate = self
        self.list.dataSource = self
    }
    
    func refreshList() {
        DispatchQueue.main.async {
            (self.list.collectionViewLayout as! CustomFlowLayout).resetCache()
            self.list.reloadData()
        }
    }
    
    func collectionViewOnRefreshPulled(sender: CustomCollectionView) {
        self.loadData()
    }
    
    // ------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.getCellForIndexPath(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.getCellSizeAtIndexPath(indexPath, width: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.getDP_item(indexPath)
        let itemIsHeader = item is DP_header
        let itemIsBanner = item is DP_banner

        if(!itemIsHeader && !itemIsBanner) {
            let article = self.getArticle(from: (item as! DP_itemPointingData))
            if(article.isStory) {
//                print("STORY", article.title)
            } else {
//                print("ARTICLE", article.title)
            }
            
            let vc = ArticleViewController()
            vc.article = article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    

    // --------------
    func getDP_item(_ iPath: IndexPath) -> DP_item {
        return self.dataProvider[iPath.row]
    }
    
    func getArticle(from item: DP_itemPointingData) -> MainFeedArticle {
        return self.data.topics[item.topicIndex].articles[item.articleIndex]
    }
    
    private func getBanner(from item: DP_banner) -> Banner {
        return self.data.banners[item.bannerIndex]
    }

}



