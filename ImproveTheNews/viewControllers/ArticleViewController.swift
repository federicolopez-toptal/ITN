//
//  ArticleViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/09/2022.
//

import UIKit
import WebKit


class ArticleViewController: BaseViewController {

    let navBar = NavBarView()
    let line = UIView()
    let webView = WKWebView()
    var article: MainFeedArticle?
    let rating = RatingView()

    var showComponentsOnClose = true


    deinit {
        if(self.showComponentsOnClose){ CustomNavController.shared.showPanelAndButtonWithAnimation() }
        self.hideLoading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.line)
        self.line.backgroundColor = .red
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.line.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.rating.buildInto(viewController: self, url: article!.url)
        
        self.view.addSubview(self.webView)
        self.webView.activateConstraints([
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.topAnchor.constraint(equalTo: self.line.bottomAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.rating.topAnchor)
        ])
        self.webView.navigationDelegate = self
        
        self.refreshDisplayMode()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.backToFeed, .share])
            self.navBar.setShareUrl(self.article!.url, vc: self)
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
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
}

extension ArticleViewController: WKNavigationDelegate {

    private func loadContent() {
        if let _article = self.article {
            self.showLoading()
            
            let strUrl = _article.url.replacingOccurrences(of: "http", with: "https")
            if let _url = URL(string: strUrl) {
                let request = URLRequest(url: _url)
                self.webView.load(request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
    }

}

extension ArticleViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
