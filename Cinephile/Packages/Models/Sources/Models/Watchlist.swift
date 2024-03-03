import Foundation

public struct Watchlist: Identifiable, Codable, Equatable, Hashable {

    public let id: Int
    
    public var watchStatus: WatchStatus
    
    public let entertainment: Entertainment
    
    public let createdAt: ServerDate
    
}


public struct WatchStatusWrapper: Encodable, Sendable {
    public let watchStatus: WatchStatus
    
    public init(watchStatus: WatchStatus) {
        self.watchStatus = watchStatus
    }
}
