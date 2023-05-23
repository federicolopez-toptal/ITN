//
//  LinkedIn_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 12/05/2023.
//

import Foundation
import UIKit
import WebKit


class LinkedIn_SDK: NSObject {
    
    private let CLIENT_ID = "86hkerhuw16kd6"
    private let CLIENT_SECRET = "fYU2FzY8VBhCvOO2"
    
    private let AUTH_URL = "https://www.linkedin.com/oauth/v2/authorization"
    private let SCOPE = "r_liteprofile%20r_emailaddress%20w_member_social"
    private let REDIRECT_URI = "https://www.improvemynews.com/php/linkedin/loader.php"
    private let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
    
    static let shared = LinkedIn_SDK()
    
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
    
    func disconnect(callback: @escaping (Bool)->()) {
        API.shared.socialDisconnect(socialName: "Linkedin") { (success, serverMsg) in
            callback(success)
            self.logout_web()
        }
    }
    
    private func logout_web() {
        DispatchQueue.main.async {
            let url = "https://linkedin.com/m/logout"
            var request = URLRequest(url: URL(string: url)!)
            self.webView.load(request)
        }
    }
    
}

//MARK: - Utils
extension LinkedIn_SDK {
    private func buildLoginUrl() -> String {
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let fullAuthUrl = AUTH_URL + "?response_type=code&client_id=" + CLIENT_ID +
            "&scope=" + SCOPE + "&state=" + state + "&redirect_uri=" + REDIRECT_URI
            
        return fullAuthUrl
    }
    
    func loadLoginPage() {
        let urlRequest = URLRequest.init(url: URL.init(string: self.buildLoginUrl())!)
        self.webView.load(urlRequest)
    }
}

//MARK: - WKWebView & parsing
extension LinkedIn_SDK: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = (navigationAction.request.url?.absoluteString)! as String
        
        if(url.contains("?code=")) {
            decisionHandler(.cancel)
            
            let code = self.getAuthCodeFrom(url: url)
            self.getAccessTokenWith(authCode: code) { (token) in
                if let _token = token {
                    self.local_ITNLogin(_token)
                } else {
                    self.callback!(false)
                }
            }
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    //---
    private func getAuthCodeFrom(url: String) -> String {
        let _url = URL(string: url)
        let params = _url?.params()
        let code = params?["code"] as! String
        
        return code
    }
    
    //---
    private func getAccessTokenWith(authCode: String, callback: @escaping (String?) -> ()) {
        // POST params
        let grantType = "authorization_code"
        let postParams = "grant_type=" + grantType +
            "&code=" + authCode + "&redirect_uri=" + REDIRECT_URI + "&client_id=" +
            CLIENT_ID + "&client_secret=" + CLIENT_SECRET
        
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (D, R, E) -> Void in
            if let _error = E {
                print("LINKEDIN", _error.localizedDescription)
                callback(nil)
                return
            }
            
            let statusCode = (R as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: D!,
                    options: .allowFragments) as? [AnyHashable: Any]

                let accessToken = results?["access_token"] as! String
                callback(accessToken)
            } else {
                callback(nil)
            }
        }
        task.resume()
    }
    
    //---
    func local_ITNLogin(_ token: String) {
        MAIN_THREAD {
            CustomNavController.shared.loading.show()
        }

        API.shared.socialLogin(socialName: "Linkedin", accessToken: token) { (success, serverMsg) in
            MAIN_THREAD {
                //CustomNavController.shared.loading.hide()
                
                if(success) {
                    self.vc?.dismiss(animated: true, completion: nil)
                }
            }

            self.callback!(success)
        }
    }
    
}

// MARK: - UI
extension LinkedIn_SDK {

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
        appearance.backgroundColor = UIColor(hex: 0x0B66C2) // LinkedIn blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        vc.navigationItem.title = "linkedin.com"
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
            self.callback!(false)
        }
    }
    
    //---
    @objc func refreshAction() {
        self.webView.reload()
    }
}
