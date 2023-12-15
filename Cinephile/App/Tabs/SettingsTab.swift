//
//  SettingsTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI

struct SettingsTab: View {
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    SettingsTab()
//}
