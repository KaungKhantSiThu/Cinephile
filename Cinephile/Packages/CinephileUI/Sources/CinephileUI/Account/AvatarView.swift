//
//  AvatarView.swift
//
//
//  Created by Kaung Khant Si Thu on 16/12/2023.
//

import SwiftUI
import NukeUI

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
              } else if state.error != nil {
                  Image("avatar_placeholder", bundle: .module)
                      .resizable()
                      .scaledToFit()
              }
            }
            
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(.primary.opacity(0.25), lineWidth: 1)
            )
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

#Preview(traits: .sizeThatFitsLayout) {
    AvatarView(URL(string: "https://picsum.photos/200/300"), config: .account)
}
