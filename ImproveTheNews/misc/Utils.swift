//
//  Utils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation
import UIKit


func WRITE(_ key: String, value: Any) {
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func READ(_ key: String) -> String? {
    if let _value = UserDefaults.standard.string(forKey: key) {
        return _value
    } else {
        return nil
    }
}

func API_BASE_URL() -> String {
    let dict = Bundle.main.infoDictionary!
    return dict["API_BASE_URL"] as! String
}

func JSON(fromData data: Data?) -> [String: Any]? {
    if let _data = data {
        do{
            let json = try JSONSerialization.jsonObject(with: _data,
                            options: []) as? [String : Any]
            return json
        }catch {
            return nil
        }
    } else {
        return nil
    }
}

func APP_DELEGATE() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
