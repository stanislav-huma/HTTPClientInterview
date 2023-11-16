//
//  HTTPClient.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

protocol AnyHTTPClient {
    func execute<T: AnyModel>(_ requestObj: RequestConvertible, completion: @escaping (Result<T, Error>) -> Void)
}

final class HTTPClient: AnyHTTPClient {

    // MARK: - Private Properties

    private let urlSession: URLSession
    
    // MARK: - Init

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
}

// MARK: - AnyHTTPClient implementation

extension HTTPClient {
    func execute<T: AnyModel>(_ requestObj: RequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
        urlSession.dataTask(with: requestObj.request) { data, response, error in
            do {
                if let error = error {
                    throw error
                }
                
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.requestFailed
                }
                
                guard let statusCode = HTTPStatusCode(rawValue: response.statusCode) else {
                    throw APIError.requestFailed
                }
                
                switch statusCode.responseType {
                case .success:
                    guard let data = data else {
                        throw APIError.missingData
                    }
                    
                    completion(.success(try T.init(data: data)))
                default:
                    throw statusCode
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
