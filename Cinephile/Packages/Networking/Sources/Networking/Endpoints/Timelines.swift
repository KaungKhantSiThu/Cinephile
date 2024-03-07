import Foundation
import Models
public enum Timelines: Endpoint {
    case pub(sinceId: String?, maxId: String?, minId: String?, local: Bool)
    case home(sinceId: String?, maxId: String?, minId: String?)
    case list(listId: String, sinceId: String?, maxId: String?, minId: String?)
    case hashtag(tag: String, additional: [String]?, maxId: String?)
    case entertainment(genreId: Int?, entertainmentId: Int?, mediaType: MediaType?, sinceId: String?, maxId: String?, minId: String?, onlyMedia: Bool?, withReplies: Bool?, onlyEntertainment: Bool, local: Bool)
    case forYou(sinceId: String?, maxId: String?, minId: String?)
    
    public func path() -> String {
        switch self {
        case .pub:
            "timelines/public"
        case .home:
            "timelines/home"
        case let .list(listId, _, _, _):
            "timelines/list/\(listId)"
        case let .hashtag(tag, _, _):
            "timelines/tag/\(tag)"
        case .entertainment:
            "timelines/cinephile/entertainment"
        case .forYou:
            "timelines/cinephile/for_you"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case let .pub(sinceId, maxId, minId, local):
            var params = makePaginationParam(sinceId: sinceId, maxId: maxId, minId: minId) ?? []
            params.append(.init(name: "local", value: local ? "true" : "false"))
            return params
        case let .home(sinceId, maxId, minId):
            return makePaginationParam(sinceId: sinceId, maxId: maxId, minId: minId)
        case let .list(_, sinceId, maxId, minId):
            return makePaginationParam(sinceId: sinceId, maxId: maxId, minId: minId)
        case let .hashtag(_, additional, maxId):
            var params = makePaginationParam(sinceId: nil, maxId: maxId, minId: nil) ?? []
            params.append(contentsOf: (additional ?? [])
                .map { URLQueryItem(name: "any[]", value: $0) })
            return params
        case let .entertainment(genreId, entertainmentId, mediaType, sinceId, maxId, minId, onlyMedia, withReplies, onlyEntertainment, local):
            var params = makePaginationParam(sinceId: sinceId, maxId: maxId, minId: minId) ?? []
            
            if let genreId {
                params.append(.init(name: "genre_id", value: String(genreId)))
            }
            if let entertainmentId {
                params.append(.init(name: "entertainment_id", value: String(entertainmentId)))
            }
            if let onlyMedia {
                params.append(.init(name: "only_media", value: onlyMedia ? "true" : "false"))
            }
            if let withReplies {
                params.append(.init(name: "with_replies", value: withReplies ? "true" : "false"))
            }
            params.append(.init(name: "only_entertainment", value: onlyEntertainment ? "true" : "false"))
            params.append(.init(name: "local", value: local ? "true" : "false"))
            if let mediaType {
                params.append(.init(name: "media_type", value: mediaType.rawValue))
            }
            return params
        case let .forYou(sinceId, maxId, minId):
            return makePaginationParam(sinceId: sinceId, maxId: maxId, minId: minId)
        }
    }
}


