//
//  VideoView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import WebKit
import AVKit
import MediaClient
import YouTubePlayerKit

@MainActor
public struct VideoView: View {
    let name: String
    let id: String
    
    @State private var youtubePlayer: YouTubePlayer
    
//    @State private var youtubePlayer: YouTubePlayer

    public var body: some View {
        VStack(alignment: .leading) {
            YouTubeView(videoId: id)
                
//            YouTubePlayerView(self.youtubePlayer) 
//            { state in
//                switch state {
//                case .idle:
//                    ProgressView()
//                case .ready:
//                    EmptyView()
//                case .error(_):
//                    Text(verbatim: "YouTube player couldn't be loaded")
//                }
//            }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(width: 320, height: 180)
            Text(name)
                .font(.headline)
                .lineLimit(2)
                .frame(width: 300)
        }
    }
    

    init(metaData: VideoMetadata) {
        self.name = metaData.name
        self.id = metaData.id
        self._youtubePlayer = State(wrappedValue: .init(source: .video(id: metaData.id)))
    }
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
        self._youtubePlayer = State(wrappedValue: .init(source: .video(id: id)))
    }
}

public struct YouTubeView: UIViewRepresentable {
    let videoId: String
    
    public func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}

#Preview {
    VideoView(name: "London Underground กว่าศตวรรษของโลโก้ ที่มีคนก็อบมากที่สุด! | Logo Tales EP.3", id: "R1RtdU3y7JY")
}
