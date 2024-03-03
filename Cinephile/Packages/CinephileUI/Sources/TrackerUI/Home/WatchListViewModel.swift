//
//  WatchListViewModel.swift
//
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import Foundation
import SwiftUI
import Networking
import Models

@Observable
class WatchListViewModel {
    var client: Client?
    enum State {
        case loading, display(watchlists: [Watchlist]), error(error: Error), notLogin
    }
    
    var state: State = .loading
    
    var notWatch: [Watchlist] {
        if watchlists.isEmpty { return [] }
        return watchlists.filter { watchlist in
            watchlist.watchStatus == .unwatched
        }
    }
    
    var watched: [Watchlist] {
        if watchlists.isEmpty { return [] }
        return watchlists.filter { watchlist in
            watchlist.watchStatus == .watched
        }
    }
    
    private var watchlists: [Watchlist] = []
    
    func fetch() async {
        guard let client else {
            return
        }
        
        guard client.isAuth else {
            state = .notLogin
            return
        }
        
        do {
            let watchlists: [Watchlist] = try await client.get(endpoint: Watchlists.getAll)
            self.watchlists = watchlists.sorted(by: { $0.createdAt.asDate > $1.createdAt.asDate })
            state = .display(watchlists: watchlists)
        } catch {
            if let error = error as? ServerError, error.httpCode == 404 {
                print(error)
            } else {
                state = .error(error: error)
            }
        }
        
    }
    
    func markAsWatched(id: Watchlist.ID) async {
        guard let client else {
            return
        }
        
        guard client.isAuth else {
            state = .notLogin
            return
        }
        
        do {
            let response = try await client.patch(endpoint: Watchlists.patch(id: id, watchStatus: WatchStatusWrapper(watchStatus: .watched)))
            if let statusCode = response?.statusCode {
                if statusCode == 200 {
                    if let index = watchlists.firstIndex(where: { $0.id == id }) {
                        watchlists[index].watchStatus = .watched
                    }
                    print("\(id) is marked as watched")
                } else {
                    print("\(id) : status code \(statusCode)")
                }
            }
        } catch {
            state = .error(error: error)
        }
    }
    
    func markAsUnWatch(id: Watchlist.ID) async {
        guard let client else {
            return
        }
        
        guard client.isAuth else {
            state = .notLogin
            return
        }
        
        do {
            let response = try await client.patch(endpoint: Watchlists.patch(id: id, watchStatus: WatchStatusWrapper(watchStatus: .unwatched)))
            if let statusCode = response?.statusCode {
                if statusCode == 200 {
                    if let index = watchlists.firstIndex(where: { $0.id == id }) {
                        watchlists[index].watchStatus = .unwatched
                    }
                    print("\(id) is marked as unwatch")
                } else {
                    print("\(id) : status code \(statusCode)")
                }
            }
        } catch {
            state = .error(error: error)
        }
    }
    
    func removeFromWatchlist(id: Watchlist.ID) async {
        guard let client else { return }
        
        guard client.isAuth else {
            state = .notLogin
            return
        }
        
        do {
            let response = try await client.delete(endpoint: Watchlists.delete(id: id))
            if let statusCode = response?.statusCode {
                if statusCode == 200 {
                    watchlists.removeAll(where: { $0.id == id })
                    print("\(id) is removed")
                } else {
                    print("\(id) : status code \(statusCode)")
                }
            }
        } catch {
            state = .error(error: error)
        }
    }
}
