//
//  TMDbImage.swift
//
//
//  Created by Kaung Khant Si Thu on 13/01/2024.
//

import SwiftUI
import NukeUI
import MediaClient

struct LogoImage: View {
    let url: URL
//    @State private var completeURL: URL = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        LazyImage(url: ImageService.shared.posterURL(for: url)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if state.error != nil {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .frame(width: 70, height: 35)
        .background(in: RoundedRectangle(cornerRadius: 10))
//        .task {
//            do {
//                completeURL = try await ImageLoaderS.generateLogo(from: self.url)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}
//
//#Preview {
//    let tmdbConfiguration = TMDbConfiguration(apiKey: ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? "")
//    TMDb.configure(tmdbConfiguration)
//    return LogoImage(url: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!)}
