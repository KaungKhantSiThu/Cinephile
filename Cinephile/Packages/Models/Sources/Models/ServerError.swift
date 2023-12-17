//
//  ServerError.swift
//
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Foundation

public struct ServerError: Decodable, Error {
  public let error: String?
  public var httpCode: Int?
}

extension ServerError: Sendable {}
