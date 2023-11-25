import Foundation
import TMDb


extension Array where Element == Movie {
    static let preview: [Movie] = {
        if let fileURL = Bundle.main.path(forResource: "movie", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(MoviePageableList.self, from: jsonData)
                return loadedData.results
            } catch {
                print("Error loading data from JSON: \(error.localizedDescription)")
            }
        } else {
            print("File not found.")
        }
        return []
    }()
}

extension Movie {
    static let preview = Array<Movie>.preview.first
}

extension Array where Element == CastMember {
    static let preview: [CastMember] = {
        if let fileURL = Bundle.main.path(forResource: "cast", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(ShowCredits.self, from: jsonData)
                return loadedData.cast
            } catch {
                print(String(describing: error))
            }
        } else {
            print("File not found.")
        }
        return []
    }()
}

extension CastMember {
    static let preview = Array<CastMember>.preview.first
}
