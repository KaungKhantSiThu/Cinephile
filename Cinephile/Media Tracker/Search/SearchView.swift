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
                    if !model.isLoaded {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        
                    } else if !model.searchText.isEmpty {
                        searchResultsView
                    } else {
                        popularMoviesView
                        popularTVSeriesView
                    }
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
    
    private var popularMoviesView: some View {
        Section {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(model.trendingMovies.prefix(5)) { movie in
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
    }
    
    private var popularTVSeriesView: some View {
        Section {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(model.trendingSeries.prefix(5)) { series in
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

#Preview {
    NavigationStack {
        SearchView()
    }
}
