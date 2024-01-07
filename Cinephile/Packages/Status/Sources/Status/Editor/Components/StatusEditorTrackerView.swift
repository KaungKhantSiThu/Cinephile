//
//  StatusEditorTrackerView.swift
//
//
//  Created by Kaung Khant Si Thu on 03/01/2024.
//

import SwiftUI
import TMDb
import Environment
import CinephileUI

@MainActor
struct StatusEditorTrackerView: View {
    @Environment(Theme.self) private var theme
//    @Environment(CurrentInstance.self) private var currentInstance

    var viewModel: StatusEditorViewModel

//    @Binding var showTracker: Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    StatusEditorTrackerView()
//        .environment(Theme.shared)
//}
