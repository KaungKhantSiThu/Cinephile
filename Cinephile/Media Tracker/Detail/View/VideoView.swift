//
//  VideoView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import AVKit

struct VideoView: View {
    let player = AVPlayer(url: URL(string: "https://www.youtube.com/watch?v=NxW_X4kzeus")!)
    let endMonitor = NotificationCenter.default.publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime)

    var body: some View {
        
        VStack(alignment: .leading) {
            VideoPlayer(player: player)
                .frame(width: 300, height: 200)
                .onAppear {
                    player.play()
                }
                .onReceive(endMonitor) { _ in
                    player.seek(to: .zero)
                    player.play()
                }
            
            Text("Footage: ChristianBodhi")
                .font(.headline)
        }
    }
}


#Preview {
    VideoView()
}
