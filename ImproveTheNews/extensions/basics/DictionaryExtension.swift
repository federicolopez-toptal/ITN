//
//  DictionaryExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 17/05/2023.
//

import Foundation


extension Dictionary {

    func urlEncodedQueryString(using encoding: String.Encoding) -> String {
        var parts = [String]()

        for (key, value) in self {
            let keyString = "\(key)".urlEncodedString()
            let valueString = "\(value)".urlEncodedString(keyString == "status")
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }

        return parts.joined(separator: "&")
    }

}
