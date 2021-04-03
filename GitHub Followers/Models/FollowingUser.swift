//
//  FollowingUser.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import Foundation

struct FollowingUser: Codable {
    var login:             String
    var id:                Int
    var avatar_url:        String
    var html_url:          String
}
