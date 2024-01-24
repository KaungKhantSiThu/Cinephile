//
//  ShowWatchProviderResult.swift
//
//
//  Created by Mikko Kuivanen on 5.9.2023.
//

import Foundation

public struct ShowWatchProviderResult: Equatable, Decodable {
    public let id: Int
    public let results: [String: ShowWatchProvider]
}

public struct ShowWatchProvider: Equatable, Decodable {
    public let link: String
    public let free: [WatchProvider]?
    public let flatrate: [WatchProvider]?
    public let buy: [WatchProvider]?
    public let rent: [WatchProvider]?
}
