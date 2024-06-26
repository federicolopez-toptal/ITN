//
//  MetricUtils.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 10/09/2022.
//

import Foundation
import UIKit


func Y_TOP_NOTCH_FIX(_ value: CGFloat) -> CGFloat {
        // Notch devices, safe area bottom = 48
        // older devices, safe are bottom = 20
        if(SAFE_AREA()!.top == 20) {
            return value - 28
        }
        return value
    }

func SAFE_AREA() -> UIEdgeInsets? {
    let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    return window?.safeAreaInsets
}

func SCREEN_SIZE() -> CGSize {
    let result = UIScreen.main.bounds.size
    return result
}
