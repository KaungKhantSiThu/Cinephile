//
//  StarView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 04/11/2023.
//

import SwiftUI

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.orange)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

#Preview {
    StarsView(rating: 3.6, maxRating: 5)
}
