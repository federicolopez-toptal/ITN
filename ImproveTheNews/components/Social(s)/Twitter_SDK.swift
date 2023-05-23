//
//  Twitter_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/05/2023.
//  Twitter documentation: https://developer.twitter.com/en/docs/authentication/api-reference/request_token
//

import Foundation
import UIKit
import WebKit


class Twitter_SDK: NSObject {
    
    private let API_KEY = "ysqrSma3OfWLXT2d0XgvfNNV7"
    private let API_KEY_SECRET = "8KTYdDUpG9pU4BNJ0v1EzHRMywnIm6rxbcRFjz0wrTvzWk0sKH"
    
    private let REQ_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
    private let AUTH_URL = "https://api.twitter.com/oauth/authorize"
    private let REDIRECT_URI = "ITNTestApp://" //"https://www.improvemynews.com/php/twitter/loader.php"
    private let OAUTH_SIGN_METHOD = "HMAC-SHA1"
    private let OAUTH_VERSION = "1.0"

    static let shared = Twitter_SDK()
    
    var vc: UIViewController?
    let webView = WKWebView()
    var callback: ( (Bool)->() )?
    
    
    func login(vc: UIViewController, callback: @escaping (Bool)->()) {
        self.vc = vc
        self.webView.navigationDelegate = self
        self.callback = callback
        
        self.requestInitialToken { (error, token) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(false)
            } else {
                if let _token = token {
                    MAIN_THREAD {
                        self.loadLoginPage(token: _token)
                    }
                } else {
                    print("Unexpected error!")
                    callback(false)
                }
            }
        }
    }
    
    private func loadLoginPage(token: String) {
        let nav = self.createNavController()
        
        let url = AUTH_URL + "?oauth_token=" + token
        let urlRequest = URLRequest.init(url: URL.init(string: url)!)
        self.webView.load(urlRequest)
        
        self.vc?.present(nav, animated: true)
    }

}

//MARK: - Utils
extension Twitter_SDK {

    func requestInitialToken(callback: @escaping (Error?, String?) -> () ) {
        let url = REQ_TOKEN_URL + "?oauth_callback=" + REDIRECT_URI.urlEncodedString()
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue(self.buildAuthStr(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _ = error {
                callback(error, nil)
            } else {
                if let _data = data, let _responseString = String(data: _data, encoding: .utf8) {
                    let attributes = _responseString.queryStringParameters
                    if let _token = attributes["oauth_token"] {
//                    let secret = attributes["oauth_token_secret"]!
//                    let callbackConfirmed = attributes["oauth_callback_confirmed"]
                        callback(nil, _token)
                    } else {
                        callback(nil, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func buildAuthStr() -> String {
        let nonce = UUID.shared.getValue()
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        
        let params : [String: Any] = [
            "oauth_timestamp": timeStamp,
            "oauth_consumer_key": API_KEY,
            "oauth_nonce": nonce,
            "oauth_callback": REDIRECT_URI,
            "oauth_signature_method": OAUTH_SIGN_METHOD,
            "oauth_version": OAUTH_VERSION
        ]
        
        var authStr = "OAuth "
        authStr += "oauth_callback=" + strInQuotes(REDIRECT_URI.urlEncodedString())
        authStr += "oauth_consumer_key=" + strInQuotes(API_KEY)
        authStr += "oauth_nonce=" + strInQuotes(nonce)
        authStr += "oauth_signature=" + strInQuotes(oAuthSignature(parameters: params).urlEncodedString())
        authStr += "oauth_signature_method=" + strInQuotes(OAUTH_SIGN_METHOD)
        authStr += "oauth_timestamp=" + strInQuotes(timeStamp)
        authStr += "oauth_version=" + strInQuotes(OAUTH_VERSION, addComma: false)
        
        return authStr
    }

    private func strInQuotes(_ value: String, addComma: Bool = true) -> String {
        var result = "\"" + value + "\""
        if(addComma){ result += ", " }
        return result
    }
    
    private func oAuthSignature(parameters: [String: Any]) -> String {
        let url = URL(string: REQ_TOKEN_URL)!
        let tokenSecret = ""
        
        let encodedConsumerSecret = API_KEY_SECRET.urlEncodedString()
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        let parameterComponents = parameters.urlEncodedQueryString(using: .utf8).components(separatedBy: "&").sorted()
        let parameterString = parameterComponents.joined(separator: "&")
        let encodedParameterString = parameterString.urlEncodedString()
        let encodedURL = url.absoluteString.urlEncodedString()
        let signatureBaseString = "POST&\(encodedURL)&\(encodedParameterString)"
        
        let key = signingKey.data(using: .utf8)!
        let msg = signatureBaseString.data(using: .utf8)!
        let sha1 = HMAC.sha1(key: key, message: msg)!
        return sha1.base64EncodedString(options: [])
    }
    
    //---
    func local_ITNLogin(token: String, verifier: String) {
        API.shared.socialLogin(socialName: "Twitter", accessToken: token, verifier: verifier) { (success, serverMsg) in
            if(success) {
                self.cancelAction()
            }
            
            self.callback!(success)
        }
    }
}

//MARK: - WKWebView & parsing
extension Twitter_SDK: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = (navigationAction.request.url?.absoluteString)! as String
        print("URL", url)
        
        if(url.lowercased().contains(REDIRECT_URI.lowercased())) {
            decisionHandler(.cancel)
            
            if let _params = URL(string: url)?.params() {
                let token = _params["oauth_token"] as? String
                let verifier = _params["oauth_verifier"] as? String
                
                if let _T = token, let _V = verifier {
                    self.local_ITNLogin(token: _T, verifier: _V)
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
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
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
            action: #selector(self.cancelAction))
        vc.navigationItem.leftBarButtonItem = cancelButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
            action: #selector(self.refreshAction))
        vc.navigationItem.rightBarButtonItem = refreshButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: 0x479BF0) // Twitter sky blue
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



