//
//  TMDB_TestApp.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import SwiftUI
import TMDb

@main
struct CinephileApp: App {
    
    init() {
        let tmdbConfiguration = TMDbConfiguration(apiKey: TMDB_API_Key)
        TMDb.configure(tmdbConfiguration)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
