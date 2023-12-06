import SwiftUI
import TMDb

struct MovieDetailView: View {
    @EnvironmentObject var notificationManager: LocalNotificationManager
    @EnvironmentObject private var routerPath: RouterPath
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
                        Task {
//                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
                            let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                                      title: "Cinephile Release Alert",
                                                                      body: "\(movie.title) is out tomorrow ",
                                                                      timeInterval: 5,
                                                                      repeats: false)
//                            localNotification.userInfo = ["nextView" : NextView.renew.rawValue]
                            await notificationManager.schedule(localNotification: localNotification)
                            print("Scheduled!!!")
                        }
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
