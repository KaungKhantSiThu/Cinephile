//
//  TimelineTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI

struct TimelineTab: View {
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    var body: some View {
        TimelineView()
    }
}

//#Preview {
//    TimelineTab()
//}
