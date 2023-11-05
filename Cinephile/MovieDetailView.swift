//
//  MovieDetail.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 29/10/2023.
//

import SwiftUI
import TMDb

struct MovieDetailView: View {
    let movie: Movie
    @State private var castMembers: [CastMember] = []
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
                    Text(movie.voteAverage ?? 0.0, format: .number)
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
            
            Button{
                
            } label: {
                Label("Post a review", systemImage: "pencil.and.outline")
            }
            .buttonStyle(CustomButtonStyle())
            
            CastMemberView(castMembers: castMembers)
        }
        .task {
            let movieLoader = MovieLoader()
            do {
                let casts = try await movieLoader.loadCastMembers(withID: movie.id).cast.prefix(upTo: 5)
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
    return MovieDetailView(movie: PreviewData.mockMovie, addButtonAction: addedList(id:))
}

struct CastMemberView: View {
    var castMembers: [CastMember]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(castMembers) { cast in
                HStack(spacing: 20) {
                    Image(systemName: "person")
                        .background(in: Circle().inset(by: -8))
                        .backgroundStyle(.red.gradient)
                        .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                    VStack(alignment: .leading) {
                        Text(cast.name)
                        Text(cast.character)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.leading, 20)
                
                Divider()
            }
        }
    }
}
