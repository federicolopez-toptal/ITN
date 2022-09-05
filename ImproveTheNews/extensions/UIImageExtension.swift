//
//  UIImageExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation
import UIKit

extension UIImage {
    
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
