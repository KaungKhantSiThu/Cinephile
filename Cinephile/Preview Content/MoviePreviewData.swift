import Foundation
import TMDb

extension Array where Element == Movie {
    static let preview: [Movie] = {
        if let fileURL = Bundle.main.path(forResource: "preview-movie", ofType: "json") {
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
        return[]
    }()
}

extension Movie {
    static let preview = Array<Movie>.preview.first
}

extension CastMember {
    func castPreview() async throws -> [CastMember] {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/670292/credits?language=en-US") {
            let (data, _) = try await URLSession.shared.data(from: url)
            let wrapper = try JSONDecoder().decode([CastMember].self, from: data)
            return wrapper
        }
        return []
    }
}
