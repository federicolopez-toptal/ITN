//
//  Facebook_SDK.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/05/2023.
//

import Foundation
import FBSDKLoginKit

import UIKit
import WebKit


class Facebook_SDK: NSObject {

    static let shared = Facebook_SDK()

    var vc: UIViewController?
    var callback: ( (Bool)->() )?
    
    func login(vc: UIViewController, callback: @escaping (Bool)->()) {
        self.callback = callback
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [], from: vc) { (result, error) in
            if let _error = error {
                print("Error", _error.localizedDescription)
                callback(false)
            } else {
                if let _result = result {
                    if(_result.isCancelled) {
                        callback(false)
                    } else {
                        CustomNavController.shared.loading.show()
                        
                        let token = _result.token!.tokenString
                        self.local_ITNLogin(token)
                    }
                } else {
                    callback(false)
                }
            }
        }
    }
    
    func disconnect(callback: @escaping (Bool)->()) {
        API.shared.socialDisconnect(socialName: "Facebook") { (success, serverMsg) in
            callback(success)
            LoginManager().logOut()
        }
    }
    
    //---
    func local_ITNLogin(_ token: String) {
        MAIN_THREAD {
            CustomNavController.shared.loading.show()
        }

        API.shared.socialLogin(socialName: "Facebook", accessToken: token) { (success, serverMsg) in
            MAIN_THREAD {
                CustomNavController.shared.loading.hide()
                if(success) {
                    self.vc?.dismiss(animated: true, completion: nil)
                }
            }

            self.callback!(success)
        }
    }
}

