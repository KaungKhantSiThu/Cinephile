//
//  TrackerTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 06/12/2023.
//

import SwiftUI

@MainActor
struct TrackerTab: View {
    @State private var routerPath = RouterPath()
    var body: some View {
        NavigationStack(path: $routerPath.path) { 
            DiscoverMediaView()
                .withAppRouter()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            routerPath.navigate(to: .trackerSearchView)
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .environment(routerPath)
            
        }
    }
}

#Preview {
    TrackerTab()
        .environment(RouterPath())
}
