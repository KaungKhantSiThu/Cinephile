//
//  SearchViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.


import TMDb
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var medias: [Media] = []
    @Published var searchText: String = ""
    
//    {
//        didSet {
//            Task {
//                if !searchText.isEmpty {
//                    await self.searchMovies(using: searchText)
//                } else {
//                    self.remove()
//                }
//            }
//        }
//    }

    private let service: SearchService
    
    init() {
        self.service = SearchService()
    }
    
    @MainActor
    func searchMovies(using searchText: String) async {
        do {
            self.medias = try await service.searchAll(query: searchText).results
            print(medias.count)
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
    
    func performSearch(using searchText: String) {
        Task {
            if !searchText.isEmpty {
                await self.searchMovies(using: searchText)
            } else {
                self.remove()
            }
        }
    }

    
    func remove() {
        self.medias.removeAll()
    }
}
