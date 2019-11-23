//
//  User.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    static let sample = User(id: "123", isActive: true, name: "Pablo Cornejo", age: 30, company: "Jalasoft", email: "pablo@swiftui.com", address: "Some Address", about: "Currently typing in some sample data for a SwiftUI project. What are you up to? Currently typing in some sample data for a SwiftUI project. What are you up to?", registered: Date(), tags: ["me", "swiftui", "swe", "me", "swiftui", "swe"], friends: [Friend(id: "1", name: "Joaquin Rodriguez"), Friend(id: "2", name: "Marcos Paredes")])
}
