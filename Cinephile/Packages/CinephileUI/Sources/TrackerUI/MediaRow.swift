//
//  MediaRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 30/11/2023.
//

import SwiftUI
import TMDb
import NukeUI

public struct MediaRow: View {
    let name: String
    let releaseDate: Date?
    let posterPath: URL?
    let type: MediaType
    
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
     
//    var handler: (Int) -> Void
    
    public var body: some View {
        HStack {
            PosterImage(url: posterImage)
            
            VStack(alignment: .leading, spacing: 15) {
                Text(type.rawValue)
                    .foregroundStyle(.red)
                
                Text(name)
                    .font(.title3)
                    .lineLimit(2)
                    .bold()
                
                Text(releaseDate?.formattedDate() ?? "No Date")
                    .foregroundStyle(.secondary)
                
            }
//            
//            Spacer()
//            
//            Button(action: { handler(id) }, label: {
//                Image(systemName: "plus.circle")
//                    .resizable()
//                    .frame(width: 30, height: 30)
//            })
//            .padding(.trailing, 10)
        }
        .padding()
        .frame(height: 150)
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

public extension MediaRow {
    init(movie: Movie) {
        self.name = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
//        self.handler = handler
        self.type = .movie
    }
    
    init(tvSeries: TVSeries) {
        self.name = tvSeries.name
        self.posterPath = tvSeries.posterPath
        self.releaseDate = tvSeries.firstAirDate
//        self.handler = handler
        self.type = .tvSeries
    }
    
    init(person: Person) {
        self.name = person.name
        self.posterPath = person.profilePath
        self.releaseDate = person.birthday
//        self.handler = handler
        self.type = .person
    }
}

public extension MediaRow {
    enum MediaType: String {
        case movie = "Movie"
        case tvSeries = "Series"
        case person = "Person"
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    MediaRow(name: "Some Movie", releaseDate: .now, posterPath: nil, type: .movie)
}

