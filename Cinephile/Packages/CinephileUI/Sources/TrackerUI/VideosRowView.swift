//
//  VideosRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 27/11/2023.
//

import SwiftUI
import MediaClient


@MainActor
public struct VideosRowView: View {
    let videos: [VideoMetadata]
    
    public init(videos: [VideoMetadata]) {
        self.videos = videos
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Videos")
                .font(.title)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(videos) { video in
                        VideoView(metaData: video)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding([.leading, .trailing], 20)
    }
}

//#Preview {
//    VideosRowView(videos: .preview)
//}
