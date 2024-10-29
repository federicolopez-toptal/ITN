//
//  PodcastViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/10/2024.
//

import Foundation
import UIKit
import WebKit


class PodcastViewController: BaseViewController {
    
    let navBar = NavBarView()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Verity Podcasts")
            self.navBar.addBottomLine()
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        let C = CSS.shared.displayMode().main_bgColor
        self.view.backgroundColor = .systemPink
        let _m: CGFloat = 0
        
        let webView = WKWebView()
        self.view.addSubview(webView)
        webView.activateConstraints([
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: _m),
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()+_m),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -_m),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset()-_m)
        ])
        
        let HTML = self.podcastHTML()
        webView.loadHTMLString(HTML, baseURL: nil)
//        webView.navigationDelegate = self
    }
    
    func podcastHTML() -> String {
        var BG_COLOR = DARK_MODE() ? "#19191C" : "#F0F0F0"
        var IFRAME_THEME = DARK_MODE() ? "dark" : "light"
    
        var text = READ_LOCAL(resFile: "podcast.html")
        text = text.replacingOccurrences(of: "BG_COLOR", with: BG_COLOR)
        text = text.replacingOccurrences(of: "IFRAME_THEME", with: IFRAME_THEME)
        
        return text
    }
    
}

// MARK: misc
extension PodcastViewController: UIGestureRecognizerDelegate {
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
