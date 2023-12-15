//
//  CastView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

@MainActor
struct CastView: View {
    let cast: CastMember
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        VStack(spacing: 20) {
            WebImage(url: posterImage)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 140)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            VStack(alignment: .leading) {
                Text(cast.name)
                Text(cast.character)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 100)
        }
        .padding(.leading, 20)
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: cast.profilePath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

#Preview {
    CastView(cast: Array<CastMember>.preview[0])
}
