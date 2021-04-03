//
//  User.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import Foundation

struct User: Codable {
    var bio:          String
    var public_repos: Int
    var public_gists: Int
    var followers:    Int
    var following:    Int
    
    init() {
        self.bio          = ""
        self.public_repos = 0
        self.public_gists = 0
        self.followers    = 0
        self.following    = 0
    }
    
    init(bio:          String,
         public_repos: Int,
         public_gists: Int,
         followers:    Int,
         following:    Int) {
        self.bio          = bio
        self.public_repos = public_repos
        self.public_gists = public_gists
        self.followers    = followers
        self.following    = following
    }
}
