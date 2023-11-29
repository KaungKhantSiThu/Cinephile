import Foundation
import TMDb


extension Array where Element == Movie {
    static let preview = {
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
    static let preview = {
        if let fileURL = Bundle.main.path(forResource: "movie-detail", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(Movie.self, from: jsonData)
                return loadedData
            } catch {
                print("Error loading data from JSON: \(error.localizedDescription)")
            }
        } else {
            print("File not found.")
        }
        return PreviewData.mockMovie
    }()
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

extension Array where Element == TVSeries {
    static let preview: [TVSeries] = {
        if let fileURL = Bundle.main.path(forResource: "series", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(TVSeriesPageableList.self, from: jsonData)
                return loadedData.results
            } catch {
                print(String(describing: error))
            }
        } else {
            print("File not found.")
        }
        return []
    }()
}

extension TVSeries {
    static let preview: TVSeries? = {
        if let fileURL = Bundle.main.path(forResource: "series-detail", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(TVSeries.self, from: jsonData)
                return loadedData
            } catch {
                print(error)
            }
        } else {
            print("File not found.")
        }
        return nil
    }()
}

extension Array where Element == VideoMetadata {
    static let preview = {
        if let fileURL = Bundle.main.path(forResource: "movie-video", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(VideoCollection.self, from: jsonData)
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

extension Array where Element == WatchProvider {
    static let preview = {
        if let fileURL = Bundle.main.path(forResource: "movie-video", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode([WatchProvider].self, from: jsonData)
                return loadedData
            } catch {
                print("Error loading data from JSON: \(error.localizedDescription)")
            }
        } else {
            print("File not found.")
        }
        return []
    }()
}

extension Array where Element == TVEpisode {
    static let preview = {
        if let fileURL = Bundle.main.path(forResource: "season-detail", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let loadedData = try JSONDecoder().decode(TVSeason.self, from: jsonData)
                print("Hi again")
                return loadedData.episodes
            } catch {
                print(error)
            }
        } else {
            print("File not found.")
        }
        return []
    }()
}



