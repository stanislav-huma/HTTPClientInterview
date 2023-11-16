//
//  Repository.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import Foundation

struct Repository: AnyModel {
    let id: Int
    let name: String
    let fullName: String?
    let owner: RepositoryOwner
    let repoDescription: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case repoDescription = "description"
        case url = "html_url"
    }
}
