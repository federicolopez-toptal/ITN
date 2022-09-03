//
//  UserID.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation

class UserID {
    
    static let instance = UserID()
    
    private let key_uuid = "SHARE_uuid"
    private let key_jwt = "SHARE_jwt"
    
    func getValue(callback: @escaping (String) -> ()) {
        if let _uuid = READ(self.key_uuid) {
            callback(_uuid)
        } else {
            self.generate { (error, gen_uuid) in
                if let _error = error {
                    callback(self.randomValue())
                } else {
                    if let _uuid = gen_uuid {
                        callback(_uuid)
                    } else {
                        callback(self.randomValue())
                    }
                }
            }
        }
    }
    
    func generate(callback: @escaping (Error?, String?) -> ()) {
        let url = "https://biaspost.org/api/user/"
        
        let bodyJson: [String: String] = [
            "type": "Generate",
            "userId": self.randomValue(),
            "app": "iOS"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let body = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, resp, error in
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _jwt = _json["jwt"] as? String, let _uuid = _json["uuid"] as? String {
                        WRITE(self.key_uuid, value: _uuid)
                        WRITE(self.key_jwt, value: _jwt)
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
    
    
    func randomValue() -> String {
        
        var randomNums = "3" // 3 for "iOS"
        for _ in 1...18 {
            let n = Int.random(in: 0...9)
            randomNums += String(n)
        }
        
        return randomNums
    }
    
}
