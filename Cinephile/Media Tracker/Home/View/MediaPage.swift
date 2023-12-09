//
//  MediaPage.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 08/12/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MediaPage: View {
    let title: String
    let image: URL?
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        PosterImage(url: posterImage, height: 390)
            .overlay(alignment: .bottom) {
                HStack {
                    Text(title)
                    
                    Spacer()
                    
                    Image(systemName: "heart")
                }
                .padding()
                .background(.thinMaterial)
            }
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: image, width: 260)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

extension MediaPage {
    init(movie: Movie) {
        self.title = movie.title
        self.image = movie.posterPath
    }
}



#Preview(traits: .sizeThatFitsLayout) {
    MediaPage(movie: .preview)
}
