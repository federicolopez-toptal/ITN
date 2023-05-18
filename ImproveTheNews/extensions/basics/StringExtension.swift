//
//  StringExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import Foundation
import UIKit


extension String {

//    func swapCharacters(index1: Int, index2: Int) -> String {
//        var characters = Array(self)
//        characters.swapAt(index1, index2)
//        
//        return String(characters)
//    }
    
//    subscript(offset: Int) -> Character {
//        self[index(startIndex, offsetBy: offset)]
//    }

    func getCharAt(index i: Int) -> String? {
        if(i<0 || i>=self.count){ return nil }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    func subString(from: Int, count: Int) -> String? {
        if(from<0 || from>=self.count){ return nil }
        if(from+count-1<0 || from+count-1>=self.count){ return nil }
        
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: count)
        let range = start...end
        
        return String(self[range])
    }
    
    func getHeight(font: UIFont, width: CGFloat) -> CGFloat {
      let attributes: [NSAttributedString.Key: Any] = [ .font: font ]
      let attributedText = NSAttributedString(string: self, attributes: attributes)
      let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
      
      let textHeight = attributedText.boundingRect(
        with: constraintBox, options: [.usesLineFragmentOrigin,
        .usesFontLeading], context: nil)
        .height.rounded(.up)
        
      return textHeight
    }
    
    func urlEncodedString(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    var queryStringParameters: Dictionary<String, String> {
        var parameters = Dictionary<String, String>()

        let scanner = Scanner(string: self)

        var key: String?
        var value: String?

        while !scanner.isAtEnd {
            key = scanner.scanUpToString("=")
            _ = scanner.scanString(string: "=")

            value = scanner.scanUpToString("&")
            _ = scanner.scanString(string: "&")

            if let key = key, let value = value {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        return parameters
    }

}
