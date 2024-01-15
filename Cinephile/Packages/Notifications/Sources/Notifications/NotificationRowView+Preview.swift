//
//  SwiftUIView.swift
//
//
//  Created by Kaung Khant Si Thu on 14/01/2024.
//

import SwiftUI
import Models
import CinephileUI

struct NotificationContainer: View {
    let notifications: [ConsolidatedNotification]
    
    var body: some View {
        Grid {
            ForEach(notifications) { notification in
                GridRow {
                    makeAvatarView(notification: notification)
                    
                    Text(notification.type.rawValue)
                        .gridColumnAlignment(.leading)
                }
            }
        }
        
    }
    
    private func makeAvatarView(notification: ConsolidatedNotification) -> some View {
        ZStack(alignment: .bottomTrailing) {
            AvatarView(notification.accounts[0].avatar)
            makeNotificationIconView(notification: notification)
                .offset(x: 8, y: 8)
        }
        .contentShape(Rectangle())
    }
    
    private func makeNotificationIconView(notification: ConsolidatedNotification) -> some View {
        ZStack(alignment: .center) {
            Circle()
                .strokeBorder(Color.white, lineWidth: 1)
                .background(
                    Circle()
                        .foregroundColor(notification.type.tintColor(isPrivate: notification.status?.visibility == .direct))
                )
                .backgroundStyle(notification.type.tintColor(isPrivate: notification.status?.visibility == .direct).gradient)
                .foregroundStyle(
                            .white.shadow(.drop(radius: 1, y: 1.5))
                        )
                .frame(width: 24, height: 24)
            
            notification.type.icon(isPrivate: notification.status?.visibility == .direct)
                .resizable()
                
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
            
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    NotificationContainer(notifications: ConsolidatedNotification.placeholders())
}
