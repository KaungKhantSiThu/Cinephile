//
//  InfoRow.swift
//
//
//  Created by Kaung Khant Si Thu on 04/02/2024.
//

import SwiftUI

struct InfoRow: View {
    let genres = ["Action", "Drama", "Comedy", "Sci-fi"]
    var body: some View {
        FlowLayout {
            ForEach(genres, id: \.self) {
                Text($0)
                    .padding(10)
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 10.0))
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    InfoRow()
        .padding()
}
