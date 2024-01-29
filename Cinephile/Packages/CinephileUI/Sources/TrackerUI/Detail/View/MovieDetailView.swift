import SwiftUI
import MediaClient
import Environment

@MainActor
public struct MovieDetailView: View {
    @EnvironmentObject var notificationManager: MediaNotificationManager
    @State private var isMovieAdded = false
    @State private var viewModel: MovieDetailViewModel
    
    public init(id: Movie.ID) {
        _viewModel = .init(wrappedValue: MovieDetailViewModel(id: id))
    }
    
    public var body: some View {
        AsyncContentView(source: viewModel) { data in
            ScrollView {
                PosterImage(url: viewModel.posterImageURL, height: 240)
                
                Text(data.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(data.movie.releaseDate ?? Date.now, format: .dateTime.year())
                
                // make it button so the users can search based on genre
                Text(data.movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                Divider()
                
                if let watchProviders = data.showWatchProvider?.buy {
                    WatchProvidersView(providers: watchProviders)
                } else {
                    Text("Streaming is not available at the moment")
                        .font(.title3)
                }
                
                Divider()
                
                HStack(spacing: 30) {
                    Rating(voteCount: data.movie.voteCount ?? 0, voteAverage: data.movie.voteAverage ?? 0.0)
                    Button {
                        // what if there isn't a released date and the user wanna just add it to watchlist
                        
                        if let releaseDate = data.movie.releaseDate {
                            let _ = Calendar.current.dateComponents([.year, .month, .day], from: releaseDate)
                            Task {
                                let mediaNotification = MediaNotification(
                                    scheduleType: .time,
                                    title: "Release Alert",
                                    body: "\(data.movie.title) is out tomorrow",
                                    imageURL: viewModel.posterImageURL,
                                    userInfo: [
                                        "id": data.movie.id,
                                        "type": "movie"
                                    ],
                                    timeInterval: 5)
                                await notificationManager.schedule(localNotification: mediaNotification)
                            }
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
//    let tmdbConfiguration = TMDbConfiguration(apiKey: ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? "")
//    TMDb.configure(tmdbConfiguration)
//    return NavigationStack {
//        MovieDetailView(id: 550)
//    }
//}
