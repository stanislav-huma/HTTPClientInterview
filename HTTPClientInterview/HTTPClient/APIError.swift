//
//  APIError.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

enum APIError: LocalizedError {
    case requestFailed
    case missingData

    var errorDescription: String? {
        switch self {
        case .requestFailed: return "Request failed"
        case .missingData: return "Missing data"
        }
    }
}
