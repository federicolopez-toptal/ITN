//
//  IntExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import Foundation

extension Int {
    
     func clamp(lower: Int, upper: Int) -> Int {
        var result = self
        if(result<lower){ result = lower }
        if(result>upper){ result = upper }
        
        return result
    }
    
}
