import SwiftUI
import MediaClient
import Environment
import Networking

@MainActor
public struct MovieDetailView: View {
    @Environment(MediaNotificationManager.self) var notificationManager: MediaNotificationManager
//    @Environment(AppAccountsManager.self) private var appAccounts
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(Client.self) private var client
    @Environment(RouterPath.self) private var routerPath

    
    @State private var isMovieAdded = false
    @State private var viewModel: MovieDetailViewModel
    @State private var isLoading = false
    @State private var isWatchStatusLoading = false
    @State private var loaded = false
    @State private var id: Movie.ID
    
    public init(id: Movie.ID) {
        _viewModel = .init(wrappedValue: MovieDetailViewModel(id: id))
        _id = .init(wrappedValue: id)
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
                
                
                Grid {
                    GridRow {
                        Rating(voteCount: data.movie.voteCount ?? 0, voteAverage: data.movie.voteAverage ?? 0.0)
                        if viewModel.isLoggedin {
                            VStack {
                                Button {
                                    Task {
                                        isLoading = true
                                        
                                        if viewModel.inWatchlist {
                                            print("Removing \(data.movie.id) : \(data.movie.title) from watchlist")
                                            await viewModel.removeFromWatchlist()
                                        } else {
                                            print("Adding \(data.movie.id) : \(data.movie.title) to watchlist")
                                            if let _ = data.movie.releaseDate {
        //                                            let _ = Calendar.current.dateComponents([.year, .month, .day], from: releaseDate)
                                                Task {
                                                    await notificationManager.notificationAttachment(name: data.movie.title, url: viewModel.posterImageURL)
                                                }
                                            }
                                            await viewModel.addToWatchlist()
                                        }
                                        try! await Task.sleep(nanoseconds: 1_000_000_000)
                                        isLoading = false
                                        
                                    }
                                    
                                    
                                } label: {
                                    Image(systemName: viewModel.inWatchlist ? "trash.fill" : "plus.circle.fill")
                                        .opacity(isLoading ? 0 : 1)
                                        .overlay {
                                            if isLoading {
                                                ProgressView()
                                            }
                                        }
                                }
                                .disabled(isLoading)
                                .tint(.red)
                                .buttonStyle(.borderedProminent)
                                
                                if viewModel.inWatchlist {
                                    Button {
                                        Task {
                                            isWatchStatusLoading = true
                                            
                                            if viewModel.hasWatched {
                                                print("\(data.movie.id) : \(data.movie.title) is marked as watched")
                                                await viewModel.markAsNotWatch()
                                            } else {
                                                print("\(data.movie.id) : \(data.movie.title) is marked as Not watch")
                                                await viewModel.markAsWatched()
                                            }
                                            isWatchStatusLoading = false
                                            
                                        }
                                        
                                        
                                    } label: {
                                        Image(systemName: "eye")
                                            .symbolVariant(viewModel.hasWatched ? .slash : .none)
                                            .opacity(isWatchStatusLoading ? 0 : 1)
                                            .overlay {
                                                if isWatchStatusLoading {
                                                    ProgressView()
                                                }
                                            }
                                    }
                                    .disabled(isWatchStatusLoading)
                                    .tint(.red)
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            
                            VStack(alignment: .trailing, spacing: 20) {
                                Text(viewModel.inWatchlist ? "Remove from Watchlist" : "Add to Watchlist")
                                if viewModel.inWatchlist {
                                    Text(viewModel.hasWatched ? "Unmark as Watched" : "Mark as Watched")
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .gridCellAnchor(.center)
                        }
                    }
                    
            
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let entertainmentID = viewModel.entertainmentID {
                        routerPath.navigate(to: .media(id: entertainmentID, title: viewModel.title))
                    }
                    
                } label: {
                    Text("Posts")
                        .bold()
                        .padding(.vertical, 2)
                }
            }
        }
        .alert(
            "status.error.posting.title",
            isPresented: $viewModel.showWatchlistErrorAlert,
            actions: {
                Button {
                    
                } label: {
                    Text("alert.button.ok", bundle: .module)
                }
            }, message: {
                Text(viewModel.watchlistError ?? "")
            }
        )
        .onAppear {
            viewModel.client = client
        }
//        .onChange(of: appAccounts.currentClient) { _, newValue in
//            currentAccount.setClient(client: newValue)
//            viewModel.client = newValue
//        }
        
    }
}



//#Preview {
//    return NavigationStack {
//        MovieDetailView(id: 550)
//            .environment(MediaNotificationManager())
//            
//    }
//}
