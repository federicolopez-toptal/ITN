//
//  SocialBasic_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 12/05/2023.
//

import Foundation
import UIKit
import WebKit


class SocialBasic_SDK: NSObject {
    
    var vc: UIViewController?
    var callback: ( (Bool)->() )?
    var bgColor = UIColor.red
    var loginUrl: String? = nil
    
    let webView = WKWebView()
    
// ---
    func createNavController(title _title: String) -> UINavigationController {
        let vc = self.createSocialViewController()
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
        appearance.backgroundColor = self.bgColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        vc.navigationItem.title = _title
        nav.navigationBar.tintColor = UIColor.white
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .coverVertical
        
        return nav
    }
    
// ---
    private func createSocialViewController() -> UIViewController {
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

// ---
    func loadLoginPage() {
        if let _url = self.loginUrl {
            let urlRequest = URLRequest.init(url: URL.init(string: _url)!)
            self.webView.load(urlRequest)
        }
    }

// ---
    @objc func cancelAction() {
        DispatchQueue.main.async {
            self.vc?.dismiss(animated: true, completion: nil)
        }
    }
    
// ---
    @objc func refreshAction() {
        self.webView.reload()
    }
}


