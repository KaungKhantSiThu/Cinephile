//
//  CastView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import TMDb
import NukeUI

@MainActor
public struct CastView: View {
    let name: String
    let character: String
    let profilePath: URL?
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    
    public var body: some View {
        VStack(spacing: 20) {
            LazyImage(url: posterImage) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                        
                } else if state.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            .frame(height: 140)
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
 
            VStack(alignment: .leading) {
                Text(self.name)
                Text(self.character)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 100)
        }
        .padding(.leading, 20)
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: self.profilePath, width: 200)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

public extension CastView {
    init(castMember: CastMember) {
        self.name = castMember.name
        self.character = castMember.character
        self.profilePath = castMember.profilePath
    }
}

#Preview {
    CastView(name: "Tom", character: "Jerry", profilePath: nil)
}
