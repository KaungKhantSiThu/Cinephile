import Foundation

public struct Watchlist: Identifiable, Codable, Equatable, Hashable {

    public let id: Int
    
    public let watchStatus: WatchStatus
    
    public let entertainment: Entertainment
    
}


