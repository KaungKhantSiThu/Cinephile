//
//  TimelineFilterTests.swift
//
//
//  Created by Kaung Khant Si Thu on 03/01/2024.
//
@testable import Timeline
import XCTest
import Networking
import Models

final class TimelineFilterTests: XCTestCase {
    func testCodableHome() throws {
        XCTAssertTrue(try testCodableOn(filter: .home))
        XCTAssertTrue(try testCodableOn(filter: .local))
        XCTAssertTrue(try testCodableOn(filter: .federated))
        XCTAssertTrue(try testCodableOn(filter: .remoteLocal(server: "me.dm", filter: .local)))
        XCTAssertTrue(try testCodableOn(filter: .hashtag(tag: "test", accountId: nil)))
    }
    
    private func testCodableOn(filter: TimelineFilter) throws -> Bool {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode(filter)
        let newFilter = try decoder.decode(TimelineFilter.self, from: data)
        return newFilter == filter
    }
}
