//
//  TagView.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import SwiftUI

struct TagView: View {
    let tag: String
    
    var body: some View {
        Text(tag)
            .font(.footnote)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    init(_ tag: String) {
        self.tag = tag
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView("swiftui")
    }
}
