//
//  MediaTrackerViewModel.swift
//
//
//  Created by Kaung Khant Si Thu on 07/02/2024.
//

import Foundation

@Observable
class MediaTrackerViewModel {
    enum Tab: String, CaseIterable, Identifiable {
        case watchlist, watched
        
        var id: String { name }
        var name: String {
            switch self {
            case .watchlist:
                "Watchlist"
            case .watched:
                "Watched"
            }
        }
    }
    
    var selectedTab: Tab = .watchlist
    
    
}
