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
    @Environment(\.locale) private var locale

    let date: Date
    let iconName: String?
    let applicationName: String?
    let applicationURL: URL?
    
    private var formattedDate: String {
        let str = date.formatted(.dateTime.year().month().day().locale(locale))
        return str
    }
    
    private var formattedTime: String {
        let str = date.formatted(.dateTime.hour().minute().locale(locale))
        return str
    }

    var body: some View {
        HStack {
            Text("\(formattedDate) · \(formattedTime)", bundle: .module)
//            Text(date, style: .date)
//            Text(date, style: .time)
            if let iconName {
                Text("·", bundle: .module)
                Image(systemName: iconName)
                  .accessibilityHidden(true)
            }
          Spacer()
          if let name = applicationName, let url = applicationURL {
            Button {
              openURL(url)
            } label: {
                Text("\(name)", bundle: .module
                )
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
    StatusRowHistory(status: .placeholder())
}

#Preview("my", traits: .sizeThatFitsLayout) {
    StatusRowHistory(status: .placeholder())
        .environment(\.locale, .init(identifier: "my"))
}
