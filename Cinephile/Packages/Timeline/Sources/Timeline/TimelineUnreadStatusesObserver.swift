import Environment
import Foundation
import Models
import Observation
import SwiftUI
import CinephileUI

@MainActor
@Observable class TimelineUnreadStatusesObserver {
    var pendingStatusesCount: Int = 0
    
    var disableUpdate: Bool = false
    var scrollToIndex: ((Int) -> Void)?
    
    var isLoadingNewStatuses: Bool = false
    
    var pendingStatuses: [String] = [] {
        didSet {
            pendingStatusesCount = pendingStatuses.count
        }
    }
    
    func removeStatus(status: Status) {
        if !disableUpdate, let index = pendingStatuses.firstIndex(of: status.id) {
            pendingStatuses.removeSubrange(index ... (pendingStatuses.count - 1))
            //      HapticManager.shared.fireHaptic(.timeline)
        }
    }
    
    init() {}
}

struct TimelineUnreadStatusesView: View {
    @State var observer: TimelineUnreadStatusesObserver
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme

    var body: some View {
        if observer.pendingStatusesCount > 0 {
            Button {
                observer.scrollToIndex?(observer.pendingStatusesCount)
            } label: {
                if observer.isLoadingNewStatuses {
                    ProgressView()
                        .tint(theme.labelColor)
                }
                if observer.pendingStatusesCount > 0 {
                    Text("\(observer.pendingStatusesCount)")
                    // Accessibility: this results in a frame with a size of at least 44x44 at regular font size
                        .frame(minWidth: 16, minHeight: 16)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.labelColor)
                }
            }
//            .accessibilityLabel("accessibility.tabs.timeline.unread-posts.label-\(observer.pendingStatusesCount)")
//            .accessibilityHint("accessibility.tabs.timeline.unread-posts.hint")
            .buttonStyle(.borderedProminent)
            .background(.thinMaterial)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(theme.tintColor, lineWidth: 1)
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: preferences.pendingLocation)
        }
    }
}
