//
//  KeywordSearchViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit

class KeywordSearchViewController: BaseViewController {

    var resultType: Int = 0
    var lastKeyTapTime: Date?
    var dataProvider = [DP3_item]()
    var filteredDataProvider = [DP3_item]()
    
    var searchTextfield = KeywordSearchTextView()
    let searchSelector = TopicSelectorView()
    let refresher = UIRefreshControl()
    var list = UITableView()
    
    let TOPICS_MAX_COUNT = 11
    let PAGE_SIZE = 4
    
    var searchCount: Int = 0
    var storySearchPage: Int = 1
    var articleSearchPage: Int = 1
    
    var middleIndexPath: IndexPath?
            
            
    

    // MARK: - Init(s)
    deinit {
        KeywordSearch.searchTerm = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.buildContent()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onTryAgainButtonTap),
            name: Notification_tryAgainButtonTap, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            // Initial search
            self.search("", type: .all)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
}
    
// MARK: - UI
extension KeywordSearchViewController {

    func buildContent() {
        let topValue = Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)
        
        let closeImage = UIImage(named: DisplayMode.imageName("circle.close"))
        let closeIcon = UIImageView(image: closeImage)
        closeIcon.tag = 77
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
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
                
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY(23)
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.text = "Search Verity"
        self.view.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: 21)
        ])
                   
        self.searchTextfield.delegate = self
        self.searchTextfield.buildInto(viewController: self)
        self.searchTextfield.activateConstraints([
            self.searchTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.searchTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.searchTextfield.heightAnchor.constraint(equalToConstant: 48),
            self.searchTextfield.topAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 47)
        ])
        
        self.searchSelector.buildInto(self.view, yOffset: topValue+32+47+48+25)
        self.searchSelector.setTopics(["All", "Topics", "Stories", "Controversies", "Articles"])
        self.searchSelector.delegate = self
        
        self.listInit()
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        //CustomNavController.shared.popViewController(animated: true)
        KeywordSearch.searchTerm = nil
        KeywordSearch.shared.cancelSearch()
        
        MAIN_THREAD {
            self.hideLoading()
        }
                
        CustomNavController.shared.customPopToBottomViewController()
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
    
    func KeywordSearchTextView_onSearchTap(sender: KeywordSearchTextView) {
        //self.search(self.searchTextfield.text(), type: .all)
    }
    
}

// MARK: - TopicSelectorViewDelegate
extension KeywordSearchViewController: TopicSelectorViewDelegate {
    
    func onTopicSelected(_ index: Int) {
        self.searchSelector.selectTopic(index: index)
        self.resultType = index
        
        self.updateFilteredDataProvider()
        self.refreshList()
        
        DELAY(0.1) {
            if(self.filteredDataProvider.count>0) {
                self.list.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
}

// MARK: - Search
extension KeywordSearchViewController {
    
    func search(_ text: String, type sType: searchType) {
        
        self.storySearchPage = 1
        self.articleSearchPage = 1
                    
        self.dataProvider = [DP3_item]()
        self.showLoading()

        KeywordSearch.searchTerm = nil
        if(self.textHasSpecialCharacters(text)) {
            DELAY(2.5) {
                KeywordSearch.shared.toZero()
                self.fillDataProvider()
                self.updateFilteredDataProvider()
                self.refreshList()
                
                MAIN_THREAD {
                    self.hideLoading()
                }
            }
            
            return
        }
        
        // -----------------------------------
        KeywordSearch.shared.search(text, type: sType) { (success, _) in
            self.searchCount += 1
            
            if(success) {
                KeywordSearch.searchTerm = text
            
                self.fillDataProvider()
                self.updateFilteredDataProvider()

                MAIN_THREAD {
                    self.refresher.endRefreshing()
                }
                self.refreshList()
            } else {
//                if(self.searchCount==1) {
//                    MAIN_THREAD {
//                        HIDE_KEYBOARD(view: self.view)
//                        SERVER_ERROR_POPUP(text: "Oops: we're having a temprary\ndatabase problem - this one is on\nus!")
//                    }
//                    
//                
////                    ALERT(vc: self, title: "Server error",
////                            message: "There was an error while retrieving the information. Please try again later", onCompletion: {
////                            DELAY(0.5) {
////                                self.search(self.searchTextfield.text(), type: .all)
////                            }
////                    })
//                } else {
//                    //self.showErrorOnLoadMore()
//                    DELAY(1.0) {
//                        self.search(text, type: sType)
//                    }
//                }

                DELAY(1.0) {
                    self.search(text, type: sType)
                }
            }
        
//            // TEST
//            if(self.searchCount == 0) {
//                self.searchCount += 1
//                self.fillDataProvider()
//                self.updateFilteredDataProvider()
//
//                MAIN_THREAD {
//                    self.refresher.endRefreshing()
//                }
//                self.refreshList()
//            } else {
//                self.showErrorOnLoadMore()
//            }

            
            MAIN_THREAD {
                self.hideLoading()
            }
        }
        ///
    }

    @objc func onTryAgainButtonTap(_ notification: Notification) {
        print("TAP!")
        DELAY(0.5) {
            self.search(self.searchTextfield.text(), type: .all)
        }
    }

}

// MARK: - List
extension KeywordSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataProvider.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return self.getCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeight(indexPath)
    }
}

// MARK: - Dataprovider
extension KeywordSearchViewController {

    func fillDataProvider(tapOnTab: Bool = false) {
        self.dataProvider = [DP3_item]()
    
        self.addTopics()
        let _ = self.addStories(tapOnTab: true)
        let _ = self.addControversies()
        let _ = self.addArticles()
    
//        switch(self.resultType) {
//            case 0:
//                self.addTopics()
//                let _ = self.addStories(tapOnTab: true)
//                let _ = self.addArticles()
//            case 1:
//                self.addTopics()
//            case 2:
//                let _ = self.addStories(tapOnTab: true)
//            case 3:
//                let _ = self.addArticles(tapOnTab: true)
//
//            default:
//                NOTHING()
//        }
    }
    
    private func addTopics() {
        self.addHeaderWith(text: "TOPICS")
        
        if(KeywordSearch.shared.topics.count == 0) {
            let empty = DP3_text(text: "No topics found")
            self.dataProvider.append(empty)
        } else {
            var topics = [TopicSearchResult]()
            if(KeywordSearch.shared.topics.count <= self.TOPICS_MAX_COUNT) {
                topics = KeywordSearch.shared.topics
            } else {
                topics = Array(KeywordSearch.shared.topics[0...self.TOPICS_MAX_COUNT-1])
            }
            
            let topicsItem = DP3_topics(topics: topics)
            self.dataProvider.append(topicsItem)
        }
    }
    
    func addStories(index: Int = -1, tapOnTab: Bool = false) -> Int {
        var count = 0
        if(index == -1){ self.addHeaderWith(text: "STORIES") }
        
        if(KeywordSearch.shared.stories.count == 0) {
            let empty = DP3_text(text: "No stories found")
            self.dataProvider.append(empty)
            return 0
        }
        
        let div = 2 //IPHONE() ? 1 : 2
        for i in 1...(self.PAGE_SIZE/div) {
            let group = DP3_groupItem()
            group.MaxNumOfItems = 2 //IPHONE() ? 1 : 2
            group.storyFlags = [true]
            
            for (i, ST) in KeywordSearch.shared.stories.enumerated() {
                if(ST.used == false) {
                    //StorySearchResult
                    var _ST = MainFeedArticle(story: ST)
                    if(ST.type == 2) {
                        _ST.isContext = true
                    }
                    
                    group.articles.append(_ST)
                    count += 1
                    KeywordSearch.shared.stories[i].used = true
                    
                    if(group.articles.count == group.MaxNumOfItems) {
                        break
                    }
                }
            }
            
            if(group.articles.count>0) {
                if(index == -1) {
                    self.dataProvider.append(group)
                } else {
                    self.dataProvider.insert(group, at: index+i-1)
                }
            }
        }
        
        if(index == -1 && count==self.PAGE_SIZE) {
            let moreItem = DP3_more(topic: "ST", completed: false)
            self.dataProvider.append(moreItem)
        }
        
        return count
    }
    
    func thereAreStoriesToShow() -> Bool {
        var result = false
        for ST in KeywordSearch.shared.stories {
            if(ST.used == false) {
                result = true
                break
            }
        }
        
        return result
    }
    
    /////////
    func addArticles(index: Int = -1, tapOnTab: Bool = false) -> Int {
        var count = 0
        if(index == -1){ self.addHeaderWith(text: "ARTICLES") }
        
        if(KeywordSearch.shared.articles.count == 0) {
            let empty = DP3_text(text: "No articles found")
            self.dataProvider.append(empty)
            return 0
        }
        
        let div = 2 //IPHONE() ? 1 : 2
        for i in 1...(self.PAGE_SIZE/div) {
            let group = DP3_groupItem()
            group.MaxNumOfItems = 2 //IPHONE() ? 1 : 2
            group.storyFlags = [false]
            
            for (i, AR) in KeywordSearch.shared.articles.enumerated() {
                if(AR.used == false) {
                    group.articles.append( MainFeedArticle(article: AR) )
                    count += 1
                    KeywordSearch.shared.articles[i].used = true
                    
                    if(group.articles.count == group.MaxNumOfItems) {
                        break
                    }
                }
            }
            
            if(group.articles.count>0) {
                if(index == -1) {
                    self.dataProvider.append(group)
                } else {
                    self.dataProvider.insert(group, at: index+i-1)
                }
            }
        }
        
        if(index == -1 && count==self.PAGE_SIZE) {
            let moreItem = DP3_more(topic: "AR", completed: false)
            self.dataProvider.append(moreItem)
        }
        
        return count
    }
    
    func thereAreArticlesToShow() -> Bool {
        var result = false
        for AR in KeywordSearch.shared.articles {
            if(AR.used == false) {
                result = true
                break
            }
        }
        
        return result
    }
    
    func addControversies(index: Int = -1) -> Int {
        var count = 0
        var iPadIndex = index
        if(index == -1){ self.addHeaderWith(text: "CONTROVERSIES") }
        
        if(KeywordSearch.shared.controversies.count == 0) {
            let empty = DP3_text(text: "No controversies found")
            self.dataProvider.append(empty)
            return 0
        }
        
        if(IPHONE()) {
            for (i, CO) in KeywordSearch.shared.controversies.enumerated() {
                if(CO.used==false) {
                    let newItem = DP3_controversy(controversy: CO)
                    
                    if(index == -1) {
                        self.dataProvider.append(newItem)
                    } else {
                        self.dataProvider.insert(newItem, at: index+count)
                    }
                    
                    KeywordSearch.shared.controversies[i].used = true
                    count += 1
                }
                
                if(count == self.PAGE_SIZE) {
                    break
                }
            }
        } else { // IPAD
            var CO1: ControversyListItem? = nil
            var CO2: ControversyListItem? = nil
            
            for (i, CO) in KeywordSearch.shared.controversies.enumerated() {
                if(CO.used==false) {
                    
                    if(CO1 == nil) {
                        CO1 = CO
                    } else {
                        CO2 = CO
                    }
                    KeywordSearch.shared.controversies[i].used = true
                    count += 1
                    
                    var newItem: DP3_item? = nil
                    if(CO1 != nil) && (CO2 != nil) {
                        newItem = DP3_controversies_x2(controversy1: CO1!, controversy2: CO2)
                    } else if(CO1 != nil && CO2 == nil && i == KeywordSearch.shared.controversies.count-1 ) {
                        newItem = DP3_controversies_x2(controversy1: CO1!, controversy2: nil)
                        if(IPAD()) {
                            iPadIndex -= 1
                        }
                    }
                
                    if let _newItem = newItem {
                        if(index == -1) {
                            self.dataProvider.append(_newItem)
                            CO1 = nil
                            CO2 = nil
                        } else {
                            iPadIndex += 1
                        
                            self.dataProvider.insert(_newItem, at: iPadIndex)
                            CO1 = nil
                            CO2 = nil
                        }
                    }
                    
                    if(count == self.PAGE_SIZE) {
                        break
                    }
                }
            }
        }
        
        if(self.thereAreControversiesToShow()) {
            let moreItem = DP3_more(topic: "CO", completed: false)
            if(index == -1) {
                self.dataProvider.append(moreItem)
            } else {
                if(IPHONE()) {
                    self.dataProvider.insert(moreItem, at: index+count)
                } else {
                    self.dataProvider.insert(moreItem, at: iPadIndex+1)
                }
            }
        }
        
        return count
    }
    
    func thereAreControversiesToShow() -> Bool {
        var result = false
        for CO in KeywordSearch.shared.controversies {
            if(CO.used == false) {
                result = true
                break
            }
        }
        
        return result
    }
    
    /////////
    private func addHeaderWith(text: String) {
        self.addSpacerWith(size: 10)
            
        let header = DP3_headerItem(title: text.capitalized)
        self.dataProvider.append(header)
        self.addSpacerWith(size: 8)
    }
    
    private func addSpacerWith(size S: CGFloat) {
        let spacer = DP3_spacer(size: S)
        self.dataProvider.append(spacer)
    }
    
}

extension KeywordSearchViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let _rows = self.list.indexPathsForVisibleRows, let _rowA = _rows.first, let _rowZ = _rows.last {
            let middleRow = (_rowA.row + _rowZ.row)/2
            self.middleIndexPath = IndexPath(row: middleRow, section: 0)
        }
        
        self.listInit()
    }
}

extension KeywordSearchViewController {
    
    func textHasSpecialCharacters(_ text: String) -> Bool {
        let chars = "ñÑ-/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>€£¥•"   
        var result = false
        
        
        for _CH in text {
            if(chars.contains(_CH)) {
                result = true
                break
            }
        }
        
        return result
    }
    
}
