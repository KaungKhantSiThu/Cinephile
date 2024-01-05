//
//  Visibility.swift
//
//
//  Created by Kaung Khant Si Thu on 11/12/2023.
//

import Foundation

public enum Visibility: String, Codable, CaseIterable, Hashable, Equatable, Sendable {
  case pub = "public"
  case unlisted
  case priv = "private"
  case direct
    
  public static func == (lhs: Visibility, rhs: Visibility) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
}
