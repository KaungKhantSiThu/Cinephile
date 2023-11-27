//
//  MovieCoverView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MovieCoverView: View {
    let movie: Movie
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: posterImage)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )

                
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .fontWeight(.semibold)
                    .frame(width: 80)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                Text(formatReleasedDate(date: movie.releaseDate))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

        }
        .padding()
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: movie.posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
        .onAppear {
            print(Movie.preview)
        }
    }
    
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
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

struct MovieCoverView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCoverView(movie: .preview)
            .previewLayout(.sizeThatFits)
    }
}
