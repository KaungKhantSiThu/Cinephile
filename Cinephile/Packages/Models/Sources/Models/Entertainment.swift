//
//  Entertainment.swift
//
//
//  Created by Kaung Khant Si Thu on 20/01/2024.
//

import Foundation

public struct Entertainment: Codable, Identifiable, Hashable, Equatable, Sendable {
    
    public var id: Int
    public let domain: String
    public let mediaType: MediaType
    public let mediaId: String
    public let watchStatus: Bool
}
