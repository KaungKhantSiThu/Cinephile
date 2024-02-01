//
//  CastView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import MediaClient
import NukeUI

@MainActor
public struct CastView: View {
    let name: String
    let character: String
    let profilePath: URL?
//    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PosterImage(url: ImageService.shared.posterURL(for: profilePath))
 
            VStack(alignment: .leading, spacing: 0) {
                Text(self.name)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.primary)
                
                Text(self.character)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 100)
        }
//        .task {
//            do {
//                posterImage = try await ImageLoaderS.generate(from: self.profilePath)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
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
