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
    MovieDetailView(id: Movie.preview.id)
}


struct Rating: View {
    let voteCount: Int
    let voteAverage: Double
    var body: some View {
        VStack {
            Text(voteCount, format: .number)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(voteAverage, format: .number.precision(.fractionLength(1)))
                .font(.title)
                .fontWeight(.bold)
            StarsView(rating: voteAverage / 2 , maxRating: 5)
                .frame(width: 80)
                .padding(.top, -10)
        }
    }
}

//VStack {
//    Text((movie.voteCount ?? 0), format: .number)
//        .font(.caption)
//        .foregroundStyle(.secondary)
//    Text(movie.voteAverage ?? 0.0, format: .number.precision(.fractionLength(1)))
//        .font(.title)
//        .fontWeight(.bold)
//    StarsView(rating: (movie.voteAverage ?? 0.0) / 2 , maxRating: 5)
//        .frame(width: 80)
//        .padding(.top, -10)
//}
