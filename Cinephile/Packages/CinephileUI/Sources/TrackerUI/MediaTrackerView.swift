//
//  MediaTrackerView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 30/10/2023.
//

import SwiftUI
import MediaClient
import Environment

public struct MediaTrackerView: View {
    @Environment(NetworkManager.self) private var networkManager: NetworkManager
    public init() {}
    
    public var body: some View {
        VStack {
            if networkManager.isConnected {
                Text("View for Watchlist")
            } else {
                ContentUnavailableView("No connection", systemImage: "wifi.slash", description: Text("Connect to the internet and try again."))
            }
        }
        .navigationTitle("Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MediaTrackerView()
}


