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
                    EpisodeRow(episode: episode)
                    Divider()
                }
            }
        }
    }
}

#Preview {
    EpisodeView(episodes: .preview!)
}

struct EpisodeRow: View {
    var episode : TVEpisode
    @State var isSelected = false
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: formatPosterPath(path: episode.stillPath!.absoluteString))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                Rectangle()
                    .overlay {
                        ProgressView()
                    }
                    .frame(width: 122, height: 70)
            }
            .frame(height: 70)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(episode.episodeNumber)")
                            .foregroundStyle(.black)
                            .font(.system(size: 15))
                        
                        Text(episode.name)
                            .foregroundStyle(.black)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(episode.airDate ?? Date.now, format: .dateTime.year())
                        .foregroundStyle(.black)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack() {
                    Button(action: {
                        isSelected.toggle()
                    }) {
                        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                             .resizable()
                             .frame(width: 13, height: 13)
                             .foregroundColor(isSelected ? .blue : .gray)
                    }
                }
            }
        }
        .padding(.leading, 20)
        .padding()
    }
    
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
    }
}


