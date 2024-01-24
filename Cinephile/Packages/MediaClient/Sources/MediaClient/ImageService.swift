//
//  ImageService.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit

public class ImageService {
    public static let shared = ImageService()
    
    public enum Size: String {
        case small = "https://image.tmdb.org/t/p/w154"
        case medium = "https://image.tmdb.org/t/p/w500"
        case cast = "https://image.tmdb.org/t/p/w185"
        case original = "https://image.tmdb.org/t/p/original"
        
        func path(poster: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(poster)
        }
    }
    
    public func posterURL(for path: URL?) -> URL {
        if let path = path {
            return Size.original.path(poster: path.absoluteString)
        } else {
            return URL(string: "https://picsum.photos/200/300")!
        }
        
    }
}

//extension ImageService {
//    private static let defaultSizePathComponent = "original"
//
//    private func imageURL(for path: URL?, idealWidth width: Int, sizes: [String]) -> URL? {
//        guard let path else {
//            return nil
//        }
//
//        let sizePathComponent = Self.imageSizePathComponent(for: width, from: sizes)
//
//        return baseURL
//            .appendingPathComponent(sizePathComponent)
//            .appendingPathComponent(path.absoluteString)
//    }
//
//    private static func imageSizePathComponent(for width: Int, from sizes: [String]) -> String {
//        let actualSize = sizes.first { size in
//            guard let parsedSize = Int(size.replacingOccurrences(of: "w", with: "")) else {
//                return false
//            }
//
//            return parsedSize >= width
//        } ?? sizes.last
//
//        return actualSize ?? Self.defaultSizePathComponent
//    }
//}
