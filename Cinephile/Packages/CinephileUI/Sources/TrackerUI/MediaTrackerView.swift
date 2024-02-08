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
    @State private var viewModel = MediaTrackerViewModel()
    public init() {}
    
    public var body: some View {
        ScrollView {
            Picker("Movie Watchlist Picker", selection: $viewModel.selectedTab) {
                ForEach(MediaTrackerViewModel.Tab.allCases) { tab in
                    Text(tab.name)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(20)
                
            switch viewModel.selectedTab {
            case .watchlist:
                Text("Watchlist")
            case .watched:
                Text("Watched")
            }
        }
        .navigationTitle("Tracker")
    }
}

#Preview {
    NavigationStack {
        MediaTrackerView()
            .environment(NetworkManager())
    }
}


