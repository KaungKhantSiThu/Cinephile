//
//  GenreLabelStyle.swift
//
//
//  Created by Kaung Khant Si Thu on 29/01/2024.
//

import SwiftUI

extension LabelStyle where Self == GenreLabelStyle {
    static var genre: GenreLabelStyle {
        GenreLabelStyle()
    }
}

struct GenreLabelStyle: LabelStyle {
    @ScaledMetric(relativeTo: .footnote) private var iconWidth = 14.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(.secondary)
                .frame(width: iconWidth)
            configuration.title
        }
        .padding(6)
        .background(in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        .background(Color(uiColor: .quaternarySystemFill))
        .font(.caption)
    }
}

