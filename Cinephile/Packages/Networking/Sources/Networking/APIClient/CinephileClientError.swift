//
//  CinephileClientError.swift
//
//
//  Created by Kaung Khant Si Thu on 13/12/2023.
//

import Foundation

enum CinephileClientError: Error {

    ///
    /// Network error.
    ///
    case network(Error)

    ///
    /// Bad request.
    ///
    case badRequest(String?)

    ///
    /// Unauthorised.
    ///
    case unauthorised(String?)

    ///
    /// Forbidden.
    ///
    case forbidden(String?)

    ///
    /// Not found.
    ///
    case notFound(String?)

    ///
    /// Method not allowed.
    ///
    case methodNotAllowed(String?)

    ///
    /// Not acceptable.
    ///
    case notAcceptable(String?)

    ///
    /// Unprocessable entity.
    ///
    case unprocessableEntity(String?)

    ///
    /// Too many requests.
    ///
    case tooManyRequests(String?)

    ///
    /// Internal server error.
    ///
    case internalServerError(String?)

    ///
    /// Not implemented.
    ///
    case notImplemented(String?)

    ///
    /// Bad gateway.
    ///
    case badGateway(String?)

    ///
    /// Remote Service unavailable.
    ///
    case remoteServiceUnavailable(String?)

    ///
    /// Gateway timeout.
    ///
    case gatewayTimeout(String?)

    ///
    /// Data decode error.
    ///
    case decode(Error)

    ///
    /// Unknown error.
    ///
    case unknown

}
