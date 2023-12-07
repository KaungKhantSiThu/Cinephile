import Foundation
import SDWebImageSwiftUI
import SwiftUI
import TMDb

struct SeasonView: View {
    var seasons: [TVSeason]
    var body: some View {
        VStack(alignment: .leading) {
            Text("All Episodes")
                .foregroundStyle(.black)
                .font(.title)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(seasons) { season in
                SeasonRow(season: season)
                Divider()
            }
        }
    }
}

#Preview {
    SeasonView(seasons: (TVSeries.preview?.seasons)!)
}



struct SeasonRow: View {
    let name: String
    let posterPath: URL?
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        HStack(spacing: 20) {
            
            PosterImage(url: posterImage, height: 100)
            VStack(alignment: .leading) {
                HStack {
                    Text(name)
                        .font(.title2)
                    .bold()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                
            }
            
        }
        .padding(.leading, 20)
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

extension SeasonRow {
    init(season: TVSeason) {
        self.name = season.name
        self.posterPath = season.posterPath
    }
}
