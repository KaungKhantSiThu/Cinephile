//
//  SwiftUIView.swift
//
//
//  Created by Kaung Khant Si Thu on 10/02/2024.
//

import SwiftUI
import MediaClient

struct MovieCover: View {
    let id: Movie.ID
    @State private var movie: Movie?
    @State private var error: Error?
    var body: some View {
        ZStack {
            if let movie {
                MediaCover(movie: movie)
            } else {
                MediaCover(movie: .bulletTrain)
                    .redacted(reason: .placeholder)
            }
        }
        .task {
            do {
                self.movie = try await APIService.shared.get(endpoint: MoviesEndpoint.details(movieID: id))
            } catch {
                print("Error fetching movie: \(id)")
            }
            
        }
    }
}

#Preview {
    MovieCover(id: 346698)
}
