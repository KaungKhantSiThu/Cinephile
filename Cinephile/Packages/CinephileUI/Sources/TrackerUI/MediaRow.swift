//
//  MediaRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 30/11/2023.
//

import SwiftUI
import MediaClient
import NukeUI

public struct MediaRow: View {
    let name: String
    let releaseDate: Date?
    let posterPath: URL?
    let type: MediaType
    
//    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
     
    var action: () -> Void
    
    public var body: some View {
        HStack {
            PosterImage(url: ImageService.shared.posterURL(for: posterPath))
            
            VStack(alignment: .leading) {
                Text(type.rawValue)
                    .foregroundStyle(.red)
                
                Text(name)
                    .font(.title2)
                    .lineLimit(2)
                    .bold()
                
                Text(releaseDate ?? Date.now, format: .dateTime.year())
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
            
            Button {
                action()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing, 10)
            .disabled(type == .person)
            .opacity( type == .person ? 0 : 1)
        }
        .padding()
        .frame(height: 150)
//        .task {
//            do {
//                posterImage = try await ImageLoaderS.generate(from: posterPath)
//            } catch {
//                print("poster URL is nil")
//            }
//        }
    }
}

public extension MediaRow {
    init(movie: Movie, action: @escaping () -> Void) {
        self.name = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.type = .movie
        self.action = action
    }
    
    init(tvSeries: TVSeries, action: @escaping () -> Void) {
        self.name = tvSeries.name
        self.posterPath = tvSeries.posterPath
        self.releaseDate = tvSeries.firstAirDate
        self.type = .tvSeries
        self.action = action

    }
    
    init(person: Person, action: @escaping () -> Void) {
        self.name = person.name
        self.posterPath = person.profilePath
        self.releaseDate = person.birthday
        self.type = .person
        self.action = action
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
    MediaRow(name: "Some Movie", releaseDate: .now, posterPath: nil, type: .movie) {
        print("Hello")
    }
}

