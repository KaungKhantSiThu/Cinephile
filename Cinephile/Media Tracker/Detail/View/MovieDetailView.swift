import SwiftUI
import TMDb

struct MovieDetailView: View {
    private let loader = MovieLoader()
    @State private var isMovieAdded = false
    @StateObject private var viewModel: MovieDetailViewModel<MovieLoader>
    
    init(id: Movie.ID) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel<MovieLoader>(id: id))
    }
    
    var body: some View {
        AsyncContentView(source: viewModel) { movie in
            ScrollView {
                PosterImage(url: viewModel.posterImageURL, height: 240)
                
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(movie.releaseDate ?? Date.now, format: .dateTime.year())
                Text(movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    Rating(voteCount: movie.voteCount ?? 0, voteAverage: movie.voteAverage ?? 0.0)
                    Button {
                            // Delete
                        } label: {
                            Label("Add Moive", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(CustomButtonStyle())
                }
                Text(movie.overview ?? "No overview")
                    .padding()
                
                VideosRowView(videos: viewModel.videos)
                
                CastMemberView(castMembers: viewModel.castMembers)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(id: Movie.preview.id)
    }
}
