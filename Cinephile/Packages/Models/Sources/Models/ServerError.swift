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


public struct RegistrationError: Decodable, Error {
  public let error: String

    init(error: String) {
        self.error = error
    }
}

extension RegistrationError: Sendable {}
