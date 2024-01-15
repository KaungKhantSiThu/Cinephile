import AVKit
import Environment
import Observation
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "MediaUIAttachmentVideo", category: "ViewModel")
@MainActor
@Observable public class MediaUIAttachmentVideoViewModel {
    var player: AVPlayer?
    private let url: URL
    let forceAutoPlay: Bool
    
    public init(url: URL, forceAutoPlay: Bool = false) {
        self.url = url
        self.forceAutoPlay = forceAutoPlay
    }
    
    func preparePlayer(autoPlay: Bool) {
        player = .init(url: url)
        player?.isMuted = !forceAutoPlay
        player?.audiovisualBackgroundPlaybackPolicy = .pauses
        if autoPlay || forceAutoPlay {
            logger.info("Auto-Playing video")
            player?.play()
        } else {
            logger.info("Pausing video")
            player?.pause()
        }
        guard let player else { return }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem, queue: .main)
        { _ in
            Task { @MainActor [weak self] in
                if autoPlay || self?.forceAutoPlay == true {
                    self?.play()
                }
            }
        }
    }
    
    func pause() {
        logger.info("Pausing video")
        player?.pause()
    }
    
    func play() {
        logger.info("Playing video")
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

public struct MediaUIAttachmentVideoView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.isCompact) private var isCompact
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    
    @State var viewModel: MediaUIAttachmentVideoViewModel
    
    public init(viewModel: MediaUIAttachmentVideoViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VideoPlayer(player: viewModel.player)
                .accessibilityAddTraits(.startsMediaSession)
            
            if !preferences.autoPlayVideo, !viewModel.forceAutoPlay {
                Image(systemName: "play.fill")
                    .font(isCompact ? .body : .largeTitle)
                    .foregroundColor(theme.tintColor)
                    .padding(.all, isCompact ? 6 : nil)
                    .background(Circle().fill(.thinMaterial))
                    .padding(theme.statusDisplayStyle == .compact ? 0 : 10)
            }
        }
        .onAppear {
            viewModel.preparePlayer(autoPlay: preferences.autoPlayVideo)
        }
        .onDisappear {
            viewModel.pause()
        }
        .cornerRadius(4)
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .background, .inactive:
                viewModel.pause()
            case .active:
                if preferences.autoPlayVideo || viewModel.forceAutoPlay {
                    viewModel.play()
                }
            default:
                break
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MediaUIAttachmentVideoView(viewModel: .init(url: URL(string: "https://files.mastodon.social/media_attachments/files/111/714/179/228/948/998/original/6963f9c4afbea204.mp4")!))
        .environment(UserPreferences.shared)
        .environment(Theme.shared)
}
