//
//  TVSeriesDetailViewModel.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 02/12/2023.
//

import SwiftUI
import MediaClient


@Observable class TVSeriesDetailViewModel: ObservableObject, LoadableObject {
    private(set) var state: LoadingState<TVSeriesDetail> = .idle

    private(set) var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    
    let id: TVSeries.ID

    private let loader = TVSeriesLoader()
    
    init(id: TVSeries.ID) {
        self.id = id
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let data = try await fetchTVSeriesDetailData()
                self.posterImageURL = ImageService.shared.posterURL(for: data.tvSeries.posterPath)
                self.state = .loaded(data)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
    private func fetchTVSeriesDetailData() async throws -> TVSeriesDetail {
        async let tvSeries = loader.loadItem(withID: id)
        async let castMembers = loader.loadCastMembers(withID: id)
        async let videos = loader.loadVideos(withID: id)
        
        return try await .init(tvSeries: tvSeries, castMembers: castMembers, videos: videos)
    }
    
}

extension TVSeriesDetailViewModel {
    struct TVSeriesDetail {
        let tvSeries: TVSeries
        var castMembers: [CastMember]
        var videos: [VideoMetadata]
    }
}
