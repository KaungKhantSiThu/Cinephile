import Foundation

struct MoviePreviewViewModel {
    func performAPICall() async throws -> [Result] {
        guard let url = Bundle.main.url(forResource: "persons", withExtension: "json") else { return [] }
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode([Result].self, from: data)
        return result
    }
}
