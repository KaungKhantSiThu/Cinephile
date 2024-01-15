//
//  TrendingMediaSectionView.swift
//
//
//  Created by Kaung Khant Si Thu on 11/01/2024.
//

import SwiftUI
import TMDb
import Environment

struct MoviesSection<Header: View, Content: View>: View {
    let movies: [Movie]
    private var content: (Movie) -> Content
    private var header: Header

    init(movies: [Movie], @ViewBuilder content: @escaping (Movie) -> Content, @ViewBuilder header: () -> Header) {
        self.movies = movies
        self.header = header()
        self.content = content
    }
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(movies, content: content)
                }
            }
            .scrollIndicators(.hidden)
        } header: {
            header
        }
    }
}
