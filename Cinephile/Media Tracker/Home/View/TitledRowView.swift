//
//  TitledRowView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 29/11/2023.
//

import SwiftUI

struct TitledRowView<Content: View>: View {
    let title: String
    let subtitle: String?
    var content: Content
    
    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            content
        }
    }
}

#Preview {
    TitledRowView(title: "Title", subtitle: "Subtitle") {
        EmptyView()
    }
}
