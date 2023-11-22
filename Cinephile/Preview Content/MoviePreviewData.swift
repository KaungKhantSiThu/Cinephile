import Foundation

struct MoviePreviewData {
    func fetchMovieData() async throws -> [Result] {
        let path = Bundle.main.path(forResource: "Movie", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        guard let data = try? Data(contentsOf: url) else { fatalError("Movie Data not found") }
        
        do {
            guard let decodedresults = try? JSONDecoder().decode([Result].self, from: data) else { return [] }
            return decodedresults
        }
    }
}
