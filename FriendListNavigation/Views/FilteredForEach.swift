//
//  FilteredList.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import SwiftUI
import CoreData
import UIKit

enum FilterOperation: Int, CaseIterable {
    case beginsWith, contains
    
    var stringValue: String {
        switch self {
        case .beginsWith: return "BEGINSWITH[c]"
        case .contains: return "CONTAINS[c]"
        }
    }
    
    var displayText: String {
        switch self {
        case .beginsWith: return "Begins With"
        case .contains: return "Contains"
        }
    }
}

struct FilteredForEach<T: NSManagedObject, Content: View>: View {
    
    var fetchRequest: FetchRequest<T>
    var content: (T) -> Content
    var isFiltering = false
    
    var body: some View {
        ForEach(fetchRequest.wrappedValue, id: \.self) {
            self.content($0)
        }
    }
    
    init(filterKey: String, filterOperation: FilterOperation, filterValue: String, sortDescriptors: [NSSortDescriptor], isFiltering: Bool, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: (isFiltering && !filterValue.isEmpty) ? NSPredicate(format: "%K \(filterOperation.stringValue) %@", filterKey, filterValue) : nil)
        self.content = content
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredForEach(filterKey: "lastName", filterOperation: .beginsWith, filterValue: "A", sortDescriptors: [], isFiltering: false) { _ in
            Text("Test")
        }
    }
}

