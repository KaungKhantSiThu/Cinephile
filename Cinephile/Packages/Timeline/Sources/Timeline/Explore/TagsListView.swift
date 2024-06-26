import CinephileUI
import Models
import SwiftUI
import Account

public struct TagsListView: View {
    
    let tags: [Tag]
    
    
    public init(tags: [Tag]) {
        self.tags = tags
    }
    
    public var body: some View {
        List {
            ForEach(tags) { tag in
                TagsRowView(tag: tag)
                    .padding(.vertical, 4)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .navigationTitle("Tags")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TagsListView(tags: .preview)
        .environment(Theme.shared)
}
