import SwiftUI
import TMDb

struct EpisodeDetailView: View {
    private let loader = TVEpisodeLoader()
    @State private var isMovieAdded = false
    @StateObject private var viewModel: EpisodeDetailViewModel<TVEpisodeLoader>
    
    init(id: TVEpisode.ID) {
        _viewModel = StateObject(wrappedValue: EpisodeDetailViewModel<TVEpisodeLoader>(id: id))
    }
    
    var body: some View {
        AsyncContentView(source: viewModel) { movie in
            ScrollView {
                PosterImage(url: viewModel.posterImageURL, height: 240)
                
                Text(movie.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(movie.airDate ?? Date.now, format: .dateTime.year())
//                Text(movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
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
    EpisodeDetailView(id: Int(TVEpisode.preview!.id))
}


