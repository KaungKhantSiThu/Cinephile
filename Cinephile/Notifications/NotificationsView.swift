//
//  NotificationViews.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 05/11/2023.
//

import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [Notification] = Notification.mock
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 40)!]
        }
    
    var body: some View {
        List(notifications) { item in
            HStack(spacing: 20) {
                Image(systemName: item.category == .release ? "film" : "arrow.2.squarepath")
                    .background(in: Circle().inset(by: -8))
                    .backgroundStyle(item.category == .release ? Color.red.gradient : Color.green.gradient)
                    .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                    
                VStack(alignment: .leading) {
                    Text(item.message)
                        .font(.title3)
                    Text(item.date, format: .dateTime)
                        .font(.subheadline)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    print("delete")
                } label: {
                    Label("Remove", systemImage: "trash.fill")
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    NotificationsView()
}
