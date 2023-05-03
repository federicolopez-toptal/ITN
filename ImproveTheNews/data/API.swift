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
}
// ---


class API {

    static let shared = API()
    static let defaultErrorMessage = "An error ocurred. Please, try again later"

    var isLogged = false

// ---
    func signUp(email: String, password: String, newsletter: Bool = false,
        callback: @escaping (Bool, String) -> () ) {
    
        let json: [String: String] = [
            "type": "Sign Up",
            "userId": UUID.shared.getValue(),
            "email": email,
            "password": password,
            "newsletter": newsletter ? "Y" : "N",
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
    func signIn(email: String, password: String, callback: @escaping (Bool, String) -> () ) {
        
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
                        if let _values = _json["slidercookies"] {
                            /*
                                Hacer algo con los slider values
                                Ejemplo de valor:
                                LR50PE50NU70DE70SL70RE70lO00yT01pC01aL00mL00nL01SS00VA01VB01VC01VM01VE00oB10IN00FB00LI00TW00RD00ST01LA20AP01
                            */
                        }
                    
                        if let _jwt = _json["jwt"], let _uuid = _json["uuid"] as? String {
                            WRITE(LocalKeys.user.JWT, value: _jwt)
                            WRITE(LocalKeys.user.UUID, value: _uuid)
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
    func subscribeToNewsletter(email: String, callback: @escaping (Bool, String?) -> () ) {
        
        let json: [String: String] = [
            "type": "Subscribe",
            "userId": UUID.shared.getValue(),
            "email": email
        ]
        
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
        
        self.makeRequest(to: "user/", with: json) { (success, json, serverMsg) in
            if let _json = json, success {
                if let _msg = _json["message"] as? String, _msg == "OK" {
                    
                    var user = MyUser()
                    if let _firstName = _json["firstname"] as? String {
                        user.firstName = _firstName
                    }
                    if let _lastName = _json["lastname"] as? String {
                        user.lastName = _lastName
                    }
                    if let _screenName = _json["username"] as? String {
                        user.userName = _screenName
                    }
                    if let _email = _json["email"] as? String {
                        user.email = _email
                    }
                
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
}

extension API {

    private func makeRequest(to urlPath: String, with bodyJson: [String: String],
        method: String = "POST",
        callback: @escaping (Bool, [String: Any]?, String) -> ()) {
        
        //let url = "https://biaspost.org/api/" + urlPath
        let url = "https://biaspedia.org/api/" + urlPath
        
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
        return "Bearer " + READ(LocalKeys.user.JWT)!
    }
    
}

