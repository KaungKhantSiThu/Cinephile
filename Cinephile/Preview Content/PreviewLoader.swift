//
//  PreviewLoader.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import Foundation
import TMDb

struct PreviewMovieLoader: DataLoader {
    
    func loadUpcomingItems() async throws -> [Movie] {
        return [Movie].preview
    }
    
    func loadItem(withID id: Int) async throws -> Movie {
        return Movie.preview
    }
    
    func loadTrendingItems() async throws -> [Movie] {
        return [Movie].preview
    }
    
    func loadCastMembers(withID id: Int) async throws -> [CastMember] {
        return [CastMember].preview
    }
    
    func loadRecommendedItems(withID id: Int) async throws -> [Movie] {
        return [Movie].preview
    }
    
    func loadVideos(withID id: Int) async throws -> [VideoMetadata] {
        return []
    }
    
    typealias Output = Movie
    
    
}
