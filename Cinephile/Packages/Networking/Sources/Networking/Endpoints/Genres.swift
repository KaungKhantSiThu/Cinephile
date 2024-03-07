//
//  Genres.swift
//
//
//  Created by Kaung Khant Si Thu on 02/03/2024.
//

import Foundation

public enum Genres: Endpoint {
  case genre(id: Int)
  case follow(id: Int)
  case unfollow(id: Int)
    case followedGenres

  public func path() -> String {
    switch self {
    case let .genre(id):
      "cinephile/genres/\(id)/"
    case let .follow(id):
      "cinephile/genres/\(id)/follow"
    case let .unfollow(id):
      "cinephile/genres/\(id)/unfollow"
    case .followedGenres:
        "cinephile/followed_genres"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    default:
      nil
    }
  }
}
