import CinephileUI
import Environment
import Models
import SwiftUI
import Networking

struct StatusRowContentView: View {
    @Environment(\.redactionReasons) private var reasons
    @Environment(\.isCompact) private var isCompact
    @Environment(\.isStatusFocused) private var isFocused
    @Environment(RouterPath.self) private var routerPath
    @Environment(Theme.self) private var theme
    
    var viewModel: StatusRowViewModel
    
    var body: some View {
        if !viewModel.finalStatus.spoilerText.asRawText.isEmpty {
            @Bindable var viewModel = viewModel
            StatusRowSpoilerView(status: viewModel.finalStatus, displaySpoiler: $viewModel.displaySpoiler)
        }
        
        if !viewModel.displaySpoiler {
            StatusRowTextView(viewModel: viewModel)
            //      StatusRowTranslateView(viewModel: viewModel)
            if let poll = viewModel.finalStatus.poll {
                StatusPollView(poll: poll, status: viewModel.finalStatus)
            }
            
            if let entertainment = viewModel.finalStatus.entertainments.first, !isCompact {
                StatusEntertainmentView(entertainment: entertainment)
                    .padding(.top, 10)
                    .onTapGesture {
                        switch entertainment.mediaType {
                        case .movie:
                            routerPath.navigate(to: .media(id: entertainment.id, title: ""))
                        case .tvSeries:
                            routerPath.navigate(to: .seriesDetail(id: Int(entertainment.mediaId) ?? entertainment.id))
                        }
                    }
            }
            
            if !reasons.contains(.placeholder),
               !isCompact,
               viewModel.isEmbedLoading || viewModel.embeddedStatus != nil {
                StatusEmbeddedView(status: viewModel.embeddedStatus ?? Status.placeholder(),
                                   client: viewModel.client,
                                   routerPath: viewModel.routerPath)
                .fixedSize(horizontal: false, vertical: true)
                .redacted(reason: viewModel.isEmbedLoading ? .placeholder : [])
                //          .shimmering(active: viewModel.isEmbedLoading)
                .transition(.opacity)
            }
            
            if !viewModel.finalStatus.mediaAttachments.isEmpty {
                HStack {
                    StatusRowMediaPreviewView(attachments: viewModel.finalStatus.mediaAttachments,
                                              sensitive: viewModel.finalStatus.sensitive)
                    if theme.statusDisplayStyle == .compact {
                        Spacer()
                    }
                }
                .accessibilityHidden(isFocused == false)
                .padding(.vertical, 4)
            }
            
            if let card = viewModel.finalStatus.card,
               !viewModel.isEmbedLoading,
               !isCompact,
               theme.statusDisplayStyle != .compact,
               viewModel.finalStatus.mediaAttachments.isEmpty
            {
                StatusRowCardView(card: card)
            }
        }
    }
}

#Preview {
    StatusRowContentView(
        viewModel: .init(
            status: .placeholder(),
            client: Client(server: "localhost"),
            routerPath: RouterPath())
    )
    .environment(Theme.shared)
    .environment(RouterPath())
    .environment(\.isStatusFocused, true)
}
