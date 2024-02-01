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
    
    public init(url: URL, height: CGFloat = 140, roundedCorner: Bool = true) {
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
                
                Color.gray
                    .overlay {
                        Image(systemName: "questionmark")
                            .foregroundStyle(.foreground)
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 50))
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: height * 0.67, height: height)

            } else {
                Color.gray
                    .overlay {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: height * 0.67, height: height)

            }
        }
        .frame(width: height * 0.67, height: height)
        .clipShape(
            RoundedRectangle(cornerRadius: roundedCorner ? 10 : 0)
        )
    }
}




#Preview(traits: .sizeThatFitsLayout) {
    PosterImage(url: URL(string: "https://picsum.photos/200/300")!, height: 300)
}
