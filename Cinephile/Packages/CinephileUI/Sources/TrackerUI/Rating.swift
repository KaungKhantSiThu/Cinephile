//
//  Rating.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 03/12/2023.
//

import SwiftUI

@MainActor
public struct Rating: View {
    let voteCount: Int
    let voteAverage: Double
    
    public init(voteCount: Int, voteAverage: Double) {
        self.voteCount = voteCount
        self.voteAverage = voteAverage
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(voteCount, format: .number.notation(.compactName))
                Text("RATINGS")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            
            HStack {
                Image("tmdb_logo", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                Text(voteAverage, format: .number.precision(.fractionLength(1)))
                    .font(.title)
                    .fontWeight(.bold)
            }
//            StarsView(rating: voteAverage / 2 , maxRating: 5)
//                .frame(width: 80)
//                .padding(.top, -10)
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Rating(voteCount: 1234, voteAverage: 7.9)
}
