//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 22/01/2024.
//

import Foundation
import Models

public enum StatusEntertainment: Endpoint {

    case get
    case post(json: StatusEntertainmentData)
    case update(id: Int)
    
    public func path() -> String {
        switch self {
        case .get:
            "cinphile/statuses_entertainments"
        case .post:
            "cinphile/statuses_entertainments"
        case let .update(id):
            "cinphile/statuses_entertainments/\(id)"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default: return nil
        }
    }
    
    public var jsonValue: Encodable? {
        switch self {
        case .post(let json):
            json
        
        default: nil
        }
    }
}

public struct StatusEntertainmentData: Encodable, Sendable {
    public let statusId: Int
    public let  entertainmentId: Int
    
    public init(statusId: Int, entertainmentId: Int) {
        self.statusId = statusId
        self.entertainmentId = entertainmentId
    }
}
