import Models
import SwiftUI
import UIKit

public extension StatusEditorViewModel {
    
  enum Mode {
    case replyTo(status: Models.Status)
    case new(visibility: Models.Visibility)
    case edit(status: Models.Status)
    case quote(status: Models.Status)
    case mention(account: Account, visibility: Models.Visibility)
    case shareExtension(items: [NSItemProvider])

    var isInShareExtension: Bool {
      switch self {
      case .shareExtension:
        true
      default:
        false
      }
    }

    var isEditing: Bool {
      switch self {
      case .edit:
        true
      default:
        false
      }
    }

    var replyToStatus: Status? {
      switch self {
      case let .replyTo(status):
        status
      default:
        nil
      }
    }

    var title: LocalizedStringKey {
      switch self {
      case .new, .mention, .shareExtension:
        "New"
      case .edit:
        "Edit"
      case let .replyTo(status):
        "Reply-\(status.reblog?.account.displayNameWithoutEmojis ?? status.account.displayNameWithoutEmojis)"
      case let .quote(status):
        "Quote-\(status.reblog?.account.displayNameWithoutEmojis ?? status.account.displayNameWithoutEmojis)"
      }
    }
  }
}
