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
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink("See all") {
                    CategorialMovieView(movies: movies)
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(movies.prefix(5)) { movie in
                        NavigationLink(value: movie) {
                            MediaCover(movie: movie)
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

struct CarousalSeriesView: View {
    let title: String
    let series: [TVSeries]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink("See all") {
                    Text("Haven't implemented")
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(series.prefix(5)) { series in
                        NavigationLink(value: series) {
                            MediaCover(tvSeries: series)
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
    NavigationStack {
        CarousalView(title: "Trending Movies", movies: .preview)
    }
}
