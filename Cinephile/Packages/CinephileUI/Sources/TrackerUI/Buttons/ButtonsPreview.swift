//
//  ButtonsPreview.swift
//
//
//  Created by Kaung Khant Si Thu on 31/01/2024.
//

import SwiftUI

struct ButtonsPreview: View {
    @State private var isOn: Bool = false
    var body: some View {
        VStack {
            TrackerActionButton()
            
            Button {
                isOn.toggle()
            } label: {
                Label(isOn ? "Added" : "Watchlist", systemImage: isOn ? "checkmark.circle.fill" : "plus.circle.fill")
            }
            .foregroundStyle(isOn ? .white : .red)
            .tint(.red)
            .padding(EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 6))
            .font(.system(.title3, design: .rounded).bold())
            .padding(EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 6))
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red, lineWidth: isOn ? 0 : 2)
                .background(isOn ? .red : .clear)
                .cornerRadius(8))
            
            Button {
                
            } label: {
                Label("Watchlist", systemImage: "plus.circle.fill")
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
        }
    }
}

struct TrackerActionButton: View {
    @State private var isLoading = false
    @State private var loaded = false
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                try! await Task.sleep(nanoseconds: 1_000_000_000)
                isLoading = false
                loaded.toggle()
            }
            
        } label: {
            Label(loaded ? "Added" : "Watchlist", systemImage: loaded ? "checkmark.circle.fill" : "plus.circle.fill")
                .opacity(isLoading ? 0 : 1)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
        }
        .disabled(isLoading)
        .tint(.red)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ButtonsPreview()
}
