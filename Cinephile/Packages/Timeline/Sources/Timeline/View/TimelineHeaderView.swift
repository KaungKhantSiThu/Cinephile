import CinephileUI
import SwiftUI

struct TimelineHeaderView<Content: View>: View {

  var content: () -> Content

  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      content()
      Spacer()
    }
    .listRowSeparator(.hidden)
    .listRowInsets(.init(top: 8,
                         leading: .layoutPadding,
                         bottom: 8,
                         trailing: .layoutPadding))
  }
}
