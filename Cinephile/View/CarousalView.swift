//
//  CarousalView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb

enum ViewCategory: String {
    case discover = "Discover"
    case recommended = "Recommended"
    case upcomming = "Upcoming"
    case movie = "Movies"
    case series = "Series"
}

struct CarousalView: View {
    let title: ViewCategory
    let movies: [Movie]
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                CategorialMovieView(movies: movies)
            } label: {
                HStack {
                    Text(title.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.right")
                }
            }
            .buttonStyle(.plain)

            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(movies.prefix(5)) { movie in
                        NavigationLink(value: movie) {
                            MovieCoverView(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        CarousalView(title: .discover, movies: PreviewData.mockMovieArray)
            .navigationDestination(for: Movie.self) {
                MovieDetailView(id: $0.id, addButtonAction: { (id: Movie.ID) -> Void in
                    print(id)
                  })
        }
    }
}
