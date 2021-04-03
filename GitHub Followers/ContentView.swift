//
//  ContentView.swift
//  GitHub Followers
//
//  Created by Josh Root on 11/29/20.
//

import SwiftUI

struct ContentView: View {
    @State var username: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack {
                    Image("gh-logo")
                    TextField("GitHub Username", text: $username)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background(Color(.systemBackground))
                        .cornerRadius(25)
                        .clipShape(Capsule())
                    NavigationLink("Get Followers", destination: FollowersView(username: username))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(Color(.white))
                        .background(Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)))
                        .cornerRadius(25)
                }
                .padding(.all, 20)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
