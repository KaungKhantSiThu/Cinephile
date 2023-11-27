//
//  VideosRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 27/11/2023.
//

import SwiftUI
import TMDb

struct VideosRowView: View {
    let videos: [VideoMetadata]
    var body: some View {
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
        .padding()
    }
}

#Preview {
    VideosRowView(videos: .preview)
}