//
//  API.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/04/2023.
//

import Foundation

class API {

    static let shared = API()

// ---
    func signUp(email: String, password: String, newsletter: Bool = false,
        callback: @escaping (Bool, String?) -> () ) {
    
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
                            WRITE(LocalKeys.user.UUID, value: _uuid) //!!!
                        }
                        callback(true, nil)
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, nil)
                        }
                    }
                } else {
                    callback(false, nil)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
    func signIn(email: String, password: String, callback: @escaping (Bool, String?) -> () ) {
        
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
                            WRITE(LocalKeys.user.UUID, value: _uuid) //!!!
                        }
                        callback(true, nil)
                    } else {
                        if let _msg = _json["message"] as? String {
                            callback(false, _msg)
                        } else {
                            callback(false, nil)
                        }
                    }
                } else {
                    callback(false, nil)
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
                        callback(true, nil)
                    } else {
                        callback(false, nil)
                    }
                } else {
                    callback(false, nil)
                }
            } else {
                callback(false, serverMsg)
            }
        }
    }
// ---
}

extension API {

    private func makeRequest(to urlPath: String, with bodyJson: [String: String],
        method: String = "POST",
        callback: @escaping (Bool, [String: Any]?, String?) -> ()) {
        
        let url = "https://biaspost.org/api/" + urlPath
        
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
                    callback(true, _json, nil)
                } else {
                    callback(false, nil, nil)
                }
                
            }
        }
        task.resume()
    }

    private func getBearerAuth() -> String {
        return "Bearer " + READ(LocalKeys.user.JWT)!
    }
    
}
