//
//  AnyModel.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

extension String: Error {}

protocol AnyModel: Codable {

    // MARK: - Init

    init(data: Data?) throws
    init(_ json: String, using encoding: String.Encoding) throws
    init(fromURL url: URL) throws

    // MARK: - Methods

    func jsonData() throws -> Data
    func jsonString(encoding: String.Encoding) throws -> String?
}

// MARK: - Default implementation

extension AnyModel {
    init(data: Data?) throws {
        do {
            guard let data = data else {
                throw "jsonEncoding"
            }

            self = try JSONDecoder().decode(Self.self, from: data)
        } catch let error {
            print("⚠️ Decoding error:", error.localizedDescription)
            throw error
        }
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw "jsonEncoding"
        }

        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()

        return try encoder.encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try self.jsonData(), encoding: encoding)
    }
}
