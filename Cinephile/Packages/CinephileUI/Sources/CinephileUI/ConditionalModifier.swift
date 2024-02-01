//
//  File.swift
//
//
//  Created by Kaung Khant Si Thu on 29/01/2024.
//

import SwiftUI

public extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
