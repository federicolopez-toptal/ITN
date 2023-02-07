//
//  Data_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/02/2023.
//

import Foundation

func MUST_SPLIT() -> Int {
    if let _value = READ(LocalKeys.sliders.split) {
        return Int(_value)!
    } else {
        return 0
    }
}
