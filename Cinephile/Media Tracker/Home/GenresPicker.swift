//
//  GenresPicker.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 08/03/2024.
//

import SwiftUI
import TrackerUI
import MediaClient

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

struct GenresPicker: View {
    @State private var selectedGenres: [Int] = [28, 12]
    var body: some View {
        VStack {
            FlowLayout {
                ForEach(Genre.all) { genre in
                    Toggle(isOn: self.binding(for: genre)) {
                        Text(genre.name)
                    }
                    .toggleStyle(GenreToggleStyle())
                }
            }
            
            HStack {
                Text("Selected Genres")
                Text(selectedGenres.map(String.init).joined(separator: ","))
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
}

struct GenreToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            Button(action: { configuration.isOn.toggle() }){
//                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
//                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
//                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
//                    .imageScale(.large)
//            }
//
//            Spacer()
//
//            configuration.label
//        }
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
        }
        
            .padding()
            .foregroundStyle(.primary)
            //                    .frame(width: 300, height: 50)
            .background(Color.red.opacity(configuration.isOn ? 0.3 : 0))
            .cornerRadius(10) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.red, lineWidth: 2)
            )
    }
}

#Preview {
    GenresPicker()
}
