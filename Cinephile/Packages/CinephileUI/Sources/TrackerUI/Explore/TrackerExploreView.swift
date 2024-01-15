////
////  SearchView.swift
////  TMDB Test
////
////  Created by Kaung Khant Si Thu on 31/10/2023.
////
//
import SwiftUI
import TMDb
import Environment

@MainActor
public struct TrackerExploreView: View {
    @State private var model = TrackerExploreViewModel()
    
    public init() { }
    
    public var body: some View {
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
                    ContentUnavailableView("No search Results", systemImage: "magnifyingglass", description: Text("Error: \(error.localizedDescription)"))
                        .symbolVariant(.slash)
                case .loaded(let value):
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(value.upcomingMovies) { movie in
                                    NavigationLink(value: RouterDestination.movieDetail(id: movie.id)) {
                                        MediaCover(movie: movie)
                                            .frame(width: 100)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Label("Upcoming Movies", systemImage: "flame")
                            .font(.title)
                            .bold()
                    }
                    
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(value.popularMovies) { movie in
                                    NavigationLink(value: RouterDestination.movieDetail(id: movie.id)) {
                                        MediaCover(movie: movie)
                                            .frame(width: 100)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Label("Popular Movies", systemImage: "flame")
                            .font(.title)
                            .bold()
                    }
                    
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(value.popularTVSeries) { series in
                                    NavigationLink(value: RouterDestination.seriesDetail(id: series.id)) {
                                        MediaCover(tvSeries: series)
                                            .frame(width: 100)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Label("Popular TV Series", systemImage: "flame")
                            .font(.title)
                            .bold()
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
                    prompt: Text("Search Movies, TV Series, People"))
        .searchScopes($model.searchScope) {
            ForEach(TrackerExploreViewModel.SearchScope.allCases, id: \.self) { scope in
                Text(scope.localizedString, bundle: .module)
                    .tag(scope)
            }
        }
        .task(id: model.searchText) {
            do {
                try await Task.sleep(for: .milliseconds(150))
                await model.search()
            } catch {
                print("Search Failed")
            }
        }
        .task(id: model.searchScope) {
            do {
                try await Task.sleep(for: .milliseconds(150))
                await model.search()
            } catch {
                print("Search Failed")
            }
        }
        .navigationTitle("Explore")
    }
    
    private var searchResultsView: some View {
        ForEach(model.medias) {
            media in
            switch media {
            case .movie(let movie):
                NavigationLink(value: RouterDestination.movieDetail(id: movie.id)) {
                    MediaRow(movie: movie) {
                        print("$0.name")
                    }
                }
            case .tvSeries(let series):
                NavigationLink(value: RouterDestination.seriesDetail(id: series.id)) {
                    MediaRow(tvSeries: series) {
                        print("$0.name")
                    }
                }
            case .person(let person):
                MediaRow(person: person) {
                    print("$0.name")
                }
            }
        }
    }
}
    

//#Preview {
//    let tmdbConfiguration = TMDbConfiguration(apiKey: ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? "")
//    TMDb.configure(tmdbConfiguration)
//    return NavigationStack {
//        SearchView()
//    }
//}
