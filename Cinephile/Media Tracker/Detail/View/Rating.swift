//
//  Rating.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 03/12/2023.
//

import SwiftUI

struct Rating: View {
    let voteCount: Int
    let voteAverage: Double
    var body: some View {
        VStack {
            HStack {
                Text(voteCount, format: .number)
                Text("RATINGS")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            
            HStack {
                Image("tmdb_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                Text(voteAverage, format: .number.precision(.fractionLength(1)))
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            StarsView(rating: voteAverage / 2 , maxRating: 5)
                .frame(width: 80)
                .padding(.top, -10)
        }
    }
}

#Preview {
    Rating(voteCount: 1234, voteAverage: 7.9)
}
