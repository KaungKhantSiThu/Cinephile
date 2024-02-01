//
//  MediaStatus.swift
//
//
//  Created by Kaung Khant Si Thu on 31/01/2024.
//

import SwiftUI
import MediaClient

struct MediaStatus: View {
    let status: Status
    var body: some View {
        Text(status.id)
            .foregroundStyle(status.color == .yellow ? .black : .white)
            .padding(10)
            .background(status.color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack {
        ForEach(Status.allCases) {
            MediaStatus(status: $0)
        }
    }
}
