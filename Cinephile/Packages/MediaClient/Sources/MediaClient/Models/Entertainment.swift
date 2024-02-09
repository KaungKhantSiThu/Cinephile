//
//  Entertainment.swift
//
//
//  Created by Kaung Khant Si Thu on 09/02/2024.
//

import Foundation

public struct Entertainment: Codable, Identifiable, Hashable, Equatable, Sendable {
    
    public var id: Int
    public let domain: String
    public let mediaType: MediaType
    public let mediaId: String
    public let watchStatus: Bool
    
    public enum MediaType: String, Codable, CaseIterable, Hashable, Equatable, Sendable {
        case movie
        case tvSeries = "series"
        
        public static func == (lhs: MediaType, rhs: MediaType) -> Bool {
          lhs.rawValue == rhs.rawValue
        }
    }
    
}
