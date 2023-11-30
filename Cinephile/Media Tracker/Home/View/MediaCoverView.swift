//
//  MediaCoverView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MediaCoverView: View {
    let title: String
    let releaseDate: Date?
    let posterPath: URL?
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: posterImage)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .clipShape(
                    RoundedRectangle(cornerRadius: 7.5)
                )

                
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                Text(formatReleasedDate(date: releaseDate))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
    
    private func formatReleasedDate(date: Date?) -> String {
        let dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "No Date"
        }
    }
}

extension MediaCoverView {
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

struct MovieCoverView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCoverView(movie: .preview)
            .previewLayout(.sizeThatFits)
    }
}
