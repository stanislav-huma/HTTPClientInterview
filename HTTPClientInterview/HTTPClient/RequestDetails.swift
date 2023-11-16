//
//  RequestDetails.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

protocol RequestDetails {
    var httpMethod: HTTPMethod { get }
    var urlComponent: URLComponents { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    var path: String { get }
    var url: String { get }
}

extension RequestDetails {
    var headers: [String: String] {
        var headers: [String: String] = [:]
        headers.updateValue(HeaderValue.accept.rawValue, forKey: HeaderKey.accept.rawValue)
        headers.updateValue(HeaderValue.githubApiVersion.rawValue, forKey: HeaderKey.githubApiVersion.rawValue)
        return headers
    }

    var urlComponent: URLComponents {
        URLComponents(string: url + path)!
    }
}
