//
//  AppRouter.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation
import SwiftUI

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case let .movieDetail(id):
                MovieDetailView(id: id)
            case let .seriesDetail(id):
                SeriesDetailView(id: id)
            case .trackerSearchView:
                SearchView()
            }
        }
    }
}
