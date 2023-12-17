//
//  Instances.swift
//  
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Foundation

public enum Instances: Endpoint {
  case instance
  case peers

  public func path() -> String {
    switch self {
    case .instance:
      "instance"
    case .peers:
      "instance/peers"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    nil
  }
}
