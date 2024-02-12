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
import CinephileUI

struct WatchListView: View {
    @State private var viewModel = WatchListViewModel()
    @Environment(Client.self) private var client
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 16)]
    @State private var selectedTab: WatchStatus = .unwatched
    var body: some View {
        VStack(alignment: .center) {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .display:
                TabbedScrollView(currentTab: selectedTab) {
                    EmptyView()
                } picker: {
                    Picker("Tab", selection: $selectedTab) {
                        ForEach(WatchStatus.allCases) { tab in
                            Image(systemName: tab.imageName)
                        }
                    }
                    .padding()
                    .background(.background)
                    .pickerStyle(.segmented)
                } contents: {
                    LazyVGrid(columns: columns) {
//                        ForEach(watchlists) { watchlist in
//                            MovieCover(id: Int(watchlist.entertainment.mediaId)!)
////                                .frame(width: 100)
//                        }
                        ForEach(selectedTab == .unwatched ? viewModel.notWatch : viewModel.watched) { watchlist in
                            MovieCover(id: Int(watchlist.entertainment.mediaId)!)
//                                    .frame(width: 100)
                        }
//                        Section(header: Text("Not Watch").font(.title)) {
//                            ForEach(viewModel.notWatch) { watchlist in
//                                MovieCover(id: Int(watchlist.entertainment.mediaId)!)
////                                    .frame(width: 100)
//                            }
//                        }
//
//                        Section(header: Text("Watched").font(.title)) {
//                            ForEach(viewModel.watched) { watchlist in
//                                MovieCover(id: Int(watchlist.entertainment.mediaId)!)
////                                    .frame(width: 100)
//                            }
//                        }
                    }
                }

//                ScrollView(.vertical) {
//
//                }
//                .scrollIndicators(.hidden)
                
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
