//
//  API.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/04/2023.
//

import Foundation

// ---
struct MyUser {
    var firstName = ""
    var lastName = ""
    var userName = ""
    var email = ""
    var socialnetworks = [String]()
    var sliderValues = ""
    
//    var subscriptionType = 0 // 0: Not subscribed, 1: Daily, 2: Weekly
    var subscriptions = [String]()
    var verified = false
    
    init() {
    }
    
    init(_ json: [String: Any]) {
        if let _firstName = json["firstname"] as? String {
            self.firstName = _firstName
        }
        if let _lastName = json["lastname"] as? String {
            self.lastName = _lastName
        }
        if let _screenName = json["username"] as? String {
            self.userName = _screenName
        }
        if let _email = json["email"] as? String {
            self.email = _email
        }
        
        self.subscriptions = []
        if let _SOptions = json["subscription-options"] as? [String] {
            self.subscriptions = _SOptions
        }
        
//        if let _subscribed = json["subscribed"] as? String {
////            self.subscriptionType = 0
//            if(_subscribed == "Y") {
////                self.subscriptionType = 1
////                if let _subscription = json["subscription"] as? [String: Any] {
////                    if let _strType = _subscription["frequency"] as? String {
////                        if(_strType.lowercased() == "daily") {
////                            self.subscriptionType = 1
////                        } else {
////                            self.subscriptionType = 2
////                        }
////                    }
////                }
//            }
//        }
        
        if let _socialnetworks = json["socialnetworks"] as? [String] {
            self.socialnetworks = _socialnetworks
        }
        
        if let _sliderValues = json["slidercookies"] as? String {
            self.sliderValues = _sliderValues
        }
        
        self.verified = false
        if let _verified = json["verified"] as? String {
            if(_verified.uppercased() == "Y") {
                self.verified = true
            }
        }
    }
}
// ---


class API {

    static let shared = API()
    static let defaultErrorMessage = "An error ocurred. Please, try again later"

    var isLogged = false

// ---
    func signUp(email: String, password: String, newsletter: Int,
        callback: @escaping (Bool, String) -> () ) {
    
        let newsletterState = (newsletter == 0) ? "N" : "Y"
        var subscriptionValue: [String] = []
        if(newsletter == 1){ subscriptionValue = ["daily"] }
        else if(newsletter == 2){ subscriptionValue = ["weekly"] }
    
        let json: [String: Any] = [
            "type": "Sign Up",
            "userId": UUID.shared.getValue(),
            "email": email,
            "password": password,
            "newsletter": newsletterState,
            "subscription": subscriptionValue,
            "app": "iOS"
        ]
    
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["status"] as? String {
                    if(_status == "OK") {
                        if let _jwt = _json["jwt"], let _uuid = _json["uuid"] as? String {
                            WRITE(LocalKeys.user.JWT, value: _jwt)
                            WRITE(LocalKeys.user.UUID, value: _uuid)
                        }
                        if let _sliderValues = _json["slidercookies"] as? String, !_sliderValues.isEmpty {
                            MainFeedv3.parseSliderValues(_sliderValues)
                        }
                        
                        callback(true, "")
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, serverMsg)
                        }
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
    
    func signUp(email: String, subscriptions: [String], callback: @escaping (Bool, String) -> () ) {
    
        let json: [String: Any] = [
            "type": "Sign Up",
            "userId": UUID.shared.getValue(),
            "email": email,
            "subscription": subscriptions,
            "app": "iOS"
        ]
    
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["status"] as? String {
                    if(_status == "OK") {
                        if let _jwt = _json["jwt"], let _uuid = _json["uuid"] as? String {
                            WRITE(LocalKeys.user.JWT, value: _jwt)
                            WRITE(LocalKeys.user.UUID, value: _uuid)
                        }
                        if let _sliderValues = _json["slidercookies"] as? String, !_sliderValues.isEmpty {
                            MainFeedv3.parseSliderValues(_sliderValues)
                        }
                        
                        callback(true, "")
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, serverMsg)
                        }
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func  signIn(email: String, password: String, callback: @escaping (Bool, String, Bool) -> () ) {
        
        let json: [String: String] = [
            "type": "Sign In",
            "userId": UUID.shared.getValue(),
            "email": email,
            "password": password,
            "app": "iOS"
        ]
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["status"] as? String {
                    if(_status == "OK") {
                        if let _jwt = _json["jwt"], let _uuid = _json["uuid"] as? String {
                            WRITE(LocalKeys.user.JWT, value: _jwt)
                            WRITE(LocalKeys.user.UUID, value: _uuid)
                        }
                        
                        var gotCookies = false
                        if let _sliderValues = _json["slidercookies"] as? String, !_sliderValues.isEmpty {
                            MainFeedv3.parseSliderValues(_sliderValues)
                            gotCookies = true
                        }
                        
                        callback(true, "", gotCookies)
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg, false)
                        } else {
                            callback(false, serverMsg, false)
                        }
                    }
                } else {
                    callback(false, serverMsg, false)
                }
            } else {
                callback(false, serverMsg, false)
            }
        }
    }
// ---
    func resendVerificationEmail(email: String, callback: @escaping (Bool, String) -> () ) {
        
        let json: [String: String] = [
            "type": "Resend Email Verification",
            "email": email,
            "app": "iOS"
        ]
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["status"] as? String {
                    if(_status == "OK") {
                        callback(true, "")
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, serverMsg)
                        }
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func subscribeToNewsletter(email: String, _ state: Bool = true, callback: @escaping (Bool, String) -> () ) {
        
        var json: [String: String] = [
            "type": "Subscribe",
            "userId": UUID.shared.getValue(),
            "email": email
        ]
        if(!state) {
            json = [
                "type": "Unsubscribe",
                "userId": UUID.shared.getValue()
            ]
        }
        
        self.makeRequest(to: "newsletter/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["message"] as? String {
                    if(_status == "OK") {
                        callback(true, "")
                    } else {
                        callback(false, serverMsg)
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func changeSubscriptionTypeTo(type: Int, email: String, callback: @escaping (Bool, String) -> () ) {
        
        var freq = "Daily"
        if(type==2){ freq = "Weekly" }
        
        let json: [String: String] = [
            "type": "Options",
            "userId": UUID.shared.getValue(),
            "email": email,
            "frequency": freq
        ]
        
        print(UUID.shared.getValue())
        
        self.makeRequest(to: "newsletter/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["message"] as? String {
                    if(_status == "OK") {
                        callback(true, "")
                    } else {
                        callback(false, serverMsg)
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func changeSubscriptionTypeTo(types: [String], email: String, callback: @escaping (Bool, String) -> () ) {
        
        let json: [String: Any] = [
            "type": "Options",
            "userId": UUID.shared.getValue(),
            "email": email,
            "frequency": types
        ]
        
        print(UUID.shared.getValue())
        
        self.makeRequest(to: "newsletter/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["message"] as? String {
                    if(_status == "OK") {
                        callback(true, "")
                    } else {
                        callback(false, serverMsg)
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func getUserInfo( callback: @escaping (Bool, String, MyUser?) -> () ) {
        let json: [String: String] = [
            "type": "User Info Get",
            "userId": UUID.shared.getValue()
        ]
        
//        print("USER_ID", UUID.shared.getValue())
//        print("AUTH", self.getBearerAuth() )
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _msg = _json["message"] as? String, _msg == "OK" {
                    let user = MyUser(_json)
                    callback(true, "", user)
                } else {
                    callback(false, serverMsg, nil)
                }
            } else {
                callback(false, serverMsg, nil)
            }
        }
    }
// ---
    func savesSliderValues(_ values: String) {
        if(USER_AUTHENTICATED()) {
            let json: [String: String] = [
                "type": "slidercookies",
                "userId": UUID.shared.getValue(),
                "slidercookies": values
            ]
            
            self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            }
        }
    }

// ---
    func userInfoSave(user: MyUser?, callback: @escaping (Bool, String) -> () ) {
        var json: [String: String] = [
            "type": "User Info Update",
            "userId": UUID.shared.getValue()
        ]
        
        if let _name = user?.firstName {
            json["firstName"] = _name
        }
        if let _lastName = user?.lastName {
            json["lastName"] = _lastName
        }
        if let _screenName = user?.userName {
            json["username"] = _screenName
        }
        if let _email = user?.email {
            json["email"] = _email
        }
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _msg = _json["message"] as? String, _msg == "OK" {
//                    let user = MyUser(_json)
                    callback(true, "")
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func resetPassword(email: String, callback: @escaping (Bool, String) -> ()) {
        let json: [String: String] = [
            "type": "Generate Password Reset Link",
            "email": email,
            "app": "iOS"
        ]
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["status"] as? String {
                    if(_status == "OK") {
                        callback(true, "")
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, serverMsg)
                        }
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func deleteAccount(callback: @escaping (Bool, String) -> () ) {
        
        let json: [String: String] = [
            "type": "Disconnect All",
            "userId": UUID.shared.getValue()
        ]
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _msg = _json["message"] as? String, _msg == "OK" {
                    callback(true, "")
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
    
//---
    func socialLogin(socialName: String, accessToken: String,
        verifier: String? = nil, callback: @escaping (Bool, String) -> ()) {
        
        var json: [String: String] = [
            "type": socialName,
            "userId": UUID.shared.getValue(),
            "access_token": accessToken,
            "option": "Sign In",
            "newsletter": "Y",
            "app": "iOS"
        ]
        
        if let _secret = verifier {
            json["secret_token"] = _secret
        }
    
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _status = _json["message"] as? String {
                    if(_status == "OK") {
                        if let _sliderValues = _json["slidercookies"] as? String, !_sliderValues.isEmpty {
                            MainFeedv3.parseSliderValues(_sliderValues)
                        }
                        callback(true, "")
                    } else {
                        callback(false, serverMsg)
                    }
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
//---
    func socialDisconnect(socialName: String, callback: @escaping (Bool, String) -> ()) {
        let json: [String: String] = [
            "type": "Disconnect",
            "userId": UUID.shared.getValue(),
            "socialNetwork": socialName
        ]
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _msg = _json["message"] as? String, _msg == "OK" {
                    callback(true, "")
                } else {
                    callback(false, serverMsg)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
//---
}

extension API {

    private func makeRequest(to urlPath: String, with bodyJson: [String: Any],
        method: String = "POST",
        callback: @escaping (Bool, [String: Any]?, String) -> ()) {
        
        let url = BIASPEDIA_URL() + urlPath

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        let body = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = body
        request.setValue(self.getBearerAuth(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, resp, error in
            if let _error = error {
                callback(false, nil, _error.localizedDescription)
            } else {
                if let _json = JSON(fromData: data) {
                    callback(true, _json, "")
                } else {
                    callback(false, nil, API.defaultErrorMessage)
                }
                
            }
        }
        task.resume()
    }

    private func getBearerAuth() -> String {
        var result = ""
        
        if let _jwt = READ(LocalKeys.user.JWT) {
            result = "Bearer " + _jwt
        }
    
        return result
    }
    
}

