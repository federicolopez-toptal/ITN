//
//  ErrorExtension.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import Foundation

public enum CustomError: Error {
    case jsonParseError
}

extension CustomError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            case .jsonParseError:
                return NSLocalizedString("Error parsing json", comment: "Custom error")
        }
    }
    
}
