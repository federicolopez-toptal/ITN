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
    let webView = WKWebView()
    var article: MainFeedArticle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self
        
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.webView.navigationDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(self.view)
            //self.navBar.addComponents([.logo, .menuIcon, .searchIcon])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
}

extension ArticleViewController: WKNavigationDelegate {

    private func loadContent() {
        if let _article = self.article {
            self.showLoading()
            
            if let _url = URL(string: _article.url) {
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
    // for swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
