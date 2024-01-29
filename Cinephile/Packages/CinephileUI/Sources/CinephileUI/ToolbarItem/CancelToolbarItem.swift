//
//  SwiftUIView.swift
//
//
//  Created by Kaung Khant Si Thu on 29/01/2024.
//

import SwiftUI

public struct CancelToolbarItem: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    public init() { }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("action.cancel", role: .cancel, action: { dismiss() })
                .keyboardShortcut(.cancelAction)
        }
    }
}
