//
//  AccountsEndpoint.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation
import Models

public enum Accounts: Endpoint {
  case createAccount(json: AccountData)
  case accounts(id: String)
  case lookup(name: String)
  case favorites(sinceId: String?)
  case bookmarks(sinceId: String?)
  case followedTags
  case featuredTags(id: String)
  case verifyCredentials
    case updateCredentialsMedia
  case updateCredentials(json: UpdateCredentialsData)
  case statuses(id: String,
                sinceId: String?,
                tag: String?,
                onlyMedia: Bool?,
                excludeReplies: Bool?,
                pinned: Bool?)
  case relationships(ids: [String])
  case follow(id: String, notify: Bool, reblogs: Bool)
  case unfollow(id: String)
  case familiarFollowers(withAccount: String)
  case suggestions
  case followers(id: String, maxId: String?)
  case following(id: String, maxId: String?)
  case lists(id: String)
  case preferences
  case block(id: String)
  case unblock(id: String)
  case mute(id: String, json: MuteData)
  case unmute(id: String)
  case relationshipNote(id: String, json: RelationshipNoteData)

  public func path() -> String {
    switch self {
    case .createAccount:
        "accounts"
    case let .accounts(id):
      "accounts/\(id)"
    case .lookup:
      "accounts/lookup"
    case .favorites:
      "favourites"
    case .bookmarks:
      "bookmarks"
    case .followedTags:
      "followed_tags"
    case let .featuredTags(id):
      "accounts/\(id)/featured_tags"
    case .verifyCredentials:
      "accounts/verify_credentials"
    case .updateCredentials, .updateCredentialsMedia:
      "accounts/update_credentials"
    case let .statuses(id, _, _, _, _, _):
      "accounts/\(id)/statuses"
    case .relationships:
      "accounts/relationships"
    case let .follow(id, _, _):
      "accounts/\(id)/follow"
    case let .unfollow(id):
      "accounts/\(id)/unfollow"
    case .familiarFollowers:
      "accounts/familiar_followers"
    case .suggestions:
      "suggestions"
    case let .following(id, _):
      "accounts/\(id)/following"
    case let .followers(id, _):
      "accounts/\(id)/followers"
    case let .lists(id):
      "accounts/\(id)/lists"
    case .preferences:
      "preferences"
    case let .block(id):
      "accounts/\(id)/block"
    case let .unblock(id):
      "accounts/\(id)/unblock"
    case let .mute(id, _):
      "accounts/\(id)/mute"
    case let .unmute(id):
      "accounts/\(id)/unmute"
    case let .relationshipNote(id, _):
      "accounts/\(id)/note"
    }
  }

  public func queryItems() -> [URLQueryItem]? {
    switch self {
    case let .lookup(name):
      return [
        .init(name: "acct", value: name),
      ]
    case let .statuses(_, sinceId, tag, onlyMedia, excludeReplies, pinned):
      var params: [URLQueryItem] = []
      if let tag {
        params.append(.init(name: "tagged", value: tag))
      }
      if let sinceId {
        params.append(.init(name: "max_id", value: sinceId))
      }
      if let onlyMedia {
        params.append(.init(name: "only_media", value: onlyMedia ? "true" : "false"))
      }
      if let excludeReplies {
        params.append(.init(name: "exclude_replies", value: excludeReplies ? "true" : "false"))
      }
      if let pinned {
        params.append(.init(name: "pinned", value: pinned ? "true" : "false"))
      }
      return params
    case let .relationships(ids):
      return ids.map {
        URLQueryItem(name: "id[]", value: $0)
      }
    case let .follow(_, notify, reblogs):
      return [
        .init(name: "notify", value: notify ? "true" : "false"),
        .init(name: "reblogs", value: reblogs ? "true" : "false"),
      ]
    case let .familiarFollowers(withAccount):
      return [.init(name: "id[]", value: withAccount)]
    case let .followers(_, maxId):
      return makePaginationParam(sinceId: nil, maxId: maxId, minId: nil)
    case let .following(_, maxId):
      return makePaginationParam(sinceId: nil, maxId: maxId, minId: nil)
    case let .favorites(sinceId):
      guard let sinceId else { return nil }
      return [.init(name: "max_id", value: sinceId)]
    case let .bookmarks(sinceId):
      guard let sinceId else { return nil }
      return [.init(name: "max_id", value: sinceId)]
    default:
      return nil
    }
  }

  public var jsonValue: Encodable? {
    switch self {
    case let .mute(_, json):
      json
    case let .relationshipNote(_, json):
      json
    case let .updateCredentials(json):
      json
    default:
      nil
    }
  }
}

public struct AccountData : Codable, Sendable {
    var username : String
    var email : String
    var password : String
    var agreement : Bool
    var reason : String
    var locale : String
    
    public init(username: String, email: String, password: String, agreement: Bool = true, reason: String = "test", locale: String = "en") {
        self.username = username
        self.email = email
        self.password = password
        self.agreement = agreement
        self.reason = reason
        self.locale = locale
    }
}

public struct MuteData: Encodable, Sendable {
  public let duration: Int

  public init(duration: Int) {
    self.duration = duration
  }
}

public struct RelationshipNoteData: Encodable, Sendable {
  public let comment: String

  public init(note comment: String) {
    self.comment = comment
  }
}

public struct UpdateCredentialsData: Encodable, Sendable {
  public struct SourceData: Encodable, Sendable {
    public let privacy: Visibility
    public let sensitive: Bool

    public init(privacy: Visibility, sensitive: Bool) {
      self.privacy = privacy
      self.sensitive = sensitive
    }
  }

  public struct FieldData: Encodable, Sendable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
      self.name = name
      self.value = value
    }
  }

  public let displayName: String
  public let note: String
  public let source: SourceData
  public let bot: Bool
  public let locked: Bool
  public let discoverable: Bool
  public let fieldsAttributes: [String: FieldData]

  public init(displayName: String,
              note: String,
              source: UpdateCredentialsData.SourceData,
              bot: Bool,
              locked: Bool,
              discoverable: Bool,
              fieldsAttributes: [FieldData])
  {
    self.displayName = displayName
    self.note = note
    self.source = source
    self.bot = bot
    self.locked = locked
    self.discoverable = discoverable

    var fieldAttributes: [String: FieldData] = [:]
    for (index, field) in fieldsAttributes.enumerated() {
      fieldAttributes[String(index)] = field
    }
    self.fieldsAttributes = fieldAttributes
  }
}

//public enum AccountsEndpoint {
//    case accounts(id: Account.ID)
//    case lookup(account: String)
//    case favorites(maxId: Account.ID? = nil)
//    case bookmarks(maxId: Account.ID? = nil)
//    case followedTags
//    case featuredTags(id: Account.ID)
//    case verifyCredentials
////    case updateCredentials(json: UpdateCredentialsData)
//    case statuses(id: Account.ID,
//                  sinceId: Account.ID?,
//                  tag: String?,
//                  onlyMedia: Bool?,
//                  excludeReplies: Bool?,
//                  pinned: Bool?)
//    case relationships(ids: [Account.ID])
//    case follow(id: Account.ID, notify: Bool, reblogs: Bool)
//    case unfollow(id: Account.ID)
//    case familiarFollowers(withAccount: Account.ID)
//    case suggestions
//    case followers(id: String, maxId: Account.ID?)
//    case following(id: String, maxId: Account.ID?)
//    case lists(id: Account.ID)
//    case preferences
//    case block(id: Account.ID)
//    case unblock(id: Account.ID)
////    case mute(id: String, json: MuteData)
//    case unmute(id: Account.ID)
////    case relationshipNote(id: String, json: RelationshipNoteData)
//}
//
//extension AccountsEndpoint: Endpoint {
//    
//    private static let basePath = URL(string: "/accounts")!
//
//    public var path: URL {
//        switch self {
//        case .accounts(let id):
//            Self.basePath
//                .appendingPathComponent(id)
//                
//        case .lookup(let name):
//            Self.basePath
//                .appendingPathComponent("lookup")
//                .appendingAccountName(name)
//
//        case .favorites(let maxId):
//            URL(string: "/favourites")!
//                .appendingMaxId(maxId)
//                
//        case .bookmarks(let maxId):
//          URL(string: "/bookmarks")!
//                .appendingMaxId(maxId)
//        case .followedTags:
//          URL(string: "/followed_tags")!
//        case let .featuredTags(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("featured_tags")
//        case .verifyCredentials:
//            Self.basePath
//                .appendingPathComponent("verify_credentials")
////        case .updateCredentials:
////          "accounts/update_credentials"
//        case let .statuses(id, _, _, _, _, _):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("statuses")
//        case .relationships:
//            Self.basePath
//                .appendingPathComponent("relationships")
//        case let .follow(id, _, _):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("follow")
////                .appendingNotify(notify)
////                .appendingReblogs(reblogs)
//        case let .unfollow(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("unfollow")
//        case .familiarFollowers:
//            Self.basePath
//                .appendingPathComponent("familiar_followers")
//        case .suggestions:
//          URL(string: "suggestions")!
//        case let .following(id, maxId):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("following")
//                .appendingMaxId(maxId)
//        case let .followers(id, maxId):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("followers")
//                .appendingMaxId(maxId)
//        case let .lists(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("lists")
//        case .preferences:
//            URL(string: "preferences")!
//        case let .block(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("block")
//        case let .unblock(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("unblock")
////        case let .mute(id, _):
////          "accounts/\(id)/mute"
//        case let .unmute(id):
//            Self.basePath
//                .appendingPathComponent(id)
//                .appendingPathComponent("unmute")
////        case let .relationshipNote(id, _):
////          "accounts/\(id)/note"
//        }
//    }
//    
//    
//}


