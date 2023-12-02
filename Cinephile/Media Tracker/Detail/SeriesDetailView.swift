import SwiftUI
import TMDb

enum SeriesPage: String, Equatable, CaseIterable {
    case detail = "Details"
    case season = "Seasons"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct SeriesDetailView: View {
    private let loader = TVSeriesLoader()
    @StateObject private var model: TVSeriesDetailViewModel<TVSeriesLoader>
    var addButtonAction: (Movie.ID) -> Void
    @State private var selectedPage: SeriesPage = .detail
    
    init(id: TVSeries.ID, addButtonAction: @escaping (Movie.ID) -> Void) {
        _model = StateObject(wrappedValue: TVSeriesDetailViewModel(id: id))
        self.addButtonAction = addButtonAction
    }
    var body: some View {
        AsyncContentView(source: model) { series in
            ScrollView {
                PosterImage(url: model.posterImageURL, height: 240)
                
                Text(series.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(series.firstAirDate ?? Date.now, format: .dateTime.year())
                
                Text(series.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                
                HStack(spacing: 30) {
                    Rating(voteCount: series.voteCount ?? 0, voteAverage: series.voteAverage ?? 0.0)
                    
                    Button {
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
                    Text(series.overview ?? "No overview")
                        .padding()
                    VideosRowView(videos: model.videos)
                    
                    CastMemberView(castMembers: model.castMembers)
                case .season:
                    SeasonView(seasons: series.seasons ?? [])
                }
                
            }
        }
    }
}

#Preview {
    func addedList(id: TVSeries.ID) {
        print("\(id) is added")
    }
    return SeriesDetailView(id: TVSeries.preview!.id, addButtonAction: addedList(id:))
}


