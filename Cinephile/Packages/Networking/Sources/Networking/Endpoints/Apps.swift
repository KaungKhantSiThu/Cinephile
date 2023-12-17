//
//  Apps.swift
//
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Foundation
import Models

public enum Apps: Endpoint {
  case registerApp

  public func path() -> String {
    switch self {
    case .registerApp:
      "apps"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    case .registerApp:
      return [
        .init(name: "client_name", value: AppInfo.clientName),
        .init(name: "redirect_uris", value: AppInfo.scheme),
        .init(name: "scopes", value: AppInfo.scopes),
        .init(name: "website", value: AppInfo.weblink),
      ]
    }
  }
}
