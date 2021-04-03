//
//  FollowerFollowersView.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import SwiftUI

struct FollowerFollowersView: View {
    var username: String
    
    @State var followers: [Follower] = []
    @State var disable: Bool = false
    @State var page: Int = 1
    @State var bgColor: Color = Color(.systemBlue)
    @State var loaded: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        List {
            ForEach(followers, id: \.id) { follower in
                Link(destination: URL(string: "\(follower.html_url)")!) {
                    HStack(spacing: 5) {
                        RemoteImage(url: follower.avatar_url, loading: Image("avatar-placeholder"), failure: Image("avatar-placeholder"))
                            .frame(width: 75, height: 75)
                            .cornerRadius(10)
                        Text("\(follower.login)")
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            Button("Load More Followers") {
                page += 1
                
                loadData(page: page)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .disabled(disable)
            .background(bgColor)
            .foregroundColor(Color.white)
            .cornerRadius(15)
        }
        .onAppear() {
            if !loaded {
                loadData(page: 1)
                loaded = true
            }
        }
        .navigationBarTitle("\(username) - Followers", displayMode: .large)
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
