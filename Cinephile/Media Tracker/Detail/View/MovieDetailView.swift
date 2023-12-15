import SwiftUI
import TMDb

@MainActor
struct MovieDetailView: View {
    @EnvironmentObject var notificationManager: MediaNotificationManager
    @State private var isMovieAdded = false
    @State private var viewModel: MovieDetailViewModel
    
    init(id: Movie.ID) {
        _viewModel = .init(wrappedValue: MovieDetailViewModel(id: id))
    }
    
    var body: some View {
        AsyncContentView(source: viewModel) { data in
            ScrollView {
                PosterImage(url: viewModel.posterImageURL, height: 240)
                
                Text(data.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(data.movie.releaseDate ?? Date.now, format: .dateTime.year())
                Text(data.movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    Rating(voteCount: data.movie.voteCount ?? 0, voteAverage: data.movie.voteAverage ?? 0.0)
                    Button {
                        Task {
//                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
                            let localNotification = MediaNotification(
                                                                      title: "Cinephile Release Alert",
                                                                      body: "\(data.movie.title) is out tomorrow ",
                                                                      timeInterval: 5,
                                                                      repeats: false)
//                            localNotification.imageURL = data.movie.posterPath
                            await notificationManager.schedule(localNotification: localNotification)
                            print("Scheduled!!!")
                        }
                        } label: {
                            Label("Add Moive", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(CustomButtonStyle())
                }
                Text(data.movie.overview ?? "No overview")
                    .padding()
                
                VideosRowView(videos: data.videos)
                
                CastMemberView(castMembers: data.castMembers)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        MovieDetailView(id: Movie.preview.id)
//    }
//}
