//
//  Json_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/09/2022.
//

import Foundation


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

// The json from the server is an array (starts with "[]"), BUT the json parser needs a main node ("{}")
func ADD_MAIN_NODE(to jsonData: Data?, name: String = "data") -> Data {
    var str = String(decoding: jsonData!, as: UTF8.self)
    str = str.replacingOccurrences(of: "\n", with: "")
    str  = "{\"\(name)\":" + str + "}"

    return Data(str.utf8)
}
