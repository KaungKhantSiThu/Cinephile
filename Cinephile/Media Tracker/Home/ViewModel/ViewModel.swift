//
//  Model.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import Foundation
import Combine
import TMDb

protocol DataLoader {
    associatedtype Output
    func loadItem(withID id: Int) async throws -> Output
    func loadTrendingItems() async throws -> [Output]
}

struct MovieLoader: DataLoader {
    
    
    private let tmdbConfiguration = TMDbConfiguration(apiKey: TMDB_API_Key)
    var movieService: MovieService!
    var trendingService: TrendingService!

    
//    let configuration = APIConfiguration.init(images: ImagesConfiguration(
//        baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
//        secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
//        backdropSizes: ["w300", "w780", "w1280", "original"],
//        logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
//        posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
//        profileSizes: ["w45", "w185", "h632", "original"],
//        stillSizes: ["w92", "w185", "w300", "original"]), changeKeys: ["genres", "budget"])
    
    init() {
        TMDb.configure(tmdbConfiguration)
        movieService = MovieService()
        trendingService = TrendingService()
    }
    
    
    
    func loadItem(withID id: Movie.ID) async throws -> Movie {
        return try await movieService.details(forMovie: id)
    }
    
    func loadTrendingItems() async throws -> [Movie] {
        return try await trendingService.movies(inTimeWindow: .week, page: 1).results
    }
    
    func loadCastMembers(withID id: Movie.ID) async throws -> ShowCredits {
        return try await movieService.credits(forMovie: id)
    }
}



class ViewModel<Loader: DataLoader>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<[Loader.Output]> = .idle
    
    private let loader: Loader
    
    init(loader: Loader) {
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let items = try await loader.loadTrendingItems()
                print(items.first ?? "No value in the array")
                self.state = .loaded(items)
            } catch {
                self.state = .failed(error)
            }
        }
    }
}



//class MovieViewModel: ObservableObject {
//
//    
//    @Published var casts: [CastMember] = []
//    
//    private let loader: MovieLoader
//    
//    init(loader: MovieLoader) {
//        
//        self.loader = loader
//    }
//    
//    func load(withID id: Movie.ID) {
//        Task {
//            do {
//                let movie = try await loader.loadMovie(withID: id)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func loadCastMembers(withID id: Movie.ID) {
//        Task {
//            do {
//                self.casts = try await loader.loadCastMembers(withID: id).cast
//            } catch {
//                print("Failed to fetch cast member")
//            }
//        }
//    }
//}


