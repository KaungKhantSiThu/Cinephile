import Foundation
import SwiftUI
///
/// A model representing a show's status.
///

public enum Status: String, Codable, Equatable, Hashable, Identifiable, CaseIterable {

    ///
    /// Rumoured.
    ///
    case rumoured = "Rumored"

    ///
    /// Planned.
    ///
    case planned = "Planned"

    ///
    /// In production.
    ///
    case inProduction = "In Production"

    ///
    /// Post production.
    ///
    case postProduction = "Post Production"

    ///
    /// Released.
    ///
    case released = "Released"

    ///
    /// Cancelled.
    ///
    case cancelled = "Canceled"
    
    public var id: String { rawValue }
    
    public var color: Color {
        switch self {
        case .rumoured, .planned:
            Color.gray
        case .inProduction:
            Color.yellow
        case .postProduction:
            Color.orange
        case .released:
            Color.green
        case .cancelled:
            Color.red
        }
    }

}
