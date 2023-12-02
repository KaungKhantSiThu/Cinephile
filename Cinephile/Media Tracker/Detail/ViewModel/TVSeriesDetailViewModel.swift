//
//  TVSeriesDetailViewModel.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 02/12/2023.
//

import SwiftUI
import TMDb

class TVSeriesDetailViewModel<Loader: DataLoader>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<TVSeries> = .idle
    
    @Published var castMembers: [CastMember] = []
    @Published var videos: [VideoMetadata] = []
    @Published var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    
    let id: TVSeries.ID

    private let loader: TVSeriesLoader
    
    init(id: TVSeries.ID, loader: TVSeriesLoader = TVSeriesLoader()) {
        self.id = id
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let tvSeries = try await loader.loadItem(withID: id)
                self.castMembers = try await loader.loadCastMembers(withID: id)
                self.videos = try await loader.loadVideos(withID: id)
                self.state = .loaded(tvSeries)
                self.posterImageURL = try await ImageLoader.generate(from: tvSeries.posterPath, width: 200)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
