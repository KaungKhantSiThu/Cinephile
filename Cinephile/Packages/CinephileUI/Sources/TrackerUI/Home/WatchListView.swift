//
//  WatchListView.swift
//
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import SwiftUI
import Models
import Networking
import MediaClient

struct WatchListView: View {
    @State private var viewModel = WatchListViewModel()
    @Environment(Client.self) private var client
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .display(let watchlists):
                ForEach(watchlists) { watchlist in
                    Text(watchlist.watchStatus.rawValue)
                }
            case .error(let error):
                ErrorView(error: error) {
                    Task {
                        await viewModel.fetch()
                    }
                    
                }
            }
        }
        .onAppear {
            viewModel.client = client
            Task {
                await viewModel.fetch()
            }
            
        }
    }
}

//#Preview {
//    WatchListView()
//
//}
