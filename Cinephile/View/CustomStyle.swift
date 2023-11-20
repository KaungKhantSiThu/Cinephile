//
//  CustomStyle.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 04/11/2023.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .font(.system(.title3, design: .rounded).bold())
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .background {
            Capsule()
                .foregroundStyle(.gray.opacity(0.2))
        }
    }
}


#Preview {
    Button {
            // Delete
        } label: {
            Label("Kelvin Gao", systemImage: "plus.circle.fill")
        }
        .buttonStyle(CustomButtonStyle())
}
