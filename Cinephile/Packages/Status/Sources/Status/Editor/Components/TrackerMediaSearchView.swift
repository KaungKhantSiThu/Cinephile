//
//  TrackerMediaSearchView.swift
//
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import SwiftUI
import TrackerUI
import TMDb

extension StatusEditor {
    @MainActor
    struct TrackerMediaSearchView: View {
        @State private var model = TrackerExploreViewModel()
        let action: (Media) -> Void
        
        init(action: @escaping (Media) -> Void) {
            self.action = action
        }
        
        var body: some View {
            NavigationStack {
                List {
                    if !model.isSearchPresented {
                        switch model.state {
                        case .idle:
                            Color.clear.onAppear {
                                model.fetchTrending()
                            }
                        case .loading:
                            ProgressView()
                        case .failed(let error):
                            ContentUnavailableView("Fetching data failed", systemImage: "magnifyingglass", description: Text("Error: \(error.localizedDescription)"))
                                .symbolVariant(.slash)
                        case .loaded(let value):
                            Section {
                                ScrollView {
                                    VStack {
                                        ForEach(value.popularMovies) { movie in
                                            MediaRow(movie: movie) {
                                                print("")
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            } header: {
                                Text("Trending Movies")
                                    .font(.title).bold()
                            }
                            
                            Section {
                                ScrollView {
                                    VStack {
                                        ForEach(value.popularTVSeries) { series in
                                            MediaRow(tvSeries: series) {
                                                print("")
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            } header: {
                                Text("Trending TV Series")
                                    .font(.title).bold()
                            }
                            
                            
                        }
                    }
                    
                    if !model.searchText.isEmpty {
                        searchResultsView
                    }
                }
                .listStyle(.plain)
                .searchable(text: $model.searchText,
                            isPresented: $model.isSearchPresented,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: Text("Search Movies, Series, Cast"))
                .searchScopes($model.searchScope) {
                    ForEach(TrackerExploreViewModel.SearchScope.allCases, id: \.self) { scope in
                        Text(scope.localizedString, bundle: .module)
                    }
                }
                .task(id: model.searchText) {
                    do {
                        try await Task.sleep(for: .milliseconds(150))
                        try await model.search()
                    } catch {
                        print("Search Failed")
                    }
                }
                .task(id: model.searchScope) {
                    print("changed")
                    do {
                        try await Task.sleep(for: .milliseconds(150))
                        try await model.search()
                    } catch {
                        print("Search Failed")
                    }
                }
            }
        }
        
        private var searchResultsView: some View {
            ForEach(model.medias) {
                media in
                switch media {
                case .movie(let movie):
                    MediaRow(movie: movie) {
                        self.action(Media.movie(movie))
                    }
                case .tvSeries(let series):
                    MediaRow(tvSeries: series) {
                        self.action(Media.tvSeries(series))
                    }
                case .person(_):
                    EmptyView()
                }
            }
        }
    }
}
