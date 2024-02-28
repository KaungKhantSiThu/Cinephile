import Environment
import Models
import SwiftUI

public struct TagRowView: View {
  @Environment(RouterPath.self) private var routerPath

  let tag: Tag

  public init(tag: Tag) {
    self.tag = tag
  }

  public var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("#\(tag.name)", bundle: .module)
          .font(.scaledHeadline)
          Text("design.tag.n-posts-from-n-participants \(tag.totalUses) \(tag.totalAccounts)", bundle: .module)
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
