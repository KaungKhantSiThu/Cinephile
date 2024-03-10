import CinephileUI
import Models
import SwiftUI
import Account

public struct GenresListView: View {
    
    let genres: [Genre]
    
    
    public init(genres: [Genre]) {
        self.genres = genres
    }
    
    public var body: some View {
        List {
            ForEach(genres) { genre in
                GenresRowView(genre: genre)
                    .padding(.vertical, 4)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .navigationTitle("Genres")
        .navigationBarTitleDisplayMode(.inline)
    }
}
