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

  public func path() -> String {
    switch self {
    case let .genre(id):
      "tags/\(id)/"
    case let .follow(id):
      "tags/\(id)/follow"
    case let .unfollow(id):
      "tags/\(id)/unfollow"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    default:
      nil
    }
  }
}
