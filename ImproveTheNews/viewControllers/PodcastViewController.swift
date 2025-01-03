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
        self.view.backgroundColor = C
        var _m: CGFloat = 0
        
        let webView = WKWebView()
        self.view.addSubview(webView)
        
        if(IPAD()) {
            _m = 12
            webView.activateConstraints([
                webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()+_m),
                
                webView.widthAnchor.constraint(equalToConstant: 670),
                webView.heightAnchor.constraint(equalToConstant: 470)
            ])
        } else {
            webView.activateConstraints([
                webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: _m),
                webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()+_m),
                webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -_m),
                webView.heightAnchor.constraint(equalToConstant: 470)
            ])
        }
        
        let HTML = self.podcastHTML()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.loadHTMLString(HTML, baseURL: nil)
        
        _m = 12
        let listenAlsoLabel = HyperlinkLabel.parrafo2(text: "Listen also on [0], [1], [2], [3] and [4]",
                                linkTexts: ["Spotify", "Amazon", "Podbean", "iHeart Radio", "PlayerFM"],
                                    urls: ["https://open.spotify.com/show/6f0N5HoyXABPBM8vS0iI8H",
                                        "https://music.amazon.com/podcasts/f5de9928-7979-4710-ab1a-13dc22007e70/verity",
                                        "https://maxry.podbean.com/?ref=verity.news/podcasts",
                                        "https://www.iheart.com/podcast/338-verity-95449534/?ref=verity.news/podcasts",
                                        "https://player.fm/series/3338118?ref=verity.news/podcasts"],
                                onTap: self.onLinkTap(_:))
                                
        self.view.addSubview(listenAlsoLabel)
        listenAlsoLabel.activateConstraints([
            listenAlsoLabel.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: _m),
            listenAlsoLabel.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -_m),
            listenAlsoLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: _m),
        ])
    }
    
    func podcastHTML() -> String {
        let BG_COLOR = DARK_MODE() ? "#19191C" : "#F0F0F0"
        let IFRAME_THEME = DARK_MODE() ? "dark" : "light"
    
        var text = READ_LOCAL(resFile: "podcast.html")
        text = text.replacingOccurrences(of: "BG_COLOR", with: BG_COLOR)
        text = text.replacingOccurrences(of: "IFRAME_THEME", with: IFRAME_THEME)
        
        return text
    }
    
    func onLinkTap(_ url: URL) {
        OPEN_URL(url.absoluteString)
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

extension PodcastViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.mainDocumentURL?.absoluteString {
            decisionHandler(.allow)
        }
    }
}

extension PodcastViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let _url = navigationAction.request.url?.absoluteString {
            OPEN_URL(_url)
        }
        
        return nil
    }
}


