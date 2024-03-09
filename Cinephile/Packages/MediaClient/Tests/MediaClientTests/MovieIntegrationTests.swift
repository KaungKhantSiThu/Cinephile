//
//  MovieIntegrationTests.swift
//  
//
//  Created by Kaung Khant Si Thu on 21/01/2024.
//

import XCTest
import MediaClient

final class MovieIntegrationTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDetail() async throws {
        let movieID = 346698
        let movie: Movie
        do {
            movie = try await APIService.shared.get(endpoint: MoviesEndpoint.details(movieID: movieID))
        } catch {
            throw error
        }
        

        XCTAssertEqual(movie.id, movieID)
        XCTAssertEqual(movie.title, "Barbie")
    }
    
    func testGenres() async throws {
        let response: GenresResponse
        do {
            response = try await APIService.shared.get(endpoint: GenresEndpoint.movie)
        } catch {
            throw error
        }
        
        XCTAssertEqual(!response.genres.isEmpty, true)
    }
    
    struct GenresResponse: Codable {
        let genres: [Genre]
    }

}
