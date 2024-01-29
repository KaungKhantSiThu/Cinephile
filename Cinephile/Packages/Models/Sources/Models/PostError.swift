//
//  PostError.swift
//
//
//  Created by Kaung Khant Si Thu on 29/01/2024.
//

import Foundation

public enum PostError: Error {
    // Throw when any attached media is missing media description (alt text)
    case missingAltText
}

extension PostError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missingAltText:
            return NSLocalizedString("status.error.no-alt-text", comment: "media does not have media description")
        }
    }
}

