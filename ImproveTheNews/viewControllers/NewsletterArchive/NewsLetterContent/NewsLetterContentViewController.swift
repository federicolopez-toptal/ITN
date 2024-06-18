//
//  NewsLetterContentViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/03/2024.
//

import UIKit


// MARK: Data
extension NewsLetterContentViewController {
    
    private func loadContent() {
        self.showLoading()
        
        if(self.refData.type == 2) { // Weekly
            NewsLetterData.shared.loadWeeklyNewsletter(self.refData) { (error, data) in
                if let _ = error {
                    ALERT(vc: self, title: "Server error",
                    message: "Trouble loading the newsletter,\nplease try again later.", onCompletion: {
                        CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    if let _data = data {
                        MAIN_THREAD {
                            self.hideLoading()
                            self.scrollView.show()
                            
                            self.data = _data
                            self.addWeeklyContent()
                        }
                    }
                }
            }
        }
    }
    
}

// ------------------------
class NewsLetterContentViewController: BaseViewController {
    
    var refData: NewsLetterStory! = nil
    var data: AnyObject! = nil
    
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!
    
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title, .headlines])
            self.navBar.setTitle("Newsletter")

            self.buildContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
    func buildContent() {
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    
        // -------------------------------------------------
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        //self.scrollView.delegate = self
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.vStack = VSTACK(into: self.contentView)
//        self.vStack.backgroundColor = .orange
        self.vStack.activateConstraints([
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vStack.widthAnchor.constraint(equalToConstant: self.W()),
            self.vStack.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            
            //,self.vStack.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        self.scrollView.hide()
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        
        self.vStack.backgroundColor = self.view.backgroundColor //.orange.withAlphaComponent(0.25)
    }
    
}

// MARK: misc
extension NewsLetterContentViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}






