//
//  StringExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import Foundation

extension String {

    func swapCharacters(index1: Int, index2: Int) -> String {
        var characters = Array(self)
        characters.swapAt(index1, index2)
        
        return String(characters)
    }

}
