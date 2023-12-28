//
//  SelectTextView.swift
//
//
//  Created by Kaung Khant Si Thu on 24/12/2023.
//

import UIKit
import SwiftUI
import CinephileUI

struct SelectTextView: View {
  @Environment(\.dismiss) private var dismiss
  let content: AttributedString

  var body: some View {
    NavigationStack {
      SelectableText(content: content)
        .padding()
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              dismiss()
            } label: {
              Text("action.done", bundle: .module).bold()
            }
          }
        }
        .background(Theme.shared.primaryBackgroundColor)
        .navigationTitle(Text("status.action.select-text", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
//
struct SelectableText: UIViewRepresentable {
  let content: AttributedString

  func makeUIView(context _: Context) -> UITextView {
    let attributedText = NSMutableAttributedString(content)
    attributedText.addAttribute(
      .font,
      value: Font.scaledBodyFont,
      range: NSRange(location: 0, length: content.characters.count)
    )

    let textView = UITextView()
    textView.isEditable = false
    textView.attributedText = attributedText
    textView.textColor = UIColor(Color.label)
    textView.backgroundColor = UIColor(Theme.shared.primaryBackgroundColor)
    return textView
  }

  func updateUIView(_: UITextView, context _: Context) {}
  func makeCoordinator() {}
}
