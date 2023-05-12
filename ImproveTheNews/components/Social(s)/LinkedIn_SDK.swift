//
//  LinkedIn_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 12/05/2023.
//

import Foundation
import UIKit
import WebKit


class LinkedIn_SDK: SocialBasic_SDK {
    
    static let shared = LinkedIn_SDK()
    
    private let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    private let CLIENT_ID = "86hkerhuw16kd6"
    private let CLIENT_SECRET = "fYU2FzY8VBhCvOO2"
    private let SCOPE = "r_liteprofile%20r_emailaddress%20w_member_social"
    private let REDIRECT_URI = "https://www.improvemynews.com/php/linkedin/loader.php"
    private let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
    
    
    func login(vc: UIViewController, callback: @escaping (Bool)->()) {
        self.vc = vc
        self.webView.navigationDelegate = self
        self.callback = callback
        self.bgColor = UIColor(hex: 0x0B66C2)        
        self.loginUrl = self.buildLoginUrl()
        
        let nav = self.createNavController(title: "linkedin.com")
        self.loadLoginPage()
        self.vc?.present(nav, animated: true)
    }
    
}

extension LinkedIn_SDK: WKNavigationDelegate {
    
    private func buildLoginUrl() -> String {
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let fullAuthUrl = AUTHURL + "?response_type=code&client_id=" + CLIENT_ID +
            "&scope=" + SCOPE + "&state=" + state + "&redirect_uri=" + REDIRECT_URI
            
        return fullAuthUrl
    }
    
    //---
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = (navigationAction.request.url?.absoluteString)! as String
        
        if(url.contains("?code=")) {
            decisionHandler(.cancel)
            
            let code = self.getAuthCodeFrom(url: url)
            self.getAccessTokenWith(authCode: code) { (token) in
                if let _token = token {
                    self.ITN_login(_token)
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
    func ITN_login(_ token: String) {
        API.shared.socialLogin(socialName: "Linkedin", accessToken: token) { (success, serverMsg) in
            self.callback!(success)
        }
    }
    
}
