//
//  WatchProvidersView.swift
//
//
//  Created by Kaung Khant Si Thu on 13/01/2024.
//

import SwiftUI
import TMDb

struct WatchProvidersView: View {
    let providers: [WatchProvider]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(providers) { provider in
                    LogoImage(url: provider.logoPath)
                }
            }
        }
    }
}

#Preview {
    WatchProvidersView(providers: [
        .init(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
        ),
        .init(
            id: 9,
            name: "Amazon Prime Video",
            logoPath: URL(string: "/emthp39XA2YScoYL1p0sdbAH2WA.jpg")!
        )
    ])
}
