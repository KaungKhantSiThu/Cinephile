import Foundation
import SwiftUI
import TMDb

struct EpisodeView: View {
    var episodes: [TVEpisode]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Episodes")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding([.leading, .bottom], 10)
                ForEach(episodes) { episode in
                    HStack(spacing: 20) {
                        AsyncImage(url: URL(string: formatPosterPath(path: episode.stillPath!.absoluteString))) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Rectangle()
                                .overlay {
                                    ProgressView()
                                }
                                .frame(width: 120,height: 70)
                        }

                        .frame(height: 70)
                        VStack(alignment: .leading) {
                            Text(episode.name)
                                .foregroundStyle(.black)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.leading, 20)
                    .padding()
                    
                    Divider()
                }
            }
        }
    }
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
    }
}

#Preview {
    EpisodeView(episodes: .preview!)
}


