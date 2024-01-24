//
//  StatusEditorTrackerView.swift
//
//
//  Created by Kaung Khant Si Thu on 03/01/2024.
//

import SwiftUI
import MediaClient
import Environment
import TrackerUI
import CinephileUI
import Models

extension StatusEditor {
    @MainActor
    struct TrackerMediaView: View {
        //        @Environment(Theme.self) private var theme
        //    @Environment(CurrentInstance.self) private var currentInstance
        
        var trackerMedia: TrackerMedia
        
        //        @Binding var showTrackerMedia: Bool
        @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
        
        @State private var id: TrackerMedia.ID?
        
        let discardAction: () -> Void
        
        init(media: TrackerMedia, discardAction: @escaping () -> Void) {
            self.trackerMedia = media
            self.discardAction = discardAction
        }
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                HStack(alignment: .top, spacing: 25) {
                    PosterImage(url: posterImage)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(trackerMedia.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        
                        if let voteAverage = trackerMedia.voteAverage {
                            PopularityBadge(score: Int(voteAverage * 10))
                        } else {
                            PopularityBadge(score: 0, textColor: .gray)
                        }
                        
                        if let genres = trackerMedia.genres {
                            Text(genres.map { $0.name }.joined(separator: ", "))
                        } else {
                            Text("No genres")
                        }
                        
                        Text(trackerMedia.releasedDate ?? Date.now, format: .dateTime.year().month())
                            .font(.callout)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        //                    Text(props.movie.overview)
                        //                        .foregroundColor(.secondary)
                        //                        .lineLimit(3)
                        //                        .truncationMode(.tail)
                        
                    }
                    //                .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(12)
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(6)
                Button {
                    discardAction()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white, .red)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(12)
            .onChange(of: self.trackerMedia) { _, _ in
                if let posterURL = trackerMedia.posterURL {
                    
//                    do {
//                        posterImage = try await ImageLoaderS.generate(from: posterURL)
//                    } catch {
//                        print("poster URL is nil")
//                    }
                    posterImage = ImageService.shared.posterURL(for: posterURL)
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatusEditor.TrackerMediaView(media: TrackerMedia(id: 12345, title: "Napoleon", genres: [.init(id: 1, name: "Drama"), .init(id: 2, name: "History")], releasedDate: Date.now, voteAverage: 6.4, mediaType: .movie)) {
        print("Close view")
    }
}
