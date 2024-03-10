//
//  GenresRowView.swift
//
//
//  Created by Kaung Khant Si Thu on 10/03/2024.
//

import SwiftUI
import Environment
import Models

public struct GenresRowView: View {
    @Environment(RouterPath.self) private var routerPath
    
    let genre: Genre
        
    public init(genre: Genre) {
        self.genre = genre
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(genre.name)
                    .font(.scaledHeadline)
                Text("\(genre.participantCount) users is following")
                    .font(.scaledFootnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                routerPath.navigate(to: .genre(id: genre.genreId, title: genre.name))
            } label: {
                Image(systemName: "chevron.right")
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            routerPath.navigate(to: .genre(id: genre.genreId, title: genre.name))
        }
    }
}
