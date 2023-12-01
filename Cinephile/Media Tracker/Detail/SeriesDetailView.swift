//import SwiftUI
//import TMDb
//
//struct SeriesDetailView: View {
//    let id: TVSeries.ID
//    private let loader = TVSeriesLoader()
//    @State private var castMembers: [CastMember] = []
//    @State private var series: TVSeries = TVSeries.preview!
//    var addButtonAction: (Movie.ID) -> Void
//    @State private var isMovieAdded = false
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                AsyncImage(url: URL(string: formatPosterPath(path: series.posterPath!.absoluteString))) { image in
//                    image
//                        .resizable()
//                        .scaledToFit()
//                } placeholder: {
//                    Rectangle()
//                        .overlay {
//                            ProgressView()
//                        }
//                        .frame(width: 120, height: 180)
//                }
//                .frame(height: 180)
//                
//                Text(series.name)
//                    .font(.title)
//                    .fontWeight(.bold)
//                
//                //            Text(movie.releaseDate!, format: .dateTime.year())
//                Text(series.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
//                
//                HStack(spacing: 30) {
//                    VStack {
//                        Text("4.4K Ratings")
//                            .font(.caption)
//                            .foregroundStyle(.secondary)
//                        Text(series.voteAverage ?? 0.0, format: .number.precision(.fractionLength(1)))
//                            .font(.title)
//                            .fontWeight(.bold)
//                        StarsView(rating: (series.voteAverage ?? 0.0) / 2 , maxRating: 5)
//                            .frame(width: 80)
//                            .padding(.top, -10)
//                    }
//                    Button {
//                    } label: {
//                        Label("Add Moive", systemImage: "plus.circle.fill")
//                    }
//                    .buttonStyle(CustomButtonStyle())
//                }
//                Text(series.overview ?? "No overview")
//                    .padding()
//                
//                //            CastMemberView(castMembers: castMembers)
////                NavigationLink(destination: EpisodeView(episodes: episodes)) {
////                    SeasonView(seasons: series.seasons ?? [])
////                }
//            }
//        }
//        .task {
//            do {
//                let casts = try await self.loader.loadCastMembers(withID: series.id).prefix(upTo: 5)
//                self.series = try await self.loader.loadItem(withID: self.id)
//                castMembers = Array(casts)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    private func formatPosterPath(path: String) -> String {
//        return "https://image.tmdb.org/t/p/original" + path
//    }
//}
//
//#Preview {
//    func addedList(id: TVSeries.ID) {
//        print("\(id) is added")
//    }
//    return SeriesDetailView(id: Int(TVSeries.preview?.id ?? 1), addButtonAction: addedList(id:))
//}
//
//

import SwiftUI
import TMDb

struct SeriesDetailView: View {
    private let loader = TVSeriesLoader()
    @State private var isSeriesAdded = false
    @StateObject private var viewModel: SeriesDetailViewModel<TVSeriesLoader>
    
    init(id: Movie.ID) {
        _viewModel = StateObject(wrappedValue: SeriesDetailViewModel<TVSeriesLoader>(id: id))
    }
    
    var body: some View {
        AsyncContentView(source: viewModel) { series in
            ScrollView {
                PosterImage(url: viewModel.posterImageURL, height: 240)
                
                Text(series.name)
                    .font(.title)
                    .fontWeight(.bold)
                
//                Text(movie.releaseDate ?? Date.now, format: .dateTime.year())
                Text(series.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    Rating(voteCount: series.voteCount ?? 0, voteAverage: series.voteAverage ?? 0.0)
                    Button {
                            // Delete
                        } label: {
                            Label("Add Moive", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(CustomButtonStyle())
                }
                Text(series.overview ?? "No overview")
                    .padding()
                
                VideosRowView(videos: viewModel.videos)
                
                CastMemberView(castMembers: viewModel.castMembers)
            }
        }
    }
}

#Preview {
    SeriesDetailView(id: Movie.preview.id)
}


