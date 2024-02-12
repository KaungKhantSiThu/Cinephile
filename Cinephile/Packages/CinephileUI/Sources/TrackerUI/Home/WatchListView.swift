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
import Environment

struct WatchListView: View {
    @State private var viewModel = WatchListViewModel()
    @Environment(Client.self) private var client
    let columns: [GridItem] = [GridItem(.fixed(100), spacing: 16),
                               GridItem(.fixed(100), spacing: 16),
                               GridItem(.fixed(100), spacing: 16)]
    var body: some View {
        VStack(alignment: .center) {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .display:
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, alignment: .center) {
//                        ForEach(watchlists) { watchlist in
//                            MovieCover(id: Int(watchlist.entertainment.mediaId)!)
////                                .frame(width: 100)
//                        }
                        
                        Section(header: Text("Not Watch").font(.title)) {
                            ForEach(viewModel.notWatch) { watchlist in
                                MovieCover(id: Int(watchlist.entertainment.mediaId)!)
//                                    .frame(width: 100)
                            }
                        }

                        Section(header: Text("Watched").font(.title)) {
                            ForEach(viewModel.watched) { watchlist in
                                MovieCover(id: Int(watchlist.entertainment.mediaId)!)
//                                    .frame(width: 100)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
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
