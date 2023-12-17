//
//  AvatarView.swift
//
//
//  Created by Kaung Khant Si Thu on 16/12/2023.
//

import SwiftUI
import NukeUI
import Models

public struct AvatarView: View {
    
    public let avatar: URL?
    public let config: FrameConfiguration
    
    public var body: some View {
        if let avatar {
            AvatarImage(avatar: avatar, config: adaptiveConfiguration)
                .frame(width: config.width, height: config.height)
        } else {
            AvatarPlaceHolder(config: adaptiveConfiguration)
        }
    }
    
    public init(_ avatar: URL? = nil, config: FrameConfiguration = .status) {
      self.avatar = avatar
      self.config = config
    }
    
    private var adaptiveConfiguration: FrameConfiguration {
      var cornerRadius: CGFloat
      if config == .badge {
        cornerRadius = config.width / 2
      } else {
        cornerRadius = config.cornerRadius
      }
      return FrameConfiguration(width: config.width, height: config.height, cornerRadius: cornerRadius)
    }
}

struct AvatarImage: View {
    @Environment(\.redactionReasons) private var reasons
    
    public let avatar: URL
    public let config: AvatarView.FrameConfiguration
    
    var body: some View {
        if reasons == .placeholder {
            
        } else {
            LazyImage(request: ImageRequest(url: avatar, processors: [.resize(size: config.size)])
            ) { state in
              if let image = state.image {
                image
                  .resizable()
                  .scaledToFit()
                  .clipShape(Circle())
                  .overlay(
                    Circle()
                      .stroke(.primary.opacity(0.25), lineWidth: 1)
                  )
              }
            }
        }
    }
}

struct AvatarPlaceHolder: View {
  let config: AvatarView.FrameConfiguration

  var body: some View {
    RoundedRectangle(cornerRadius: config.cornerRadius)
      .fill(.gray)
      .frame(width: config.width, height: config.height)
  }
}

extension AvatarView {
    public struct FrameConfiguration: Equatable {
      public let size: CGSize
      public var width: CGFloat { size.width }
      public var height: CGFloat { size.height }
      let cornerRadius: CGFloat

      init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 4) {
        self.size = CGSize(width: width, height: height)
        self.cornerRadius = cornerRadius
      }

      public static let account = FrameConfiguration(width: 80, height: 80)
  #if targetEnvironment(macCatalyst)
      public static let status = FrameConfiguration(width: 48, height: 48)
  #else
      public static let status = FrameConfiguration(width: 40, height: 40)
  #endif
      public static let embed = FrameConfiguration(width: 34, height: 34)
      public static let badge = FrameConfiguration(width: 28, height: 28, cornerRadius: 14)
      public static let list = FrameConfiguration(width: 20, height: 20, cornerRadius: 10)
      public static let boost = FrameConfiguration(width: 12, height: 12, cornerRadius: 6)
    }
}

//struct PreviewWrapper: View {
//  @State private var isCircleAvatar = false
//
//  var body: some View {
//    VStack(alignment: .leading) {
//        AvatarView(Account.placeholder().avatar)
////        .environment(Theme.shared)
//      Toggle("Avatar Shape", isOn: $isCircleAvatar)
//    }
////    .onChange(of: isCircleAvatar) {
////      Theme.shared.avatarShape = self.isCircleAvatar ? .circle : .rounded
////    }
////    .onAppear {
////      Theme.shared.avatarShape = self.isCircleAvatar ? .circle : .rounded
////    }
//  }
//
//  private static let account = Account(
//    id: UUID().uuidString,
//    username: "@clattner_llvm",
//    displayName: "Chris Lattner",
//    avatar: URL(string: "https://pbs.twimg.com/profile_images/1484209565788897285/1n6Viahb_400x400.jpg")!,
//    header: URL(string: "https://pbs.twimg.com/profile_banners/2543588034/1656822255/1500x500")!,
//    acct: "clattner_llvm@example.com",
//    note: .init(stringValue: "Building beautiful things @Modular_AI 🔥, lifting the world of production AI/ML software into a new phase of innovation.  We’re hiring! 🚀🧠"),
//    createdAt: ServerDate(),
//    followersCount: 77100,
//    followingCount: 167,
//    statusesCount: 123,
//    lastStatusAt: nil,
//    fields: [],
//    locked: false,
//    emojis: [],
//    url: URL(string: "https://nondot.org/sabre/")!,
//    source: nil,
//    bot: false,
//    discoverable: true)
//}

#Preview(traits: .sizeThatFitsLayout) {
    AvatarView(Account.placeholder().avatar)
}
