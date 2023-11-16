//
//  SearchRequest.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

enum SearchRequest: RequestDetails, RequestConvertible {
    case searchRepository(String)
   
    // MARK: - Properties
    
    var httpMethod: HTTPMethod {
        switch self {
        case .searchRepository:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .searchRepository:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .searchRepository(let string):
            return "search/repositories?q=" + string
        }
    }
    
    var url: String {
        "https://api.github.com/"
    }
}
