//
//  CarousalView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb

struct CarousalView: View {
    let title: String
    let movies: [Movie]
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                CategorialMovieView(movies: movies)
            } label: {
                HStack {
                    Text(title)
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
                            MediaCoverView(movie: movie)
                                .frame(width: 100)
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
//    NavigationStack {
        CarousalView(title: "Trending Movies", movies: .preview)
//            .navigationDestination(for: Movie.self) {
//                MovieDetailView(id: $0.id, addButtonAction: { (id: Movie.ID) -> Void in
//                    print(id)
//                  })
//        }
//    }
}
