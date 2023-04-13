//
//  API.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/04/2023.
//

import Foundation

class API {

    static let shared = API()

    func subscribeToNewsletter(email: String, callback: @escaping (Bool) -> () ) {
        //let url = API_BASE_URL() + "/api/newsletter/"
        let url = "https://biaspost.org/api/newsletter/"
        
        let bodyJson: [String: String] = [
            "type": "Subscribe",
            "userId": UUID.shared.getValue(),
            "email": email
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let body = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = body
        request.setValue(getBearerAuth(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                callback(false)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _status = _json["message"] as? String {
                        if(_status == "OK") {
                            callback(true)
                        } else {
                            callback(false)
                        }
                    } else {
                        callback(false)
                    }
                } else {
                    callback(false)
                }
            }
        }
        task.resume()
    }

}

extension API {

    private func getBearerAuth() -> String {
        return "Bearer " + READ(LocalKeys.user.JWT)!
    }
    
}
