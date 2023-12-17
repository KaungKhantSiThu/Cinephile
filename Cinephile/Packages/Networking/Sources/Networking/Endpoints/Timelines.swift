import Foundation

public enum Timelines: Endpoint {
  case pub(sinceId: String?, maxId: String?, minId: String?, local: Bool)
  case home(sinceId: String?, maxId: String?, minId: String?)

  public func path() -> String {
    switch self {
    case .pub:
      "timelines/public"
    case .home:
      "timelines/home"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    case let .pub(sinceId, maxId, minId, local):
      var params = makePaginationParam(sinceId: sinceId, maxId: maxId, mindId: minId) ?? []
      params.append(.init(name: "local", value: local ? "true" : "false"))
      return params
    case let .home(sinceId, maxId, mindId):
      return makePaginationParam(sinceId: sinceId, maxId: maxId, mindId: mindId)
    }
  }
}

