//
//  File.swift
//
//
//  Created by Kaung Khant Si Thu on 21/01/2024.
//

import Foundation

public struct APIService {
    let baseURL = URL(string: "https://api.themoviedb.org/3")!
    let apiKey = "0b8723760cac397ab78965e78c1cd188"
    
    public static let shared = APIService()
    private let serializer = Serialiser(decoder: .theMovieDatabase)
    
    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch let error {
            throw error
        }

        guard let httpURLResponse = response as? HTTPURLResponse else {
            return HTTPResponse(statusCode: -1, data: nil)
        }

        let statusCode = httpURLResponse.statusCode
        return HTTPResponse(statusCode: statusCode, data: data)
    }
    
    public func get<Response: Decodable>(path: URL) async throws -> Response {
        
        let url = urlFromPath(path)
        
        let headers = [
            "Accept": "application/json"
        ]
        
        let response: HTTPResponse
        
        do {
            response = try await get(url: url, headers: headers)
        } catch {
            throw APIError.network(error)
        }
        
        try await validate(response: response)

        guard let data = response.data else {
            throw APIError.unknown
        }
        
        let decodedResponse: Response
        do {
            decodedResponse = try await serializer.decode(Response.self, from: data)
        } catch let error {
            throw APIError.decode(error)
        }

        return decodedResponse
    }
    
    public func get<Response: Decodable>(endpoint: Endpoint) async throws -> Response {
        try await get(path: endpoint.path)
    }
}

extension APIService {
    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"

        return urlComponents.url!
            .appendingAPIKey(apiKey)
            .appendingLanguage(Locale.preferredLanguages[0])
    }
    
    private func validate(response: HTTPResponse) async throws {
        let statusCode = response.statusCode
        if (200...299).contains(statusCode) {
            return
        }

        guard let data = response.data else {
            throw APIError(statusCode: statusCode, message: nil)
        }

        let statusResponse = try? await serializer.decode(StatusResponse.self, from: data)
        let message = statusResponse?.statusMessage

        throw APIError(statusCode: statusCode, message: message)
    }
}
