//
//  PosterImage.swift
//
//
//  Created by Kaung Khant Si Thu on 18/12/2023.
//

import SwiftUI
import NukeUI

@MainActor
public struct PosterImage: View {
    let url: URL
    let height: CGFloat
    let roundedCorner:  Bool
    
    public init(url: URL, height: CGFloat = 150, roundedCorner: Bool = true) {
        self.url = url
        self.height = height
        self.roundedCorner = roundedCorner
    }
    
    public var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    
                    
            } else if state.error != nil {
                Color.red
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .frame(width: height * 0.7, height: height)
        .clipShape(
            RoundedRectangle(cornerRadius: roundedCorner ? 10 : 0)
        )
    }
}




#Preview {
    PosterImage(url: URL(string: "https://picsum.photos/200/300")!, height: 300)
}
