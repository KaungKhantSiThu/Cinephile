//
//  EntertainmentIntegrationTests.swift
//  
//
//  Created by Kaung Khant Si Thu on 22/01/2024.
//

import XCTest
import Networking
import Models

final class EntertainmentIntegrationTests: XCTestCase {
    var client: Client!

    override func setUpWithError() throws {
        try super.setUpWithError()
        client = Client(server: "polar-brushlands-19893-4c4dfbb9419d.herokuapp.com", oauthToken: OauthToken(accessToken: "IFLrywlcgH7FibvKOdS31C8FazkSDIYtCT2HQftv5ZY",
                                                                                                                    tokenType: "Bearer",
                                                                                                                    scope: "read write follow",
                                                                                                                    createdAt: 1705756054))
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        client = nil
    }

}
