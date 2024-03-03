import CinephileUI
import EmojiText
import Environment
import Foundation
import Models
import Networking

import SwiftUI

@MainActor
public struct StatusRowView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.isInCaptureMode) private var isInCaptureMode: Bool
    @Environment(\.redactionReasons) private var reasons
    @Environment(\.isCompact) private var isCompact: Bool
    @Environment(\.accessibilityVoiceOverEnabled) private var accessibilityVoiceOverEnabled
    @Environment(\.isStatusFocused) private var isFocused
    @Environment(\.indentationLevel) private var indentationLevel
    @Environment(\.isHomeTimeline) private var isHomeTimeline
    
    @Environment(QuickLook.self) private var quickLook
    @Environment(Theme.self) private var theme
    
    @State private var viewModel: StatusRowViewModel
    @State private var showSelectableText: Bool = false
    
    public enum Context { case timeline, detail }
    
    private let context: Context
    
    public init(viewModel: StatusRowViewModel, context: Context = .timeline) {
        self._viewModel = .init(initialValue: viewModel)
        self.context = context
    }
    
    var contextMenu: some View {
        StatusRowContextMenu(viewModel: viewModel, showTextForSelection: $showSelectableText)
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            //            if !isCompact {
            //                HStack(spacing: 3) {
            //                    ForEach(0 ..< indentationLevel, id: \.self) { level in
            //                        Rectangle()
            //                            .fill(theme.tintColor)
            //                            .frame(width: 2)
            //                            .accessibilityHidden(true)
            //                            .opacity((indentationLevel == level + 1) ? 1 : 0.15)
            //                    }
            //                }
            //                if indentationLevel > 0 {
            //                    Spacer(minLength: 8)
            //                }
            //            }
            
            VStack(alignment: .leading) {
                if viewModel.isFiltered, let filter = viewModel.filter {
                    switch filter.filter.filterAction {
                    case .warn:
                        makeFilterView(filter: filter.filter)
                    case .hide:
                        EmptyView()
                    }
                } else {
                    if !isCompact && context != .detail {
                        Group {
                            StatusRowGenreView(viewModel: viewModel)
                            StatusRowTagView(viewModel: viewModel)
                            StatusRowReblogView(viewModel: viewModel)
                            StatusRowReplyView(viewModel: viewModel)
                        }
                        //                        .padding(.leading, AvatarView.FrameConfiguration.status.width + .statusColumnsSpacing)
                    }
                    
                    HStack(alignment: .top, spacing: .statusColumnsSpacing) {
                        if !isCompact,
                           theme.avatarPosition == .leading
                        {
                            AvatarView(viewModel.finalStatus.account.avatar)
                                .onTapGesture {
                                    viewModel.navigateToAccountDetail(account: viewModel.finalStatus.account)
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: .statusComponentSpacing) {
                            if !isCompact {
                                StatusRowHeaderView(viewModel: viewModel)
                            }
                            
                            StatusRowContentView(viewModel: viewModel)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    guard !isFocused else { return }
                                    viewModel.navigateToDetail()
                                }
                            
                            if !reasons.contains(.placeholder), viewModel.showActions, isFocused || theme.statusActionsDisplay != .none, !isInCaptureMode {
                                StatusRowActionsView(viewModel: viewModel)
                                    .padding(.top, 8)
                                    .tint(isFocused ? theme.tintColor : .gray)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        guard !isFocused else { return }
                                        viewModel.navigateToDetail()
                                    }
                            }
                            
                            if isFocused, !isCompact {
                                StatusRowDetailView(viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: isCompact ? 6 : 12, leading: 0, bottom: isFocused ? 12 : 6, trailing: 0))
        }
        .onAppear {
            viewModel.markSeen()
            if !reasons.contains(.placeholder) {
                if !isCompact, viewModel.embeddedStatus == nil {
                    Task {
                        await viewModel.loadEmbeddedStatus()
                    }
                }
            }
        }
        .contextMenu {
            contextMenu
                .onAppear {
                    Task {
                        await viewModel.loadAuthorRelationship()
                    }
                }
        }
        .swipeActions(edge: .trailing) {
            // The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
            if !isCompact, accessibilityVoiceOverEnabled == false {
                StatusRowSwipeView(viewModel: viewModel, mode: .trailing)
            }
        }
        .swipeActions(edge: .leading) {
            // The actions associated with the swipes are exposed as custom accessibility actions and there is no way to remove them.
            if !isCompact, accessibilityVoiceOverEnabled == false {
                StatusRowSwipeView(viewModel: viewModel, mode: .leading)
            }
        }
        //    .listRowBackground(viewModel.highlightRowColor)
        .listRowInsets(.init(top: 12,
                             leading: .layoutPadding,
                             bottom: 12,
                             trailing: .layoutPadding))
        .background {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !isFocused else { return }
                    viewModel.navigateToDetail()
                }
        }
        .overlay {
            if viewModel.isLoadingRemoteContent {
                remoteContentLoadingView
            }
        }
        .alert(isPresented: $viewModel.showDeleteAlert, content: {
            Alert(
                title: Text("status.action.delete.confirm.title", bundle: .module),
                message: Text("status.action.delete.confirm.message", bundle: .module),
                primaryButton: .destructive(
                    Text("status.action.delete", bundle: .module))
                {
                    Task {
                        await viewModel.delete()
                    }
                },
                secondaryButton: .cancel()
            )
        })
        .alignmentGuide(.listRowSeparatorLeading) { _ in
            -100
        }
        .sheet(isPresented: $showSelectableText) {
            let content = viewModel.status.reblog?.content.asSafeMarkdownAttributedString ?? viewModel.status.content.asSafeMarkdownAttributedString
            SelectTextView(content: content)
        }
        .environment(
            StatusDataControllerProvider.shared.dataController(for: viewModel.finalStatus,
                                                               client: viewModel.client)
        )
    }
    
    private func makeFilterView(filter: Filter) -> some View {
        HStack {
            Text("status.filter.filtered-by-\(filter.title)", bundle: .module)
            Button {
                withAnimation {
                    viewModel.isFiltered = false
                }
            } label: {
                Text("status.filter.show-anyway", bundle: .module)
            }
        }
        .accessibilityAction {
            viewModel.isFiltered = false
        }
    }
    
    private var remoteContentLoadingView: some View {
        ZStack(alignment: .center) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
        }
        .background(Color.black.opacity(0.40))
        .transition(.opacity)
    }
}
