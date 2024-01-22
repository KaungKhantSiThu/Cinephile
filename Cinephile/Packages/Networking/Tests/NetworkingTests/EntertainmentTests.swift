//
//  EntertainmentTest.swift
//  
//
//  Created by Kaung Khant Si Thu on 22/01/2024.
//

import XCTest
import Models
import Networking

final class EntertainmentTests: XCTestCase {

    func testDecodeReturnsEntertainment() throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(entertainment)
        print(String(data: data, encoding: .utf8) ?? "")
    }

}

extension EntertainmentTests {
    private var entertainment: EntertainmentData {
        .init(domain: "themoviedb.org", mediaType: .movie, mediaId: "507086")
    }
}
