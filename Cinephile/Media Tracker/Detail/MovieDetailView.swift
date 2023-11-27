import SwiftUI
import TMDb

struct MovieDetailView: View {
    let id: Movie.ID
    private let loader = MovieLoader()
    @State private var castMembers: [CastMember] = []
    @State private var videos: [VideoMetadata] = []
    @State private var movie: Movie = .preview
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var addButtonAction: (Movie.ID) -> Void
    @State private var isMovieAdded = false
    var body: some View {
        ScrollView {
            AsyncImage(url: posterImage) { image in
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
            
            VideosRowView(videos: videos)
            
            CastMemberView(castMembers: castMembers)
        }
        .task {
            do {
                let casts = try await self.loader.loadCastMembers(withID: self.id).prefix(upTo: 10)
                self.videos = try await self.loader.loadVideos(withID: self.id)
                self.movie = try await self.loader.loadItem(withID: self.id)
                posterImage = try await ImageLoader.generate(from: movie.posterPath, width: 200)
                print(self.movie)
                castMembers = Array(casts)
            } catch {
                print("Something wrong")
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    func addedList(id: Movie.ID) {
        print("\(id) is added")
    }
    return MovieDetailView(id: Movie.preview.id, addButtonAction: addedList(id:))
}

