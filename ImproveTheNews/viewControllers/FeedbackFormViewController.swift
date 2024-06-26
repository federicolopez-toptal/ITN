//
//  FeedbackFormViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import UIKit
import WebKit


class FeedbackFormViewController: BaseViewController {

    let navBar = NavBarView()
    let line = UIView()
    let webView = WKWebView()
    
//    let FEEDBACK_FORM = "https://docs.google.com/forms/d/e/1FAIpQLSfoGi4VkL99kV4nESvK71k4NgzcVuIo4o-JDrlmBqArLR_IYA/viewform"
    let FEEDBACK_FORM = "https://improvethenews.typeform.com/contact-us"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        self.view.addSubview(self.line)
        self.line.backgroundColor = .red
        self.line.activateConstraints([
            self.line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.line.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.view.addSubview(self.webView)
        self.webView.activateConstraints([
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.topAnchor.constraint(equalTo: self.line.bottomAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.webView.navigationDelegate = self
        
        self.refreshDisplayMode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Feedback")            
        }
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
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.line.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }

}

extension FeedbackFormViewController: WKNavigationDelegate {

    private func loadContent() {
        self.showLoading()
            
        if let _url = URL(string: self.FEEDBACK_FORM) {
            let request = URLRequest(url: _url)
            self.webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
    }

}

extension FeedbackFormViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
