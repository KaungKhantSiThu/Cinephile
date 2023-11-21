//
//  TimelineView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 05/11/2023.
//

import SwiftUI
import TMDb

struct TimelineView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 30)!, .foregroundColor: UIColor.red]
        }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0...5, id: \.self) { _ in
                    PostView()
                    Divider()
                }
            }
            .navigationTitle(Text("Cinephile"))
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                print("refreshed")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("search")
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(.red)
                    }

                }
            }
        }
    }
}

#Preview {
    TimelineView()
}
