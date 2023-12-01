//
//  VideoView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import WebKit
import AVKit
import TMDb

struct VideoView: View {
    let metaData: VideoMetadata

    var body: some View {
        
        VStack(alignment: .leading) {
            YouTubeView(videoId: metaData.key)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(width: 320, height: 180)
            
            Text(metaData.name)
                .font(.headline)
                .frame(width: 300)
        }
    }
}

struct YouTubeView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}


#Preview {
    VideoView(metaData: .preview)
}
