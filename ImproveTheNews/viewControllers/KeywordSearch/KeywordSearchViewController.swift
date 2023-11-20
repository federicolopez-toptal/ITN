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
    var dataProvider = [DataProviderItem]()
    var filteredDataProvider = [DataProviderItem]()
    
    var searchTextfield = KeywordSearchTextView()
    let searchSelector = TopicSelectorView()
    let refresher = UIRefreshControl()
    var list = UITableView()
    
    let TOPICS_MAX_COUNT = 11
    let PAGE_SIZE = 4
    
    var searchCount: Int = 0
    var storySearchPage: Int = 1
    var articleSearchPage: Int = 1
    
    
            
            
    

    // MARK: - Init(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
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
        let topValue: CGFloat = Y_TOP_NOTCH_FIX(56)
        
        let closeIcon = UIImageView(image: UIImage(named: "menu.close")?.withRenderingMode(.alwaysTemplate))
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topValue)
        ])
        closeIcon.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.75) : UIColor(hex: 0x1D242F)
        
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
        self.searchSelector.setTopics(["ALL", "TOPICS", "STORIES", "ARTICLES"])
        self.searchSelector.delegate = self
        
        let listMargins: CGFloat = IPAD() ? 20 : 0.0
        
        self.view.addSubview(self.list)
        self.list.backgroundColor = self.view.backgroundColor
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: listMargins),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -listMargins),
            self.list.topAnchor.constraint(equalTo: self.searchSelector.bottomAnchor, constant: 12),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.listInit()
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        CustomNavController.shared.popViewController(animated: true)
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
            
        
        self.dataProvider = [DataProviderItem]()
        self.showLoading()
        //print("SEARCHING...")
        
        ///
        KeywordSearch.shared.search(text, type: sType) { (success, _) in
            self.searchCount += 1
            
            if(success) {
                self.fillDataProvider()
                self.updateFilteredDataProvider()

                MAIN_THREAD {
                    self.refresher.endRefreshing()
                }
                self.refreshList()
            } else {
                if(self.searchCount==1) {
                    HIDE_KEYBOARD(view: self.view)
                    SERVER_ERROR_POPUP(text: "Oops: we're having a temprary\ndatabase problem - this one is on\nus!")
                
//                    ALERT(vc: self, title: "Server error",
//                            message: "There was an error while retrieving the information. Please try again later", onCompletion: {
//                            DELAY(0.5) {
//                                self.search(self.searchTextfield.text(), type: .all)
//                            }
//                    })
                } else {
                    self.showErrorOnLoadMore()
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
        self.dataProvider = [DataProviderItem]()
    
        self.addTopics()
        let _ = self.addStories(tapOnTab: true)
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
            let empty = DataProviderCenteredText(text: "No topics found")
            self.dataProvider.append(empty)
        } else {
            var topics = [TopicSearchResult]()
            if(KeywordSearch.shared.topics.count <= self.TOPICS_MAX_COUNT) {
                topics = KeywordSearch.shared.topics
            } else {
                topics = Array(KeywordSearch.shared.topics[0...self.TOPICS_MAX_COUNT-1])
            }
            
            let topicsItem = DataProviderTopicsItem(topics: topics)
            self.dataProvider.append(topicsItem)
        }
    }
    
    func addStories(index: Int = -1, tapOnTab: Bool = false) -> Int {
        var count = 0
        if(index == -1){ self.addHeaderWith(text: "STORIES") }
        
        if(KeywordSearch.shared.stories.count == 0) {
            let empty = DataProviderCenteredText(text: "No stories found")
            self.dataProvider.append(empty)
            return 0
        }
        
        let div = IPHONE() ? 1 : 2
        for i in 1...(self.PAGE_SIZE/div) {
            let group = DataProviderGroupItem()
            group.MaxNumOfItems = IPHONE() ? 1 : 2
            group.storyFlags = [true]
            
            for (i, ST) in KeywordSearch.shared.stories.enumerated() {
                if(ST.used == false) {
                    group.articles.append( MainFeedArticle(story: ST) )
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
            let moreItem = DataProviderMoreItem(topic: "ST", completed: false)
            self.dataProvider.append(moreItem)
        }
        ///
        
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
            let empty = DataProviderCenteredText(text: "No articles found")
            self.dataProvider.append(empty)
            return 0
        }
        
        for i in 1...self.PAGE_SIZE {
            let group = DataProviderGroupItem()
            group.MaxNumOfItems = 1
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
            let moreItem = DataProviderMoreItem(topic: "AR", completed: false)
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
    
    /////////
    private func addHeaderWith(text: String) {
        let header = DataProviderHeaderItem(title: text)
        self.dataProvider.append(header)
        self.addSpacerWith(size: 8)
    }
    
    private func addSpacerWith(size S: CGFloat) {
        let spacer = DataProviderSpacer(size: S)
        self.dataProvider.append(spacer)
    }
    
}
