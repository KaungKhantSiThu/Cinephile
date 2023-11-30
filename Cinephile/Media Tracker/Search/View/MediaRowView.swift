//
//  MediaRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 30/11/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MediaRowView: View {
    let id: Int
    let name: String
    let releaseDate: Date?
    let posterPath: URL?
    let type: MediaType
    
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    
    var handler: (Int) -> Void
    
    var body: some View {
        HStack {
            WebImage(url: posterImage)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .clipShape(
                    RoundedRectangle(cornerRadius: 7.5)
                )
            
            
            VStack(alignment: .leading, spacing: 15) {
                Text(type.rawValue)
                    .foregroundStyle(.red)
                
                Text(name)
                    .font(.title3)
                    .bold()
                
                Text(releaseDate?.formattedDate() ?? "No Date")
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
            
            Button("Add") {
                handler(id)
            }
        }
        .padding()
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

extension MediaRowView {
    init(movie: Movie, handler: @escaping (Int) -> Void) {
        self.id = movie.id
        self.name = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.handler = handler
        self.type = .movie
    }
    
    init(tvSeries: TVSeries, handler: @escaping (Int) -> Void) {
        self.id = tvSeries.id
        self.name = tvSeries.name
        self.posterPath = tvSeries.posterPath
        self.releaseDate = tvSeries.firstAirDate
        self.handler = handler
        self.type = .tvSeries
    }
    
    init(person: Person, handler: @escaping (Int) -> Void) {
        self.id = person.id
        self.name = person.name
        self.posterPath = person.profilePath
        self.releaseDate = person.birthday
        self.handler = handler
        self.type = .person
    }
}

extension MediaRowView {
    enum MediaType: String {
        case movie = "Movie"
        case tvSeries = "Series"
        case person = "Person"
    }
}


#Preview {
    MediaRowView(movie: .preview) {
        print($0)
    }
}
