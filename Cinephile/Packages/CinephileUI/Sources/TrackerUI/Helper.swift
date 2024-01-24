//
//  Helper.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 29/10/2023.
//

import Foundation
import MediaClient
import SwiftUI

@MainActor
enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}

protocol LoadableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}


struct AsyncContentView<Source: LoadableObject, LoadingView: View, Content: View>: View {
    var source: Source
    var loadingView: LoadingView
    var content: (Source.Output) -> Content

    init(source: Source,
         loadingView: LoadingView,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.loadingView = loadingView
        self.content = content
    }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform: source.load)
        case .loading:
            loadingView
        case .failed(let error):
            ErrorView(error: error, retryHandler: source.load)
        case .loaded(let output):
            content(output)
        }
    }
}

typealias DefaultProgressView = ProgressView<EmptyView, EmptyView>

extension AsyncContentView where LoadingView == DefaultProgressView {
    init(
        source: Source,
        @ViewBuilder content: @escaping (Source.Output) -> Content
    ) {
        self.init(
            source: source,
            loadingView: ProgressView(),
            content: content
        )
    }
}

struct ErrorView: View {
    let error: Error
    let retryHandler: () -> Void
    var body: some View {
        Text("There was an error regarding \(error.localizedDescription)")
        Button("Retry", action: retryHandler)
    }
}

extension DateFormatter {

    static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

}
