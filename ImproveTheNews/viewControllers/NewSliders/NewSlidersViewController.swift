//
//  NewSlidersViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/07/2024.
//

import UIKit


class NewSlidersViewController: BaseViewController {
    
    var topic = "news"
    
    let navBar = NavBarView()
    var list = CustomFeedList()
    
    let data = MainFeedv3()
    var dataProvider = [DP3_item]()
    var topicsCompleted = [String: Bool]()
    
    let subTitleLabel = UILabel()
    
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.menuIcon, .title, .share, .question])
            self.navBar.setTitle("News Sliders")
            self.navBar.addBottomLine()
            
            // ------------------------------
            self.navBar.onQuestionButtonTap {
                let vc = FAQViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                DELAY(0.4) {
                    vc.scrollToNewsSliders()
                }
            }
                        
            self.navBar.setShareUrl(ITN_URL() + "/news-slider", vc: self)
            // -----------------------------
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        self.setupList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
//        self.topicSelector.refreshDisplayMode()
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.list.backgroundColor = self.view.backgroundColor
        self.list.reloadData()
    }
    
}

// MARK: misc
extension NewSlidersViewController: UIGestureRecognizerDelegate {
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: data
extension NewSlidersViewController {

    func loadContent() {
        self.showLoading()
        self.topicsCompleted = [String: Bool]()
        
        self.data.loadArticlesData(self.topic) { error in
            MAIN_THREAD {/* --- */
                if(error != nil || self.data.topics.count == 0) {
                    self.showErrorAlert()
                    return
                }
                
//                self.topicSelector.setTopics(self.data.topicNames())
                self.populateDataProvider()
                self.refreshList()
                self.hideLoading()
            }
        }
    }
    
    func showErrorAlert() {
        MAIN_THREAD {
            self.hideLoading()
            
            ALERT(vc: self, title: "",
                message: "Trouble loading the news,\nplease try again later.", onCompletion: {
                DELAY(1.0) {
                    self.loadContent()
                }
            })
        }
    }
    
}
