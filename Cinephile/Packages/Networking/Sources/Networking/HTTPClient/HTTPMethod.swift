//
//  HTTPMethod.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation

public enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

extension String {
    static let post = HTTPMethod.post.rawValue
    static let get = HTTPMethod.get.rawValue
    static let patch = HTTPMethod.patch.rawValue
    static let put = HTTPMethod.put.rawValue
    static let delete = HTTPMethod.delete.rawValue
}
