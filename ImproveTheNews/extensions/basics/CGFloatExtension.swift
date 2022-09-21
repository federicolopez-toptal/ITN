//
//  CGFloatExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import Foundation
import UIKit

extension CGFloat {
    
    public func lerp(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + (self * (max - min))
    }
    
    func clamp(lower: CGFloat, upper: CGFloat) -> CGFloat {
        var result = self
        if(result<lower){ result = lower }
        if(result>upper){ result = upper }
        
        return result
    }
    
}
