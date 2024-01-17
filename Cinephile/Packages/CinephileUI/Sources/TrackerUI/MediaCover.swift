//
//  MediaCoverView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import SwiftUI
import TMDb

public struct MediaCover: View {
    let title: String
    let releaseDate: Date?
    let posterPath: URL?
    
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    public var body: some View {
        VStack(alignment: .leading) {
            PosterImage(url: posterImage)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(title)", bundle: .module)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.primary)
                
                Text("\(format(date: releaseDate))", bundle: .module)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            do {
                posterImage = try await ImageLoaderS.generate(from: posterPath)
            } catch {
                print(error.localizedDescription)
            }
        }
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
    let tmdbConfiguration = TMDbConfiguration(apiKey: "0b8723760cac397ab78965e78c1cd188")
    TMDb.configure(tmdbConfiguration)
    
    return MediaCover(title: "Fight Club", releaseDate: .now, posterPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
}
