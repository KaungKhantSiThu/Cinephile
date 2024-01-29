//
//  StatusEntertainmentView.swift
//
//
//  Created by Kaung Khant Si Thu on 21/01/2024.
//

import SwiftUI
import Models
import TrackerUI

@MainActor
public struct StatusEntertainmentView: View {
//    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    
    @State private var viewModel: StatusEntertainmentViewModel
    
    public init(entertainment: Entertainment) {
        _viewModel = State(wrappedValue: StatusEntertainmentViewModel(entertainment: entertainment))
    }
    
    public var body: some View {
        ZStack {
            if viewModel.isTrackerMediaLoading {
                ProgressView()
            }
            
            if let trackerMedia = viewModel.trackerMedia, let posterImage = viewModel.posterImage {
                
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
                        
                        if let genres = trackerMedia.genres  {
                            if !genres.isEmpty {
                                Text(genres.map { $0.name }.joined(separator: ", "))
                                    .lineLimit(2)
                            }
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
                
//                .task(id: trackerMedia) {
//                    if let posterURL = trackerMedia.posterURL {
//                        do {
//                            posterImage = try await ImageLoaderS.generate(from: posterURL)
//                        } catch {
//                            print("poster URL is nil")
//                        }
//                    }
//                }
            }
        }
        .task {
            await viewModel.fetchMedia()
        }
    }
}

#Preview {
    return StatusEntertainmentView(entertainment: Status.placeholder().entertainments[1])
}
