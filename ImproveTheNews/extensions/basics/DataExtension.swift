//
//  DataExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 17/05/2023.
//

import Foundation

extension Data {
    
    var rawBytes: [UInt8] {
        return [UInt8](self)
    }
    
    init(bytes: [UInt8]) {
        self.init(bytes)
    }
    
}
