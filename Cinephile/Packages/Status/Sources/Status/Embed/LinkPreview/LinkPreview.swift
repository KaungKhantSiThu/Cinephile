////
////  SwiftUIView.swift
////  
////
////  Created by Kaung Khant Si Thu on 18/12/2023.
////
//
//import SwiftUI
//import Environmentironment
//
//public struct LinkPreview: View {
//    @Environment(\.isInCaptureMode) private var isInCaptureMode: Bool
//    let title: String
//    let imageURL: URL?
//    let url: URL
//    public var body: some View {
//        if let imageURL, !isInCaptureMode {
//          LazyResizableImage(url: imageURL) { state, proxy in
//            let width = imageWidthFor(proxy: proxy)
//            if let image = state.image {
//              image
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: imageHeight)
//                .frame(maxWidth: width)
//                .clipped()
//            } else if state.isLoading {
//              Rectangle()
//                .fill(Color.gray)
//                .frame(height: imageHeight)
//            }
//          }
//          // This image is decorative
//          .accessibilityHidden(true)
//          .frame(height: imageHeight)
//        }
//    }
//    HStack {
//      VStack(alignment: .leading, spacing: 6) {
//        Text(title)
//          .font(.scaledHeadline)
//          .lineLimit(3)
//        if let description = card.description, !description.isEmpty {
//          Text(description)
//            .font(.scaledBody)
//            .foregroundStyle(.secondary)
//            .lineLimit(3)
//        }
//        Text(url.host() ?? url.absoluteString)
//          .font(.scaledFootnote)
//          .foregroundColor(theme.tintColor)
//          .lineLimit(1)
//      }
//      Spacer()
//    }.padding(16)
//}
//
//private func iconLinkPreview(_ title: String, _ url: URL) -> some View {
//  // ..where the image is known to be a square icon
//  HStack {
//    if let imageURL = card.image, !isInCaptureMode {
//      LazyResizableImage(url: imageURL) { state, _ in
//        if let image = state.image {
//          image
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: imageHeight, height: imageHeight)
//            .clipped()
//        } else if state.isLoading {
//          Rectangle()
//            .fill(Color.gray)
//            .frame(width: imageHeight, height: imageHeight)
//        }
//      }
//      // This image is decorative
//      .accessibilityHidden(true)
//      .frame(width: imageHeight, height: imageHeight)
//    }
//
//    VStack(alignment: .leading, spacing: 6) {
//      Text(title)
//        .font(.scaledHeadline)
//        .lineLimit(3)
//      if let description = card.description, !description.isEmpty {
//        Text(description)
//          .font(.scaledBody)
//          .foregroundStyle(.secondary)
//          .lineLimit(3)
//      }
//      Text(url.host() ?? url.absoluteString)
//        .font(.scaledFootnote)
//        .foregroundColor(theme.tintColor)
//        .lineLimit(1)
//    }.padding(16)
//  }
//}
//
//#Preview {
//    SwiftUIView()
//}
