//
//  Utils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation
import UIKit


func WRITE(_ key: String, value: Any) {
//    print("WRITING", key, value)
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func READ(_ key: String) -> String? {
    if let _value = UserDefaults.standard.string(forKey: key) {
//        print("READING", key, _value)
        return _value
    } else {
//        print("READING", key, "nil")
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

func SAFE_AREA() -> UIEdgeInsets? {
    let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    return window?.safeAreaInsets
}

func DELAY(_ time: TimeInterval, callback: @escaping () ->() ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
        callback()
    })
}
