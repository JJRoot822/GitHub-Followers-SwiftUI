//
//  RepositoriesView.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/3/20.
//

import SwiftUI

struct RepositoriesView: View {
    var username: String = ""
    
    @State var repos: [Repository] = []
    @State var disable: Bool = false
    @State var page: Int = 1
    @State var bgColor: Color = Color(.systemBlue)
    @State var loaded: Bool = false
    
    var body: some View {
        List {
            ForEach(repos, id: \.id) { repo in
                Link(destination: URL(string: "\(repo.html_url)")!) {
                    VStack(spacing: 20) {
                        HStack {
                            VStack {
                                HStack(spacing: 5) {
                                    RemoteImage(url: repo.owner.avatar_url, loading: Image("avatar-placeholder"), failure: Image("avatar-placeholder"))
                                        .frame(width: 30, height: 30, alignment: .leading)
                                    Text("Owner: \(repo.owner.login)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                }
                                Text("\(repo.full_name)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }
                        }
                        HStack {
                            Text("Created: \(formatDate(from: repo.created_at))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text("Updated: \(formatDate(from: repo.updated_at))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            HStack {
                                Image(systemName: "star")
                                Text("\(repo.stargazers_count)")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "eye")
                                Text("\(repo.watchers_count)")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("\(repo.open_issues_count)")
                            }
                        }
                    }
                    .padding(.all, 10)
                }
            }
            Button("Load More Repositories") {
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
        .navigationBarTitle("\(username) - Repositories", displayMode: .large)
        .frame(maxWidth: .infinity)
    }
    
    func loadData(page: Int) {
        guard let url: URL = URL(string: "https://api.github.com/users/\(username)/repos?page=\(page)&per_page=50") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([Repository].self, from: data)
                    
                    DispatchQueue.main.async {
                        if decodedResponse.count > 0 {
                            for item in decodedResponse {
                                print(item.updated_at)
                                self.repos.append(item)
                            }
                        }
                        
                        if decodedResponse.count == 0 || decodedResponse.count < 50 {
                            self.disable = true
                            self.bgColor = Color(.systemGray4)
                        }
                    }

                    return
                } catch {
                    print("\(error)")
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func formatDate(from string: String) -> String {
        let components = string.split(separator: "-")
        
        let month = components[1]
        let day   = components[2].split(separator: "T")[0]
        let year  = components[0]
        
        return "\(month)/\(day)/\(year)"
    }
}
