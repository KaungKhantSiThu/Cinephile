//
//  MediaTrackerView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 30/10/2023.
//

import SwiftUI
import MediaClient

public struct MediaTrackerView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("View for Watchlist")
        }
        .navigationTitle("Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MediaTrackerView()
}


