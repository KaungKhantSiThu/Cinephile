//
//  TMDbImage.swift
//
//
//  Created by Kaung Khant Si Thu on 13/01/2024.
//

import SwiftUI

struct LogoImage: View {
    let url: URL
    @State private var completeURL: URL = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        ZStack {
            AsyncImage(url: completeURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 75)
        }
    }
}

#Preview {
    LogoImage(url: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!)
}
