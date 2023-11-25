//
//  ImageLoader.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import Foundation
import TMDb

struct ImageLoader {
    
    enum ImageLoaderError: Error {
        case urlNil
    }

    static func generate(from url: URL?, width: Int) async throws -> URL {
        if let url = url {
            let configurationService = ConfigurationService()
            let apiConfiguration = try await configurationService.apiConfiguration()
            let imagesConfiguration = apiConfiguration.images
            return imagesConfiguration.posterURL(for: url, idealWidth: width) ?? URL(string: "https://picsum.photos/200/300")!
        } else {
            throw ImageLoaderError.urlNil
        }
    }
}
