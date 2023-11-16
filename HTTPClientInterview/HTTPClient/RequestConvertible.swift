//
//  RequestConvertible.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

protocol RequestConvertible {
    var request: URLRequest { get }
}

extension RequestConvertible where Self: RequestDetails {
    var request: URLRequest {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}
