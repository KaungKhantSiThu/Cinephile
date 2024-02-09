//
//  Watchlist.swift
//
//
//  Created by Kaung Khant Si Thu on 09/02/2024.
//

import Foundation

public struct Watchlist: Identifiable, Codable, Equatable, Hashable {
    
    public let id: Int
    
    public let watchStatus: WatchStatus
    
    public let entertainment: Entertainment
    
}
