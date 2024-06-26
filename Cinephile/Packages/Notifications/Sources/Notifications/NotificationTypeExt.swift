import CinephileUI
import Models
import SwiftUI

extension Models.Notification.NotificationType {
  public func label(count: Int) -> LocalizedStringKey {
    switch self {
    case .status:
      "notifications.label.status"
    case .mention:
      ""
    case .reblog:
      "notifications.label.reblog \(count)"
    case .follow:
      "notifications.label.follow \(count)"
    case .follow_request:
      "notifications.label.follow-request"
    case .favourite:
      "notifications.label.favorite \(count)"
    case .poll:
      "notifications.label.poll"
    case .update:
      "notifications.label.update"
    }
  }

  public func notificationKey() -> String {
    switch self {
    case .status:
      "notifications.label.status.push"
    case .mention:
      ""
    case .reblog:
      "notifications.label.reblog.push"
    case .follow:
      "notifications.label.follow.push"
    case .follow_request:
      "notifications.label.follow-request.push"
    case .favourite:
      "notifications.label.favorite.push"
    case .poll:
      "notifications.label.poll.push"
    case .update:
      "notifications.label.update.push"
    }
  }

  func icon(isPrivate: Bool) -> Image {
    if isPrivate {
      return Image(systemName: "tray.fill")
    }
    switch self {
    case .status:
      return Image(systemName: "pencil")
    case .mention:
      return Image(systemName: "at")
    case .reblog:
      return Image(systemName: "arrow.left.arrow.right")
    case .follow, .follow_request:
      return Image(systemName: "person.fill.badge.plus")
    case .favourite:
      return Image(systemName: "heart.fill")
    case .poll:
      return Image(systemName: "chart.bar.fill")
    case .update:
      return Image(systemName: "pencil.line")
    }
  }

  func tintColor(isPrivate: Bool) -> Color {
    if isPrivate {
      return Color.black
    }
    switch self {
    case .status, .mention, .update, .poll:
        return Color.orange
    case .reblog:
      return Color.green
    case .follow, .follow_request:
        return Color.blue
    case .favourite:
      return Color.red
    }
  }

  func menuTitle() -> LocalizedStringKey {
    switch self {
    case .status:
      "notifications.menu-title.status"
    case .mention:
      "notifications.menu-title.mention"
    case .reblog:
      "notifications.menu-title.reblog"
    case .follow:
      "notifications.menu-title.follow"
    case .follow_request:
      "notifications.menu-title.follow-request"
    case .favourite:
      "notifications.menu-title.favorite"
    case .poll:
      "notifications.menu-title.poll"
    case .update:
      "notifications.menu-title.update"
    }
  }
}
