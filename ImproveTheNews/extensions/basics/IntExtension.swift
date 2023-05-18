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
    
    public func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
    
}

func arrayOfBytes<T>(_ value:T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value
    
    let bytesPointer = valuePointer.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for j in 0..<min(MemoryLayout<T>.size,totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
    }
    
    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()
    
    return bytes
}
