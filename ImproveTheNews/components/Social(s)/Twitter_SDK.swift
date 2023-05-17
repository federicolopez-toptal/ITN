//
//  Twitter_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/05/2023.
//

import Foundation
import UIKit
import WebKit


class Twitter_SDK: NSObject {
    
    static let shared = Twitter_SDK()
    
    var vc: UIViewController?
    let webView = WKWebView()
    var callback: ( (Bool)->() )?
    
    func login(vc: UIViewController, callback: @escaping (Bool)->()) {
        self.vc = vc
        self.webView.navigationDelegate = self
        self.callback = callback
        
        let nav = self.createNavController()
        self.loadLoginPage()
        self.vc?.present(nav, animated: true)
    }

}

//MARK: - Utils
extension Twitter_SDK {
    private func buildLoginUrl() -> String {
        return "http://www.twitter.com"
    }
    
    func loadLoginPage() {
        let urlRequest = URLRequest.init(url: URL.init(string: self.buildLoginUrl())!)
        self.webView.load(urlRequest)
    }
}

//MARK: - WKWebView & parsing
extension Twitter_SDK: WKNavigationDelegate {
}

// MARK: - UI
extension Twitter_SDK {

    func createNavController() -> UINavigationController {
        let vc = UIViewController()
        
        vc.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            self.webView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])
        
        //---
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
            target: self,
            action: #selector(self.cancelAction))
        vc.navigationItem.leftBarButtonItem = cancelButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
            target: self,
            action: #selector(self.refreshAction))
        vc.navigationItem.rightBarButtonItem = refreshButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .red // Twitter sky blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        vc.navigationItem.title = "twitter.com"
        nav.navigationBar.tintColor = UIColor.white
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .coverVertical
        
        return nav
    }
    
    //---
    private func createViewController() -> UIViewController {
        let vc = UIViewController()
        
        vc.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            self.webView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])
        
        return vc
    }
    
    //---
    @objc func cancelAction() {
        DispatchQueue.main.async {
            self.vc?.dismiss(animated: true, completion: nil)
        }
    }
    
    //---
    @objc func refreshAction() {
        self.webView.reload()
    }
}



/*

postOAuthRequestToken

 */
