//
//  Model.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import Foundation
import Combine
import TMDb

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


class MovieViewModel: ObservableObject {

    
    @Published var casts: [CastMember] = []
    
    private let loader: MovieLoader
    
    init(loader: MovieLoader) {
        
        self.loader = loader
    }
    
    func load(withID id: Movie.ID) {
        Task {
            do {
                _ = try await loader.loadItem(withID: id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadCastMembers(withID id: Movie.ID) {
        Task {
            do {
                self.casts = try await loader.loadCastMembers(withID: id)
            } catch {
                print("Failed to fetch cast member")
            }
        }
    }
}


