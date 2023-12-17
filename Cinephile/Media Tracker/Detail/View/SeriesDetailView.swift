import SwiftUI
import TMDb

enum SeriesPage: String, Equatable, CaseIterable {
    case detail = "Details"
    case season = "Seasons"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue)
    }
}

@MainActor
struct SeriesDetailView: View {
    private let loader = TVSeriesLoader()
    @State private var model: TVSeriesDetailViewModel
    @State private var selectedPage: SeriesPage = .detail
    
    init(id: TVSeries.ID) {
        _model = .init(wrappedValue: TVSeriesDetailViewModel(id: id))
    }
    var body: some View {
        AsyncContentView(source: model) { data in
            ScrollView {
                PosterImage(url: model.posterImageURL, height: 240)
                
                Text(data.tvSeries.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(data.tvSeries.firstAirDate ?? Date.now, format: .dateTime.year())
                
                Text(data.tvSeries.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    Rating(voteCount: data.tvSeries.voteCount ?? 0, voteAverage: data.tvSeries.voteAverage ?? 0.0)
                    
                    Button {
                        // something
                    } label: {
                        Label("Add Series", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                
                Picker("", selection: $selectedPage) {
                    ForEach(SeriesPage.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                switch selectedPage {
                case .detail:
                    Text(data.tvSeries.overview ?? "No overview")
                        .padding()
                    VideosRowView(videos: data.videos)
                    
                    CastMemberView(castMembers: data.castMembers)
                case .season:
                    SeasonView(id: data.tvSeries.id, seasons: data.tvSeries.seasons ?? [])
                }
                
            }
        }
    }
}

#Preview {
    SeriesDetailView(id: TVSeries.preview!.id)
}


