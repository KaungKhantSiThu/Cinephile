//
//  MediaCoverView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import SwiftUI
import MediaClient

public struct MediaCover: View {
    let title: String
    let releaseDate: Date?
    let posterPath: URL?
    
//    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    public var body: some View {
        VStack(alignment: .center, spacing: 5) {
            PosterImage(url: ImageService.shared.posterURL(for: posterPath))
            
            Text(format(date: releaseDate))
                .font(.caption)
                .foregroundStyle(.primary)
//            VStack(alignment: .leading, spacing: 0) {
////                Text("\(title)")
////                    .fontWeight(.semibold)
////                    .lineLimit(1)
////                    .font(.caption)
////                    .foregroundStyle(.primary)
//                
//                
//            }
        }
//        .task {
//            do {
//                posterImage = try await ImageLoaderS.generate(from: posterPath)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    
    private func format(date: Date?) -> String {
        guard let date = date else { return "No Date" }
        
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
}

public extension MediaCover {
    init(movie: Movie) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
    }
    
    init(tvSeries: TVSeries) {
        self.title = tvSeries.name
        self.posterPath = tvSeries.posterPath
        self.releaseDate = tvSeries.firstAirDate
    }
}




#Preview(traits: .sizeThatFitsLayout) {
    
    return MediaCover(
        title: "Fight Club",
        releaseDate: .now,
        posterPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
}
