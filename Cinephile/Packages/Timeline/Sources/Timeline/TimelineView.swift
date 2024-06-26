import Charts
import CinephileUI
import Environment
import Models
import Networking

import Status
import SwiftData
import SwiftUI
import SwiftUIIntrospect

@MainActor
public struct TimelineView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Theme.self) private var theme
    @Environment(CurrentAccount.self) private var account
    @Environment(StreamWatcher.self) private var watcher
    @Environment(Client.self) private var client
    @Environment(RouterPath.self) private var routerPath
    
    @State private var viewModel = TimelineViewModel()
    @State private var prefetcher = TimelineMediaPrefetcher()
    
    @State private var wasBackgrounded: Bool = false
    @State private var collectionView: UICollectionView?
    
    @Binding var timeline: TimelineFilter
    @Binding var selectedTagGroup: TagGroup?
    @Binding var scrollToTopSignal: Int
    
    @Query(sort: \TagGroup.creationDate, order: .reverse) var tagGroups: [TagGroup]
    
    private let canFilterTimeline: Bool
    
    public init(timeline: Binding<TimelineFilter>,
                selectedTagGroup: Binding<TagGroup?>,
                scrollToTopSignal: Binding<Int>,
                canFilterTimeline: Bool)
    {
        _timeline = timeline
        _selectedTagGroup = selectedTagGroup
        _scrollToTopSignal = scrollToTopSignal
        self.canFilterTimeline = canFilterTimeline
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            List {
                scrollToTopView
                TimelineGenreHeaderView(genre: $viewModel.genre)
                TimelineTagHeaderView(tag: $viewModel.tag)
//                entertainmentHeaderView
                switch viewModel.timeline {
                case .remoteLocal:
                    StatusesListView(fetcher: viewModel, client: client, routerPath: routerPath, isRemote: true)
                default:
                    StatusesListView(fetcher: viewModel, client: client, routerPath: routerPath)
                        .environment(\.isHomeTimeline, timeline == .home)
                }
            }
            .id(client.id)
            .environment(\.defaultMinListRowHeight, 1)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            //.background(theme.primaryBackgroundColor)
            .introspect(.list, on: .iOS(.v17)) { (collectionView: UICollectionView) in
                DispatchQueue.main.async {
                    self.collectionView = collectionView
                }
                prefetcher.viewModel = viewModel
                collectionView.isPrefetchingEnabled = true
                collectionView.prefetchDataSource = prefetcher
            }
            .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                if viewModel.timeline.supportNewestPagination {
                    TimelineUnreadStatusesView(observer: viewModel.pendingStatusesObserver)
                }
            }
            .onChange(of: viewModel.scrollToIndex) { _, newValue in
                if let collectionView,
                   let newValue,
                   let rows = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0),
                   rows > newValue
                {
                    collectionView.scrollToItem(at: .init(row: newValue, section: 0),
                                                at: .top,
                                                animated: viewModel.scrollToIndexAnimated)
                    viewModel.scrollToIndexAnimated = false
                    viewModel.scrollToIndex = nil
                }
            }
            .onChange(of: scrollToTopSignal) {
                withAnimation {
                    proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                }
            }
        }
        .toolbar {
            toolbarTitleView
            //      toolbarTagGroupButton
            if let entertainment = viewModel.entertainment {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        routerPath.navigate(to: .movieDetail(id: Int(entertainment.mediaId) ?? entertainment.id))
                    } label: {
                        Label("Info", imageNamed: "info.circle")
                    }

                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.canFilterTimeline = canFilterTimeline
            viewModel.isTimelineVisible = true
            
            if viewModel.client == nil {
                viewModel.client = client
            }
            
            viewModel.timeline = timeline
        }
        .onDisappear {
            viewModel.isTimelineVisible = false
            viewModel.saveMarker()
        }
        .refreshable {
            //      SoundEffectManager.shared.playSound(.pull)
            //      HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
            await viewModel.pullToRefresh()
            //      HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
            //      SoundEffectManager.shared.playSound(.refresh)
        }
        .onChange(of: watcher.latestEvent?.id) {
            Task {
                if let latestEvent = watcher.latestEvent {
                    await viewModel.handleEvent(event: latestEvent)
                }
            }
        }
        .onChange(of: timeline) { _, newValue in
            switch newValue {
            case let .remoteLocal(server, _):
                viewModel.client = Client(server: server)
            default:
                viewModel.client = client
            }
            viewModel.timeline = newValue
        }
        .onChange(of: viewModel.timeline) { _, newValue in
            timeline = newValue
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active:
                if wasBackgrounded {
                    wasBackgrounded = false
                    viewModel.refreshTimeline()
                }
            case .background:
                wasBackgrounded = true
                viewModel.saveMarker()
            default:
                break
            }
        }
    }
    
    
    @ViewBuilder
    private var entertainmentHeaderView: some View {
        if let entertainment = viewModel.entertainment {
            Section {
                        VStack(alignment: .center, spacing: 5) {
                            Text("Click to view Movie Detail")
                                .font(.subheadline)
                            Button {
                                routerPath.navigate(to: .movieDetail(id: Int(entertainment.mediaId) ?? entertainment.id))
                            } label: {
                                Text("Details")
                                    .bold()
                                    .padding(.vertical, 2)
                            }
            #if os(iOS)
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.accentColor)
            #elseif os(macOS)
                            .buttonStyle(.bordered)
            #endif
                            .tint(.white)
                            .padding(.top)
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                    }
            #if os(iOS)
            .listRowBackground(Rectangle().fill(Color.accentColor.gradient))
            #elseif os(macOS)
            .background(Color.accentColor.gradient)
            .cornerRadius(10)
            #endif
        }
    }
    
    @ViewBuilder
    private func headerView(
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            content()
            Spacer()
        }
//        .listRowBackground(theme.secondaryBackgroundColor)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 8,
                             leading: .layoutPadding,
                             bottom: 8,
                             trailing: .layoutPadding))
    }
    
    @ToolbarContentBuilder
    private var toolbarTitleView: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .center) {
                switch timeline {
                case let .remoteLocal(_, filter):
                    Text(filter.localizedTitle())
                        .font(.headline)
                    Text(timeline.localizedTitle())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case .home:
                    Text(timeline.localizedTitle())
                        .font(.headline)
                default:
                    Text(timeline.localizedTitle())
                        .font(.headline)
                }
            }
        }
    }
    
    private var scrollToTopView: some View {
        ScrollToView()
            .frame(height: .layoutPadding)
            .onAppear {
                viewModel.scrollToTopVisible = true
            }
            .onDisappear {
                viewModel.scrollToTopVisible = false
            }
    }
}

