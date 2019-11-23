//
//  ContentView.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var users: [User] = []
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserDetailView(user: user, users: self.users)) {
                    UserCellView(user: user)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.loadUsers()
            }) {
                Image(systemName: "arrow.clockwise")
            })
            .navigationBarTitle("Users")
            
        }
        .onAppear(perform: loadUsers)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage))
        }
    }
    
    private func loadUsers() {
        let usersUrl = "https://www.hackingwithswift.com/samples/friendface.json"
        NetworkManager.fetchUsers(url: usersUrl) { result in
            switch result {
            case .success(let users):
                
                self.users = users
            case .failure(let error):
                print(error)
                self.alertTitle = "Error loading users"
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
