//
//  StatusEntertainmentViewModel.swift
//
//
//  Created by Kaung Khant Si Thu on 21/01/2024.
//

import Foundation
import Models
import MediaClient

@MainActor
@Observable class StatusEntertainmentViewModel {
    let entertainment: Entertainment
    
    var trackerMedia: TrackerMedia?
    
    var posterImage: URL?
    
    var isTrackerMediaLoading: Bool = false
    
//    public init(entertainment: Entertainment) {
//        self.entertainment = entertainment
//        self.movieService = MovieService()
//        self.tvSeriesService = TVSeriesService()
//    }
    
    init(entertainment: Entertainment) {
        self.entertainment = entertainment
    }
    
    func fetchMedia() async {
        isTrackerMediaLoading = true
        do {
            switch entertainment.mediaType {
            case .movie:
                let movie: Movie = try await APIService.shared.get(endpoint: MoviesEndpoint.details(movieID: Int(entertainment.mediaId)!))
                isTrackerMediaLoading = false
                self.posterImage = ImageService.shared.posterURL(for: movie.posterPath ?? URL(string: "https://picsum.photos/200/300")!)
                trackerMedia = TrackerMedia(
                    id: movie.id,
                    title: movie.title,
                    posterURL: movie.posterPath, 
                    runtime: movie.runtime,
                    releasedDate: movie.releaseDate,
                    voteAverage: movie.voteAverage,
                    mediaType: .movie
                )
                
            case .tvSeries:
                let tvSeries: TVSeries = try await APIService.shared.get(endpoint: TVSeriesEndpoint.details(tvSeriesID: Int(entertainment.mediaId)!))
                isTrackerMediaLoading = false
                self.posterImage = ImageService.shared.posterURL(for: tvSeries.posterPath ?? URL(string: "https://picsum.photos/200/300")!)
                trackerMedia = TrackerMedia(
                    id: tvSeries.id,
                    title: tvSeries.name,
                    posterURL: tvSeries.posterPath,
                    releasedDate: tvSeries.firstAirDate,
                    voteAverage: tvSeries.voteAverage,
                    mediaType: .tvSeries
                )
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
