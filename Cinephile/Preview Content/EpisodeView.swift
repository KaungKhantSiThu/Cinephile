import Foundation
import SwiftUI
import TMDb

struct EpisodeView: View {
    var episodes: [TVEpisode]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Episode")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding([.leading, .bottom], 10)
                ForEach(episodes) { episode in
                    HStack(spacing: 20) {
                        Image(systemName: "person")
                            .background(in: Circle().inset(by: -8))
                            .backgroundStyle(.red.gradient)
                            .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                        VStack(alignment: .leading) {
                            Text(episode.name)
                                .font(.caption)
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
}

#Preview {
    EpisodeView(episodes: .preview!)
}


