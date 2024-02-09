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
        case loading, display(watchlists: [Watchlist]), error(error: Error)
    }

    var state: State = .loading

    func fetch() async {
        guard let client else { return }
        do {
            let watchlists: [Watchlist] = try await client.get(endpoint: Watchlists.getAll)
            print(watchlists)
            state = .display(watchlists: watchlists)
        } catch {
            if let error = error as? ServerError, error.httpCode == 404 {
                print(error)
            } else {
              state = .error(error: error)
            }
        }

    }
}
