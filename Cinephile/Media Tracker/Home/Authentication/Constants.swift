import Foundation

enum Constants {
    static let currentYear = Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year!
}
