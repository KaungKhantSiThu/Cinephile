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
                AsyncImage(url: viewModel.posterImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Rectangle()
                        .overlay {
                            ProgressView()
                        }
                        .frame(width: 120, height: 180)
                }
                .frame(height: 180)
                
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(movie.releaseDate ?? Date.now, format: .dateTime.year())
                Text(movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    VStack {
                        Text("4.4K Ratings")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(movie.voteAverage ?? 0.0, format: .number.precision(.fractionLength(1)))
                            .font(.title)
                            .fontWeight(.bold)
                        StarsView(rating: (movie.voteAverage ?? 0.0) / 2 , maxRating: 5)
                            .frame(width: 80)
                            .padding(.top, -10)
                    }
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

