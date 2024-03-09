//
//  StatusRowGenreView.swift
//
//
//  Created by Kaung Khant Si Thu on 02/03/2024.
//

import Environment
import SwiftUI

struct StatusRowGenreView: View {
  @Environment(CurrentAccount.self) private var currentAccount
  let viewModel: StatusRowViewModel

  var body: some View {
//    if let genre = viewModel.finalStatus.content.links.first(where: { link in
//      link.type == .hashtag && currentAccount.genres.contains(where: { $0.name.lowercased() == link.name.lowercased() })
//    }) {
      if let genre = viewModel.finalStatus.entertainments.first?.genres.first(where: { genre in currentAccount.genres.contains(where: { $0.name.lowercased() == genre.name.lowercased() })}) {
      Text("\(Image(systemName: "movieclapper")) \(genre.name)")
        .font(.scaledFootnote)
        .foregroundStyle(.secondary)
        .fontWeight(.semibold)
    }
  }
}
