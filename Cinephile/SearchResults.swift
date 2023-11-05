//
//  SearchResults.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.
//

import SwiftUI
import TMDb

struct BirdsSearchResults<Content: View>: View {
    @Binding var searchText: String
    var movies: [Movie]
    private var content: (Movie) -> Content
    
    init(searchText: Binding<String>, movies: [Movie], @ViewBuilder content: @escaping (Movie) -> Content) {
        _searchText = searchText
        self.movies = movies
        self.content = content
    }
    
    var body: some View {
        if $searchText.wrappedValue.isEmpty {
            ForEach(movies, content: content)
        } else {
            ForEach(movies.filter {
                $0.title.contains($searchText.wrappedValue)
            }, content: content)
        }
    }
}
