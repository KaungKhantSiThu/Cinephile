//
//  URL+QueryItem.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation

extension URL {

    func appendingPathComponent(_ value: Int) -> Self {
        appendingPathComponent(String(value))
    }

    func appendingQueryItem(name: String, value: CustomStringConvertible) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value.description))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }

}

extension URL {
    private enum QueryItemName {
        static let apiKey = "api_key"
        static let language = "language"
        static let page = "page"
        static let limit = "limit"
        static let sinceId = "since_id"
        static let maxId = "max_id"
        static let minId = "min_id"
        static let account = "acct"
        static let notify = "notify"
        static let reblogs = "reblogs"
    }
    
    
    func appendingSinceId(_ id: String?) -> Self {
        guard let id else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.sinceId, value: id)
    }
    
    func appendingMaxId(_ id: String?) -> Self {
        guard let id else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.maxId, value: id)
    }
    
    func appendingMinId(_ id: String?) -> Self {
        guard let id else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.minId, value: id)
    }
    
    func appendingLimit(_ count: String?) -> Self {
        guard let count else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.limit, value: count)
    }
    
    func appendingAccountName(_ acct: String?) -> Self {
        guard let acct else {
            return self
        }
        return appendingQueryItem(name: QueryItemName.account, value: acct)
    }
    
    func appendingNotify(_ bool: Bool?) -> Self {
        guard let bool else {
            return self
        }
        
        return appendingQueryItem(name: QueryItemName.notify, value: bool ? "true" : "false")
    }
    
    func appendingReblogs(_ bool: Bool?) -> Self {
        guard let bool else {
            return self
        }
        
        return appendingQueryItem(name: QueryItemName.reblogs, value: bool ? "true" : "false")
    }
}
