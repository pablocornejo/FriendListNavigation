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
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isFiltering = false
    @State private var filterValue = ""
    @State private var filterType = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $isFiltering) {
                        Text("Filter")
                    }
                    
                    if isFiltering {
                        Picker("Filter type", selection: $filterType) { ForEach(0..<2) {
                            Text("\(FilterOperation(rawValue: $0)?.displayText ?? "Unknown Filter")")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        TextField("Enter text to filter", text: $filterValue)
                    }
                }
                
                Section {
                    FilteredForEach(filterKey: #keyPath(User.name), filterOperation: FilterOperation(rawValue: filterType)!, filterValue: filterValue, sortDescriptors: [NSSortDescriptor(key: #keyPath(User.name), ascending: true)], isFiltering: isFiltering) { (user: User) in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            UserCellView(user: user)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: Button(action: {
                self.loadUsers()
            }) {
                Image(systemName: "arrow.clockwise")
            })
            .navigationBarTitle("Users")
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage))
        }
    }
    
    private func loadUsers() {
        let usersUrl = "https://www.hackingwithswift.com/samples/friendface.json"
        NetworkManager.fetchUsers(url: usersUrl, context: moc) { result in
            switch result {
            case .success(_):
                try? self.moc.save()
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
