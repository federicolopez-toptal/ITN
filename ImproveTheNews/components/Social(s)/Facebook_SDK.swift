//
//  Facebook_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/05/2023.
//

import Foundation
import UIKit
import WebKit


class Facebook_SDK: NSObject {

    static let shared = Facebook_SDK()
    
    private let APP_ID = "562579928156269" //"562579928156269"
    
    private let OAUTH_URL = "https://www.facebook.com/v16.0/dialog/oauth"
    private let REDIRECT_URI = "https://www.facebook.com/connect/login_success.html"
    
    
    var vc: UIViewController?
    let webView = WKWebView()
    var callback: ( (Bool)->() )?
    
    func login(vc: UIViewController, callback: @escaping (Bool)->()) {
        self.vc = vc
        self.webView.navigationDelegate = self
        self.callback = callback
        
        self.loadLoginPage()
        //logout_web()
    }
    
    private func loadLoginPage() {
        let nav = self.createNavController()
        
//        var url = OAUTH_URL + "?app_id=" + APP_ID
        var url = "https://www.facebook.com/login.php?skip_api_login=1&api_key=562579928156269&kid_directed_site=0&app_id=562579928156269&signed_next=1&next=https%3A%2F%2Fwww.facebook.com%2Fv9.0%2Fdialog%2Foauth%3Fapp_id%3D562579928156269%26cbt%3D1684850867919%26channel_url%3Dhttps%253A%252F%252Fstaticxx.facebook.com%252Fx%252Fconnect%252Fxd_arbiter%252F%253Fversion%253D46%2523cb%253Df53844dbb4eda2%2526domain%253Dwww.improvethenews.org%2526is_canvas%253Dfalse%2526origin%253Dhttps%25253A%25252F%25252Fwww.improvethenews.org%25252Ff3172af34976d6e%2526relation%253Dopener%26client_id%3D562579928156269%26display%3Dpopup%26domain%3Dwww.improvethenews.org%26e2e%3D%257B%257D%26fallback_redirect_uri%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Fsign-up%26locale%3Den_US%26logger_id%3Df2ba6c7b5f78a4a%26origin%3D1%26redirect_uri%3Dhttps%253A%252F%252Fstaticxx.facebook.com%252Fx%252Fconnect%252Fxd_arbiter%252F%253Fversion%253D46%2523cb%253Dfddd347de94a0e%2526domain%253Dwww.improvethenews.org%2526is_canvas%253Dfalse%2526origin%253Dhttps%25253A%25252F%25252Fwww.improvethenews.org%25252Ff3172af34976d6e%2526relation%253Dopener%2526frame%253Df2e515cdba62b98%26response_type%3Dtoken%252Csigned_request%252Cgraph_domain%26return_scopes%3Dfalse%26scope%3Dpublic_profile%252C%2Bemail%26sdk%3Djoey%26version%3Dv9.0%26ret%3Dlogin%26fbapp_pres%3D0%26tp%3Dunspecified&cancel_url=https%3A%2F%2Fstaticxx.facebook.com%2Fx%2Fconnect%2Fxd_arbiter%2F%3Fversion%3D46%23cb%3Dfddd347de94a0e%26domain%3Dwww.improvethenews.org%26is_canvas%3Dfalse%26origin%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Ff3172af34976d6e%26relation%3Dopener%26frame%3Df2e515cdba62b98%26error%3Daccess_denied%26error_code%3D200%26error_description%3DPermissions%2Berror%26error_reason%3Duser_denied&display=popup&locale=en_GB&pl_dbl=0"
        //print("LOADING", url)
        
        //url = "https://www.facebook.com"
        
        //var url = OAUTH_URL + "?client_id=" + APP_ID
//        url += "&redirect_uri=" + REDIRECT_URI.urlEncodedString()
//        url += "&state=stateExample123"
//        url += "&response_type=token"
//        url += "&scope=" + "public_profile,+email".urlEncodedString()
        
        
        let urlRequest = URLRequest.init(url: URL.init(string: url)!)
        self.webView.load(urlRequest)
        
        self.vc?.present(nav, animated: true)
    }
    
    private func logout_web() {
        DispatchQueue.main.async {
            let url = "https://www.facebook.com/logout.php"
            var request = URLRequest(url: URL(string: url)!)
            self.webView.load(request)
        }
    }
}

//MARK: - WKWebView
extension Facebook_SDK: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = (navigationAction.request.url?.absoluteString)! as String
        print("URL", url)
        
        decisionHandler(.allow)
    }
}

// MARK: - UI
extension Facebook_SDK {

    func createNavController() -> UINavigationController {
        let vc = UIViewController()
        
        vc.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: Y_TOP_NOTCH_FIX(94)),
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
        appearance.backgroundColor = UIColor(hex: 0x3B5998) // Facebook blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        vc.navigationItem.title = "facebook.com"
        nav.navigationBar.tintColor = UIColor.white
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .coverVertical
        
        nav.view.backgroundColor = .green
        
        return nav
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
https://www.facebook.com/login.php?skip_api_login=1&api_key=562579928156269&kid_directed_site=0&app_id=562579928156269&signed_next=1&next=https%3A%2F%2Fwww.facebook.com%2Fv9.0%2Fdialog%2Foauth%3Fapp_id%3D562579928156269%26cbt%3D1684850867919%26channel_url%3Dhttps%253A%252F%252Fstaticxx.facebook.com%252Fx%252Fconnect%252Fxd_arbiter%252F%253Fversion%253D46%2523cb%253Df53844dbb4eda2%2526domain%253Dwww.improvethenews.org%2526is_canvas%253Dfalse%2526origin%253Dhttps%25253A%25252F%25252Fwww.improvethenews.org%25252Ff3172af34976d6e%2526relation%253Dopener%26client_id%3D562579928156269%26display%3Dpopup%26domain%3Dwww.improvethenews.org%26e2e%3D%257B%257D%26fallback_redirect_uri%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Fsign-up%26locale%3Den_US%26logger_id%3Df2ba6c7b5f78a4a%26origin%3D1%26redirect_uri%3Dhttps%253A%252F%252Fstaticxx.facebook.com%252Fx%252Fconnect%252Fxd_arbiter%252F%253Fversion%253D46%2523cb%253Dfddd347de94a0e%2526domain%253Dwww.improvethenews.org%2526is_canvas%253Dfalse%2526origin%253Dhttps%25253A%25252F%25252Fwww.improvethenews.org%25252Ff3172af34976d6e%2526relation%253Dopener%2526frame%253Df2e515cdba62b98%26response_type%3Dtoken%252Csigned_request%252Cgraph_domain%26return_scopes%3Dfalse%26scope%3Dpublic_profile%252C%2Bemail%26sdk%3Djoey%26version%3Dv9.0%26ret%3Dlogin%26fbapp_pres%3D0%26tp%3Dunspecified&cancel_url=https%3A%2F%2Fstaticxx.facebook.com%2Fx%2Fconnect%2Fxd_arbiter%2F%3Fversion%3D46%23cb%3Dfddd347de94a0e%26domain%3Dwww.improvethenews.org%26is_canvas%3Dfalse%26origin%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Ff3172af34976d6e%26relation%3Dopener%26frame%3Df2e515cdba62b98%26error%3Daccess_denied%26error_code%3D200%26error_description%3DPermissions%2Berror%26error_reason%3Duser_denied&display=popup&locale=en_GB&pl_dbl=0
 */


/*
https://www.facebook.com/v9.0/dialog/oauth?app_id=562579928156269&cbt=1684801561517&channel_url=https%3A%2F%2Fstaticxx.facebook.com%2Fx%2Fconnect%2Fxd_arbiter%2F%3Fversion%3D46%23cb%3Df11a2e71372cf74%26domain%3Dwww.improvethenews.org%26is_canvas%3Dfalse%26origin%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Ff1edc58916051b%26relation%3Dopener&client_id=562579928156269&display=popup&domain=www.improvethenews.org&e2e=%7B%7D&fallback_redirect_uri=https%3A%2F%2Fwww.improvethenews.org%2Fsign-up&locale=en_US&logger_id=f3be766513f06b&origin=1&redirect_uri=https%3A%2F%2Fstaticxx.facebook.com%2Fx%2Fconnect%2Fxd_arbiter%2F%3Fversion%3D46%23cb%3Df17fd9b4ee07c0e%26domain%3Dwww.improvethenews.org%26is_canvas%3Dfalse%26origin%3Dhttps%253A%252F%252Fwww.improvethenews.org%252Ff1edc58916051b%26relation%3Dopener%26frame%3Df172a518836ec06&response_type=token%2Csigned_request%2Cgraph_domain&return_scopes=false&scope=public_profile%2C%20email&sdk=joey&version=v9.0
 */
