//
//  WatchStatus.swift
//
//
//  Created by Kaung Khant Si Thu on 09/02/2024.
//

import Foundation

public enum WatchStatus: String, Codable, Identifiable, Equatable, Hashable, CaseIterable, Sendable {
    case unwatched
    case watched
    
    public var id: Self { self }
    
    public var imageName: String {
        switch self {
        case .unwatched:
            return "eye.slash"
        case .watched:
            return "eye"
        }
    }
    public static func == (lhs: WatchStatus, rhs: WatchStatus) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
}


