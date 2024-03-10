//
//  TagsRowView.swift
//
//
//  Created by Kaung Khant Si Thu on 09/03/2024.
//

import SwiftUI
import Environment
import Models

public struct TagsRowView: View {
    @Environment(RouterPath.self) private var routerPath
    
    let tag: Tag
        
    public init(tag: Tag) {
        self.tag = tag
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
              Text("#\(tag.name)")
                .font(.scaledHeadline)
              Text("\(tag.totalUses) posts from \(tag.totalAccounts) participants")
                .font(.scaledFootnote)
                .foregroundStyle(.secondary)
            }
            Spacer()
            TagChartView(tag: tag)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            routerPath.navigate(to: .hashTag(tag: tag.name, accountId: nil))
        }
    }
}
