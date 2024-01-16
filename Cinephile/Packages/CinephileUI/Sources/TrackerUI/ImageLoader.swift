//
//  ImageLoader.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import Foundation
import TMDb
import SwiftUI
import Combine

public struct ImageLoaderS {
    
    enum ImageLoaderError: Error {
        case urlNil
    }

    public static func generate(from url: URL?) async throws -> URL {
        if let url = url {
            let configurationService = ConfigurationService()
            let apiConfiguration = try await configurationService.apiConfiguration()
            let imagesConfiguration = apiConfiguration.images
            return imagesConfiguration.posterURL(for: url) ?? URL(string: "https://picsum.photos/200/300")!
        } else {
            throw ImageLoaderError.urlNil
        }
    }
    
    public static func generateLogo(from url: URL?) async throws -> URL {
        if let url = url {
            let configurationService = ConfigurationService()
            let apiConfiguration = try await configurationService.apiConfiguration()
            let imagesConfiguration = apiConfiguration.images
            return imagesConfiguration.logoURL(for: url) ?? URL(string: "https://picsum.photos/200/300")!
        } else {
            throw ImageLoaderError.urlNil
        }
    }
}

public final class ImageLoader {
    
    var configuration: ImagesConfiguration {
        get async throws {
            let configurationService = ConfigurationService()
            let apiConfiguration = try await configurationService.apiConfiguration()
            return apiConfiguration.images
        }
    }
}

public class ImageService {
    public static let shared = ImageService()
    
    public enum Size: String {
        case small = "https://image.tmdb.org/t/p/w154/"
        case medium = "https://image.tmdb.org/t/p/w500/"
        case cast = "https://image.tmdb.org/t/p/w185/"
        case original = "https://image.tmdb.org/t/p/original/"
        
        func path(poster: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(poster)
        }
    }
    
    public enum ImageError: Error {
        case decodingError
    }
    
    public func fetchImage(poster: String, size: Size) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: size.path(poster: poster))
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)
        }.catch { error in
            return Just(nil)
        }
        .eraseToAnyPublisher()
    }
}
