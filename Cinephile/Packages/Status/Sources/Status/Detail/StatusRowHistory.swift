//
//  StatusRowHistory.swift
//  
//
//  Created by Kaung Khant Si Thu on 29/12/2023.
//

import SwiftUI
import Models

struct StatusRowHistory: View {
    @Environment(\.openURL) private var openURL

    let date: Date
    let iconName: String?
    let applicationName: String?
    let applicationURL: URL?
    var formattedDate: String {
        return date.formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedTime: String {
        return date.formatted(date: .omitted, time: .shortened)
    }
    var body: some View {
        HStack {
            Text(date, style: .date)
            Text(date, style: .time)
            if let iconName {
                Text("·")
                Image(systemName: iconName)
                  .accessibilityHidden(true)
            }
          Spacer()
          if let name = applicationName, let url = applicationURL {
            Button {
              openURL(url)
            } label: {
              Text(name)
                .underline()
            }
            .buttonStyle(.plain)
          }
        }
        .font(.scaledCaption)
        .foregroundStyle(.secondary)
    }
}

extension StatusRowHistory {
    init(status: Status) {
        self.date = status.createdAt.asDate
        self.iconName = status.visibility.iconName
        self.applicationName = status.application?.name
        self.applicationURL = status.application?.website
    }
    
    init(editedAt date: Date) {
        self.date = date
        self.iconName = nil
        self.applicationName = nil
        self.applicationURL = nil
    }
}

#Preview("en", traits: .sizeThatFitsLayout) {
    StatusRowHistory(status: .preview)
}

#Preview("my", traits: .sizeThatFitsLayout) {
    StatusRowHistory(status: .preview)
        .environment(\.locale, .init(identifier: "my"))
}
