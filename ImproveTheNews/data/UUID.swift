//
//  UUID.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation

class UUID {
    
    static let shared = UUID()
    
    func getValue() -> String {
        if let _value = READ(LocalKeys.user.UUID) {
            return _value
        } else {
            return self.randomValue()
        }
    }
    
    func checkIfGenerated(callback: @escaping (Bool) -> ()) {
        if(READ(LocalKeys.user.UUID) != nil) {
            callback(true)
        } else {
            self.generate { (error, new_uuid) in
                if let _ = error {
                    callback(false)
                } else {
                    if(new_uuid != nil) {
                        callback(true)
                    } else {
                        callback(false)
                    }
                }
            }
        }
    }
    
    private func generate(callback: @escaping (Error?, String?) -> ()) {
        let url = "https://biaspedia.org/api/user/"
        
        let bodyJson: [String: String] = [
            "type": "Generate",
            "userId": self.randomValue(),
            "app": "iOS"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let body = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _jwt = _json["jwt"] as? String, let _uuid = _json["uuid"] as? String {
                        WRITE(LocalKeys.user.UUID, value: _uuid)
                        WRITE(LocalKeys.user.JWT, value: _jwt)
                        callback(nil, _uuid)
                    } else {
                        let _error = CustomError.jsonParseError
                        callback(_error, nil)
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, nil)
                }
            }

        }
        task.resume()
    }
    /*
    GENERATE, response example
    
    {
        "jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2NDg3NTE3MDEsImp0aSI6IjFGajlWXC9LcUtsaHB0XC9PMnpudFBTQT09IiwiaXNzIjoiaW1wcm92ZXRoZW5ld3Mub3JnIiwibmJmIjoxNjQ4NzUxNzAxLCJleHAiOjI5NjM3NTk3MDEsImRhdGEiOnsidXNyaWQiOiIzNTAxODQwMDE2OTg1Mzk0MTE1In19.itVlxjouwB9aPwHsJUQYO_EyEFBZzmPg-RedpfYZfWj3UkaJf6HZlK85o6J60Dff_UekoMuMSJy9TpiAAYbiEw",
        "uuid":"3501840016985394115"
    }
    */
    
    
    private func randomValue() -> String {
        
        var randomNums = "3" // 3 for "iOS"
        for _ in 1...18 {
            let n = Int.random(in: 0...9)
            randomNums += String(n)
        }
        
        return randomNums
    }
    
}
