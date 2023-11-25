//
//  MovieDetail.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 29/10/2023.
//

import SwiftUI
import TMDb

struct MovieDetailView: View {
    let id: Movie.ID
    private let loader = MovieLoader()
    @State private var castMembers: [CastMember] = []
    @State private var movie: Movie = PreviewData.mockMovie
    var addButtonAction: (Movie.ID) -> Void
    @State private var isMovieAdded = false
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: formatPosterPath(path: movie.posterPath!.absoluteString))) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Rectangle()
                    .overlay {
                        ProgressView()
                    }
                    .frame(width: 120, height: 180)
            }
            .frame(height: 180)
            
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(movie.releaseDate!, format: .dateTime.year())
            Text(movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
            
            HStack(spacing: 30) {
                VStack {
                    Text("4.4K Ratings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(movie.voteAverage ?? 0.0, format: .number.precision(.fractionLength(1)))
                        .font(.title)
                        .fontWeight(.bold)
                    StarsView(rating: (movie.voteAverage ?? 0.0) / 2 , maxRating: 5)
                        .frame(width: 80)
                        .padding(.top, -10)
                }
                Button {
                        // Delete
                    } label: {
                        Label("Add Moive", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(CustomButtonStyle())
            }
            Text(movie.overview ?? "No overview")
                .padding()
            
            CastMemberView(castMembers: castMembers)
        }
        .task {
            do {
                let casts = try await self.loader.loadCastMembers(withID: movie.id).prefix(upTo: 5)
                self.movie = try await self.loader.loadItem(withID: self.id)
                print(self.movie)
                castMembers = Array(casts)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
    }
}

#Preview {
    func addedList(id: Movie.ID) {
        print("\(id) is added")
    }
    return MovieDetailView(id: PreviewData.mockMovie.id, addButtonAction: addedList(id:))
}

