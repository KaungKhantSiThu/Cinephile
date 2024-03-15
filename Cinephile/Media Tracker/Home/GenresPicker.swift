//
//  GenresPicker.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 08/03/2024.
//

import SwiftUI
import TrackerUI
import MediaClient
import Environment


extension Genre {
    static let all: [Genre] = [
        Genre(id: 28, name: "Action"),
        Genre(id: 12, name: "Adventure"),
        Genre(id: 16, name: "Animation"),
        Genre(id: 35, name: "Comedy"),
        Genre(id: 80, name: "Crime"),
        Genre(id: 99, name: "Documentary"),
        Genre(id: 18, name: "Drama"),
        Genre(id: 10751, name: "Family"),
        Genre(id: 14, name: "Fantasy"),
        Genre(id: 36, name: "History"),
        Genre(id: 27, name: "Horror"),
        Genre(id: 10402, name: "Music"),
        Genre(id: 9648, name: "Mystery"),
        Genre(id: 10749, name: "Romance"),
        Genre(id: 878, name: "Science Fiction"),
        Genre(id: 10770, name: "TV Movie"),
        Genre(id: 53, name: "Thriller"),
        Genre(id: 10752, name: "War"),
        Genre(id: 37, name: "Western")
    ]
}

@MainActor
struct GenresPicker: View {
    @State private var selectedGenres: [Int] = []
    @State private var genres: [Genre] = Genre.all
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Tell us what you like")
                    .font(.largeTitle)
                    .bold()
                Text("Tap the genres you like so that we can personalize the posts for you")
                    .font(.body)
                FlowLayout(alignment: .leading) {
                    ForEach(Genre.all) { genre in
                        Toggle(isOn: self.binding(for: genre)) {
                            Text(genre.name)
                        }
                        .toggleStyle(GenreToggleStyle())
                    }
                }
            }
            .padding()
            .task {
                do {
                    let response: GenresResponse = try await APIService.shared.get(endpoint: GenresEndpoint.movie)
                    self.genres = response.genres
                    let followedGenres = currentAccount.genres.map { $0.genreId }
                    print(followedGenres)
                    withAnimation {
                        selectedGenres = followedGenres
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            let updatedGenres = await currentAccount.updateGenres(ids: selectedGenres)
                        }
//                        print(selectedGenres)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .tint(.red)
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
    private func binding(for genre: Genre) -> Binding<Bool> {
        Binding(
            get: {
                self.selectedGenres.contains(genre.id)
            },
            set: { isSelected in
                if isSelected {
                    self.selectedGenres.append(genre.id)
                } else {
                    if let index = self.selectedGenres.firstIndex(of: genre.id) {
                        self.selectedGenres.remove(at: index)
                    }
                }
            }
        )
    }
    
    struct GenresResponse: Codable {
        let genres: [Genre]
    }
}

struct GenreToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
        }
            .padding()
            .foregroundStyle(.primary)
            //                    .frame(width: 300, height: 50)
            .background(Color.red.opacity(configuration.isOn ? 0.3 : 0))
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.red, lineWidth: 2)
            )
    }
}
