//
//  UserDetailView.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    @State private var showingFullAbout = false
    
    let user: User
    let users: [User]
    
    private var displayTags: [String] {
        let maxTags = 4
        return user.tags.count > maxTags ? Array(user.tags[0..<maxTags]) : user.tags
    }
    
    var body: some View {
        VStack {
            Text(user.name)
                .font(.title)
                .padding(.top)
            
            HStack {
                Text("Works at \(user.company)")
                
                Spacer()
                
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(user.isActive ? .green : .red)
                Text(user.isActive ? "Active Now" : "Not Connected")
                    .font(.subheadline)
            }
            .padding([.bottom, .horizontal])
            
            VStack {
                Text(user.email)
                    .font(.headline)
                Text(user.address)
            }
            .foregroundColor(.secondary)
            
            HStack {
                ForEach(displayTags, id: \.self, content: TagView.init)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("About")
                    .font(.headline)
                Text(user.about)
                    .lineLimit(showingFullAbout ? nil : 3)
                    .padding(.vertical, 4)
                Button(showingFullAbout ? "Less" : "More") {
                    withAnimation {
                        self.showingFullAbout.toggle()                        
                    }
                }
            }
            .padding(.horizontal)
            
            List {
                Section(header: Text("\(user.name)'s friends")) {
                    ForEach(user.friends) { friend in
                        NavigationLink(destination: UserDetailView(user: self.user(for: friend), users: self.users)) {
                            Text(friend.name)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func user(for friend: Friend) -> User {
        users.first { $0.id == friend.id } ?? User.sample
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User.sample, users: [User.sample])
    }
}
