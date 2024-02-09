//
//  WatchStatus.swift
//
//
//  Created by Kaung Khant Si Thu on 09/02/2024.
//

import Foundation

public enum WatchStatus: String, Codable, Equatable, Hashable, CaseIterable, Sendable {
    case unwatched
    case watched
    
    public static func == (lhs: WatchStatus, rhs: WatchStatus) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
}
