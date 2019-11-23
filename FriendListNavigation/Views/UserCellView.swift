//
//  UserCellView.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import SwiftUI

struct UserCellView: View {
    let user: User
    
    private var displayTags: [String] {
        let maxTags = 2
        return user.tags.count > maxTags ? Array(user.tags[0..<maxTags]) : user.tags
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(user.name)
                        .font(.headline)
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(user.isActive ? .green : .red)
                }
                Text(user.company)
            }
            
            Spacer()
                
            HStack {
                ForEach(displayTags, id: \.self, content: TagView.init)
            }                
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        return UserCellView(user: User.sample)
    }
}
