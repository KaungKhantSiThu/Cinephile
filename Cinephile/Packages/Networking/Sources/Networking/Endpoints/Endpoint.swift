//
//  Endpoint.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

//import Foundation
//
//public protocol Endpoint {
//    var path: URL { get }
//}

import Foundation

public protocol Endpoint: Sendable {
  func path() -> String
  func queryItems() -> [URLQueryItem]?
  var jsonValue: Encodable? { get }
}

public extension Endpoint {
  var jsonValue: Encodable? {
    nil
  }
}

extension Endpoint {
  func makePaginationParam(sinceId: String?, maxId: String?, minId: String?) -> [URLQueryItem]? {
    if let sinceId {
      return [.init(name: "since_id", value: sinceId)]
    } else if let maxId {
      return [.init(name: "max_id", value: maxId)]
    } else if let minId {
      return [.init(name: "min_id", value: minId)]
    }
    return nil
  }
}
