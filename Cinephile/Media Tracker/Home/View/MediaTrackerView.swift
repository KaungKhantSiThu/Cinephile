//
//  DiscoverMoviesView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 30/10/2023.
//

import SwiftUI
import TMDb

struct MediaTrackerView: View {
    @State private var selectedPage: Page = .watchlist
    var body: some View {
        VStack {
            Picker("Page", selection: $selectedPage) {
                ForEach(Page.allCases) {
                    Text(String(describing: $0))
                }
            }
            .pickerStyle(.segmented)
            
            switch selectedPage {
            case .watchlist:
                VStack {
                    ForEach(1...5, id: \.self) { _ in
                        MovieRow(movie: .preview)
                    }
                }
                
            case .upcoming:
                VStack {
                    ForEach(1...5, id: \.self) { _ in
                        MovieRow(movie: .preview)
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension MediaTrackerView {
    
    enum Page: CustomStringConvertible, Identifiable, CaseIterable {
        case watchlist
        case upcoming
        
        var description: String {
            switch self {
            case .watchlist:
                "Watch List"
            case .upcoming:
                "Upcoming"
            }
        }
        
        var id: Self { self }
    }
}

#Preview {
    MediaTrackerView()
}


