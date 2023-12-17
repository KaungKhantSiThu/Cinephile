//
//  Router.swift
//
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import Foundation
import SwiftUI
import TMDb
import Networking
import Models

public enum SheetDestination: Identifiable {
    case addAccount
    case settings
    
    public var id: String {
        switch self {
        case .addAccount:
            "addAccount"
        case .settings:
            "statusEditor"
        }
    }
    
    
}

public enum RouterDestination: Hashable {
    case movieDetail(id: Movie.ID)
    case seriesDetail(id: TVSeries.ID)
    case trackerSearchView
    case episodeListView(id: TVSeries.ID, inSeason: Int)
    case accountDetail(id: Account.ID)
    case accountDetailWithAccount(account: Account)
    case accountSettingsWithAccount(account: Account, appAccount: AppAccount)
}

@MainActor
@Observable public class RouterPath {
    public var client: Client?
    public var path: [RouterDestination] = []
    public var presentedSheet: SheetDestination?
    
    public init() {}

    public func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
}
