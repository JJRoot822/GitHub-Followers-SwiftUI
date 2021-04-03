//
//  Subscription.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import Foundation

struct Subscription: Codable {
    var id:               Int
    var full_name:        String
    var owner:            Owner
    var html_url:         String
    var created_at:       Date
    var updated_at:       Date
    var pushed_at:        Date
    var stargazers_count: Int
    var language:         String
    var forks:            Int
    var open_issues:      Int
    var watchers:         Int
    var default_branch:   String
    
    struct Owner: Codable {
        var login: String
    }
}
