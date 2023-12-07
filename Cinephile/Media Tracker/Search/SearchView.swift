////
////  SearchView.swift
////  TMDB Test
////
////  Created by Kaung Khant Si Thu on 31/10/2023.
////
//
import SwiftUI
import TMDb

@MainActor
struct SearchView: View {
    @State var model = SearchViewModel()
    var body: some View {
        ScrollViewReader { proxy in
            List {
                if !model.isSearchPresented {
                    switch model.state {
                    case .idle:
                        Color.clear.task {
                            await model.fetchTrending()
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
                                    ForEach(value.trendingMovies.prefix(5)) { movie in
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
                            Text("Popular Movie")
                                .font(.title).bold()
                        }
                        
                        Section {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(value.trendingSeries.prefix(5)) { series in
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
                            Text("Popular TV Series")
                                .font(.title).bold()
                        }
                        
                        
                    }
                }
                
                if !model.searchText.isEmpty {
                    searchResultsView
                }
            }
            .listStyle(.plain)
            .task {
                await model.fetchTrending()
            }
            .refreshable {
                await model.fetchTrending()
            }
            .searchable(text: $model.searchText,
                        isPresented: $model.isSearchPresented,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: Text("Search Movies, Series, Cast"))
            .task(id: model.searchText) {
                do {
                    try await Task.sleep(for: .milliseconds(150))
                    await model.search()
                } catch {
                    print("Search Failed")
                }
            }
            .navigationTitle("Explore")
            
        }
        
    }
    
    private var searchResultsView: some View {
        ForEach(model.medias) {
            media in
            switch media {
            case .movie(let movie):
                NavigationLink(value: RouterDestination.movieDetail(id: movie.id)) {
                    MediaRow(movie: movie)
                }
            case .tvSeries(let series):
                NavigationLink(value: RouterDestination.seriesDetail(id: series.id)) {
                    MediaRow(tvSeries: series)
                }
            case .person(let person):
                MediaRow(person: person)
            }
        }
    }
}
    

#Preview {
    NavigationStack {
        SearchView()
    }
}
