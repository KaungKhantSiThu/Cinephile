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
            case .notLogin:
                ContentUnavailableView("You are not loggined", systemImage: "exclamationmark.triangle", description: Text("Please log in to use this feature or tap \(Image(systemName: "magnifyingglass.circle.fill")) to explore the movies"))
                    .symbolRenderingMode(.hierarchical)
                    .symbolVariant(.fill)
            case .loading:
                ProgressView()
            case .display:
                TabbedScrollView(currentTab: selectedTab) {
                    EmptyView()
                } picker: {
                    Picker("Tab", selection: $selectedTab) {
                        ForEach(WatchStatus.allCases) { tab in
                            Label(tab.name, systemImage: tab.imageName)
                        }
                    }
                    .padding()
                    .background(.background)
                    .pickerStyle(.segmented)
                } contents: {
                    if viewModel.notWatch.isEmpty && selectedTab == .unwatched  {
                        ContentUnavailableView("Watchlist is Empty", systemImage: "eye", description: Text("You can add movies to watchlist by tapping \(Image(systemName: "magnifyingglass.circle.fill"))."))
                            .symbolRenderingMode(.hierarchical)
                            .symbolVariant(.slash)
                    } else if viewModel.watched.isEmpty && selectedTab == .watched {
                        ContentUnavailableView("Watched is Empty", systemImage: "eye", description: Text("You can mark movies as watched by tapping \(Image(systemName: "eye")) inside Movie Detail Screen."))
                    } else {
                        LazyVGrid(columns: columns) {
                            ForEach(selectedTab == .unwatched ? viewModel.notWatch : viewModel.watched) { watchlist in
                                if let id = Int(watchlist.entertainment.mediaId) {
                                    NavigationLink(value: RouterDestination.movieDetail(id: id)) {
                                        MovieCover(id: id)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
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
