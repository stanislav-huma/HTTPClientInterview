//
//  RepositoryOwner.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

struct RepositoryOwner: AnyModel {
    let id: Int
    let avatarURL: String?
    let url: String
    
    var ownerImageURL: URL? {
        guard let avatarURL, let url = URL.init(string: avatarURL) else {
            return nil
        }
        
        return url
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case url
    }
}
