//
//  Router.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation
import SwiftUI
import TMDb

public enum RouterDestination: Hashable {
    case movieDetail(id: Movie.ID)
    case seriesDetail(id: TVSeries.ID)
    case trackerSearchView
}

@MainActor
@Observable public class RouterPath {
    public var path: [RouterDestination] = []
    
    public init() {}

    public func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
}
