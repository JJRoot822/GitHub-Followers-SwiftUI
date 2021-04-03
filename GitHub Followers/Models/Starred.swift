//
//  Starred.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import Foundation

struct Starred: Codable {
    var id: Int = 0
    var full_name: String = "N/A"
    var html_url: String = "N/A"
    var owner: Owner = Owner(login: "N/A", avatar_url: "N/A")
    var created_at: String = ""
    var updated_at: String = ""
    var pushed_at: String = ""
    var stargazers_count: Int = 0
    var watchers_count: Int = 0
    var open_issues_count: Int = 0
    
     struct Owner: Codable {
        var login: String = "N/A"
        var avatar_url: String = "N/A"
     }
}
