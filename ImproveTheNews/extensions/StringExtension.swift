//
//  StringExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import Foundation

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

}
