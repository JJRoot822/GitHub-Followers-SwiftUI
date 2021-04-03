//
//  FollowersVIew.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/1/20.
//

import SwiftUI

struct FollowersView: View {
    var username: String
    
    @State var followers: [Follower] = []
    @State var disable: Bool = false
    @State var page: Int = 1
    @State var bgColor: Color = Color(.systemBlue)
    @State var isPresented: Bool = false
    @State var loaded: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    ForEach(followers, id: \.id) { follower in
                        VStack(spacing: 5) {
                            RemoteImage(url: follower.avatar_url, loading: Image("avatar-placeholder"), failure: Image("avatar-placeholder"))
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                            Text("\(follower.login)")
                                .lineLimit(1)
                                .frame(width: 150, height: 25)
                            NavigationLink(destination: FollowerInfo(login:            follower.login,
                                                                     avatarURL:        follower.avatar_url,
                                                                     htmlURL:          follower.html_url,
                                                                     followingURL:     follower.following_url,
                                                                     followersURL:     follower.followers_url,
                                                                     starredURL:       follower.starred_url,
                                                                     reposURL:         follower.repos_url,
                                                                     url:              follower.url)) {
                                HStack(spacing: 5) {
                                    Image(systemName: "info.circle")
                                    Text("More Info")
                                }
                            }
                            .frame(width: 150, height: 50)
                            .background(Color(UIColor(red: 0, green: 0, blue: 1, alpha: 1)))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                    }
                    Button("Load More Followers") {
                        page += 1
                        
                        loadData(page: page)
                    }
                    .frame(width: 150, height: 175)
                    .disabled(disable)
                    .background(bgColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
                }
                .padding(.all, 10)
                .onAppear() {
                    if !loaded {
                        loadData(page: 1)
                        loaded = true
                    }
                }
            }
        }
        .navigationBarTitle(username, displayMode: .large)
    }
    
    func loadData(page: Int) {
        guard let url: URL = URL(string: "https://api.github.com/users/\(username)/followers?page=\(page)&per_page=50") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([Follower].self, from: data)
                    
                    DispatchQueue.main.async {
                        if decodedResponse.count > 0 {
                            for item in decodedResponse {
                                self.followers.append(item)
                            }
                        }
                        
                        if decodedResponse.count == 0 || decodedResponse.count < 50 {
                            self.disable = true
                            self.bgColor = Color(.systemGray4)
                        }
                    }

                    return
                } catch {
                    print("\(error.localizedDescription)")
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
