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
    let data = MainFeedv2()
    var dataProvider = [DP_item]()
    
    //!!!
    var breadcrumbs: BreadcrumbsView?
    var column = 1 //...
    var prevMustSplit: Int?


    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.loadDataFromNotification),
            name: Notification_reloadMainFeed, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.logo, .menuIcon, .searchIcon])
            
            self.topicSelector.buildInto(self.view)
            self.topicSelector.delegate = self
            
            if(!self.imFirstViewController()) {
                self.breadcrumbs = BreadcrumbsView()
                self.breadcrumbs?.buildInto(viewController: self)
                self.breadcrumbs?.delegate = self
            }
            
            self.setupList()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
            self.testFeature()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.topicSelector.refreshDisplayMode()
        self.breadcrumbs?.refreshDisplayMode()
        
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
    // MARK: - Data
    func loadData(showLoading: Bool = true) {
        if(showLoading){ self.showLoading() }
        //let imFirst = self.imFirstViewController() !!!
        
        UUID.shared.checkIfGenerated { _ in // generates a new uuid (if needed)
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                //if(imFirst){ self.data.resetCounting() } !!!

                self.data.loadData(self.topic) { (error) in
                    self.topicSelector.setTopics(self.data.topicNames())
                    self.populateDataProvider()
                    self.refreshList()

                    self.hideLoading()
                    self.list.hideRefresher()
                    self.list.forceUpdateLayoutForVisibleItems()
                    self.refreshVLine()

                    if(self.prevMustSplit != nil) {
                        if(self.prevMustSplit != self.mustSplit()) { self.tapOnLogo() }
                    }
                    self.prevMustSplit = self.mustSplit()
                }
            }
        }
    }
    @objc func loadDataFromNotification() {
        self.loadData(showLoading: true)
    }
    
    // MARK: - end
    deinit {
//        if let _prevVC = CustomNavController.shared.viewControllers.last as? MainFeedViewController {
//            _prevVC.data.removeCount() !!!
//        }
    }
    
    // MARK: - misc
    func tapOnLogo() { // called from the navBar
        MAIN_THREAD {
            self.topicSelector.scrollToZero()
            self.onTopicSelected(0)
        }
    }
    
    func imFirstViewController() -> Bool {
        var result = false
        if let _first = CustomNavController.shared.viewControllers.first {
            if(_first == self) { result = true }
        }

        return result
    }
    
    func mustSplit() -> Int {
        if let _value = READ(LocalKeys.sliders.split) {
            return Int(_value)!
        } else {
            return 0
        }
    }

}

// MARK: - Topic selector & Breadcrumbs
extension MainFeedViewController: TopicSelectorViewDelegate, BreadcrumbsViewDelegate {

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
    
    func breadcrumbOnTap(sender: BreadcrumbsView) {
        CustomNavController.shared.popViewController(animated: true)
    }
    
}

extension MainFeedViewController {
    
    // Called from viewDidAppear, for testing purposes
    func testFeature() {
//        let vc = SourceFilterViewController()
//        vc.modalPresentationStyle = .fullScreen
//        CustomNavController.shared.present(vc, animated: true)
    }
}
