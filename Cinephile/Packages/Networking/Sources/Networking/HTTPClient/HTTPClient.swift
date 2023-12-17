//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation

public protocol HTTPClient {

    ///
    /// Performs an HTTP GET request.
    ///
    /// - Parameters:
    ///   - url: The URL to use for the request.
    ///   - headers: Additional HTTP headers to use in the request.
    ///
    /// - Returns: An HTTP response object.
    ///
    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse
    
    

}
