//
//  Follower.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import Foundation

struct Follower: Codable {
    var id:                Int
    var login:             String
    var avatar_url:        String
    var url:               String
    var html_url:          String
    var following_url:     String
    var followers_url:     String
    var starred_url:       String
    var subscriptions_url: String
    var repos_url:         String
}
