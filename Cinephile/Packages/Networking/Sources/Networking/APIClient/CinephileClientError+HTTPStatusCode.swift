//
//  CinephileClientError+HTTPStatusCode.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation

extension CinephileClientError {
    init(statusCode: Int, message: String?) {
        switch statusCode {
        case 400:
            self = .badRequest(message)

        case 401:
            self = .unauthorised(message)

        case 403:
            self = .forbidden(message)

        case 404:
            self = .notFound(message)

        case 405:
            self = .methodNotAllowed(message)

        case 406:
            self = .notAcceptable(message)

        case 422:
            self = .unprocessableEntity(message)

        case 429:
            self = .tooManyRequests(message)

        case 500:
            self = .internalServerError(message)

        case 501:
            self = .notImplemented(message)

        case 502:
            self = .badGateway(message)

        case 503:
            self = .remoteServiceUnavailable(message)

        case 504:
            self = .gatewayTimeout(message)

        default:
            self = .unknown
        }
    }
}
