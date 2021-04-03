//
//  FollowingUserInfo.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/2/20.
//

import SwiftUI

struct FollowingUserInfo: View {
    var login:             String
    var avatarURL:         String
    var htmlURL:           String
    var followingURL:      String
    var followersURL:      String
    var starredURL:        String
    var reposURL:          String
    var url:               String
    
    var columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var user: User = User()
    
    var body: some View {
        VStack {
            RemoteImage(url: avatarURL, loading: Image("avatar-placeholder"), failure: Image("avatar-placeholder"))
                .frame(width: 150, height: 150)
                .cornerRadius(15)
                .navigationBarTitle(Text(login), displayMode: .large)
                .toolbar {
                    Link(destination: URL(string: htmlURL)!) {
                        Text("Go to GitHub Profile")
                            .foregroundColor(.green)
                    }
                }
            Text("\(self.user.bio)")
            
            LazyVGrid(columns: columns, spacing: 20) {
                NavigationLink(destination: Text("")) {
                    HStack {
                        Image(systemName: "person.crop.square.fill")
                        Text("Following - \(self.user.following)")
                    }
                }
                .frame(width: 170, height: 50)
                .foregroundColor(Color.white)
                .background(Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)))
                .cornerRadius(15)
                
                NavigationLink(destination: Text("")) {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Followers - \(self.user.followers)")
                    }
                }
                .frame(width: 170, height: 50)
                .foregroundColor(Color.white)
                .background(Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)))
                .cornerRadius(15)
                
                NavigationLink(destination: Text("")) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Starred")
                    }
                }
                .frame(width: 170, height: 50)
                .foregroundColor(Color.white)
                .background(Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)))
                .cornerRadius(15)
                
                NavigationLink(destination: Text("")) {
                    HStack {
                        Image(systemName: "folder.fill")
                        Text("Repos - \(self.user.public_repos)")
                    }
                }
                .frame(width: 170, height: 50)
                .foregroundColor(Color.white)
                .background(Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)))
                .cornerRadius(15)
            }
        }
        .onAppear() {
            loadData()
        }
    }
    
    func loadData() {
        guard let url: URL = URL(string: "https://api.github.com/users/\(login)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(User.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.user = decodedResponse
                    }

                    return
                } catch {
                    print("\(error.localizedDescription)")
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }
}
