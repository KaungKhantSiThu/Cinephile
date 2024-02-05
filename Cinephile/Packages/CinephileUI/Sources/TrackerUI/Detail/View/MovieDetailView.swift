import SwiftUI
import MediaClient
import Environment

@MainActor
public struct MovieDetailView: View {
    @Environment(MediaNotificationManager.self) var notificationManager: MediaNotificationManager
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
                
                HStack {
                    Text(data.movie.releaseDate ?? Date.now, format: .dateTime.year())
                    
                    if let status = data.movie.status {
                        MediaStatus(status: status)
                    }
                }
                
                
                // make it button so the users can search based on genre
                if let genres = data.movie.genres {
                    
                    FlowLayout(alignment: .center) {
                        ForEach(genres) { genre in
                            Text(genre.name)
                                .padding(10)
                                .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 10.0))
                        }
                    }
                }
                
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
                    
                    TrackerActionButton()
                    
//                    Button {
//                        // what if there isn't a released date and the user wanna just add it to watchlist
//                        
//                        if let releaseDate = data.movie.releaseDate {
//                            let _ = Calendar.current.dateComponents([.year, .month, .day], from: releaseDate)
//                            Task {
//                                let mediaNotification = MediaNotification(
//                                    scheduleType: .time,
//                                    title: "Release Alert",
//                                    body: "\(data.movie.title) is out tomorrow",
//                                    imageURL: viewModel.posterImageURL,
//                                    userInfo: [
//                                        "id": data.movie.id,
//                                        "type": "movie"
//                                    ],
//                                    timeInterval: 5)
//                                await notificationManager.schedule(localNotification: mediaNotification)
//                            }
//                        }
//                    } label: {
//                        Label("Watchlist", systemImage: "plus.circle.fill")
//                    }
//                    .tint(.accentColor)
//                    .buttonStyle(.borderedProminent)
                }
                                
                Text(data.movie.overview ?? "No overview")
                    .padding()
                
                VideosRowView(videos: data.videos)
                
                CastMemberView(castMembers: data.castMembers)
                
                VStack(alignment: .leading) {
                    Text("Recommendations")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(data.recommendations) { movie in
                                NavigationLink(value: RouterDestination.movieDetail(id: movie.id)) {
                                    MediaCover(movie: movie)
                                        .frame(width: 100)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
}



#Preview {
    return NavigationStack {
        MovieDetailView(id: 550)
            .environment(MediaNotificationManager())
    }
}
