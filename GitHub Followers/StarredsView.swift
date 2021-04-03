//
//  StarredsView.swift
//  GitHub Followers
//
//  Created by Josh Root on 12/3/20.
//

import SwiftUI

struct StarredsView: View {
    var username: String = ""
    
    @State var starreds: [Starred] = []
    @State var disable: Bool = false
    @State var page: Int = 1
    @State var bgColor: Color = Color(.systemBlue)
    @State var loaded: Bool = false
    
    var body: some View {
        List {
            ForEach(starreds, id: \.id) { starred in
                Link(destination: URL(string: "\(starred.html_url)")!) {
                    VStack(spacing: 20) {
                        HStack {
                            VStack {
                                HStack(spacing: 5) {
                                    RemoteImage(url: starred.owner.avatar_url, loading: Image("avatar-placeholder"), failure: Image("avatar-placeholder"))
                                        .frame(width: 30, height: 30, alignment: .leading)
                                    Text("Owner: \(starred.owner.login)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                }
                                Text("\(starred.full_name)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }
                            Spacer()
                            VStack {
                                Text("Created: \(formatDate(from: starred.created_at))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                Text("Updated: \(formatDate(from: starred.updated_at))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                Text("Pushed: \(formatDate(from: starred.pushed_at))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        HStack {
                            HStack {
                                Image(systemName: "star")
                                Text("\(starred.stargazers_count)")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "eye")
                                Text("\(starred.watchers_count)")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("\(starred.open_issues_count)")
                            }
                        }
                    }
                    .padding(.all, 10)
                }
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
        .navigationBarTitle("\(username) - Starred", displayMode: .large)
        .frame(maxWidth: .infinity)
    }
    
    func loadData(page: Int) {
        guard let url: URL = URL(string: "https://api.github.com/users/\(username)/starred?page=\(page)&per_page=50") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([Starred].self, from: data)
                    
                    DispatchQueue.main.async {
                        if decodedResponse.count > 0 {
                            for item in decodedResponse {
                                print(item.html_url)
                                self.starreds.append(item)
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
