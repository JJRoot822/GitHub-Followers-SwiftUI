//
//  Repositories.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/3/20.
//

import Foundation

struct Repository: Codable {
    var id: Int
    var full_name: String
    var owner: Owner
    var html_url: String
    var created_at: String
    var updated_at: String
    var pushed_at: String
    var stargazers_count: Int
    var watchers_count: Int
    var open_issues_count: Int
    
    struct Owner: Codable {
        var login: String
        var avatar_url: String
    }
}
