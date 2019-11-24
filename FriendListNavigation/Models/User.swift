//
//  User.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let managedObjectContextUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContextUserInfoKey")!
}

@objc(User)
public class User: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, isActive, name, age, company, email, address, about, registered, tags, friends
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tagsData: Data?
    @NSManaged public var friendsData: Data?
    
    var wrappedId: String { id ?? "Unknown Id" }
    var wrappedName: String { name ?? "Unknown Name" }
    var wrappedCompany: String { company ?? "Unknown Company" }
    var wrappedEmail: String { email ?? "Unknown Email" }
    var wrappedAddress: String { address ?? "Unknown Address" }
    var wrappedAbout: String { about ?? "Unknown About" }
    var wrappedRegistered: Date { registered ?? Date() }
    
    var tags: [String] {
        guard let tagsData = tagsData else { return [] }
        return (try? JSONDecoder().decode([String].self, from: tagsData)) ?? []
    }
    
    var friends: [Friend] {
        guard let friendsData = friendsData else { return [] }
        return (try? JSONDecoder().decode([Friend].self, from: friendsData)) ?? []
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    private static let testMoc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    public required init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.managedObjectContextUserInfoKey] as! NSManagedObjectContext
        super.init(entity: User.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        name = try container.decode(String.self, forKey: .name)
        age = Int16(try container.decode(Int.self, forKey: .age))
        company = try container.decode(String.self, forKey: .company)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decode(String.self, forKey: .address)
        about = try container.decode(String.self, forKey: .about)
        registered = try container.decode(Date.self, forKey: .registered)
        let jsonEncoder = JSONEncoder()
        let tags = try container.decode([String].self, forKey: .tags)
        tagsData = try jsonEncoder.encode(tags)
        let friends = try container.decode([Friend].self, forKey: .friends)
        friendsData = try jsonEncoder.encode(friends)
    }
    
    static let sample: User = {
        let user = User(context: testMoc)
        user.id = "1"
        user.isActive = true
        user.name = "Pablo"
        user.age = 100
        user.company = "Apple"
        user.email = "pablo@apple.com"
        user.address = "123 Some Street, City, CA"
        user.about = "Currently typing in some sample data for a SwiftUI project. What are you up to? Currently typing in some sample data for a SwiftUI project. What are you up to?"
        user.registered = Date()
        let encoder = JSONEncoder()
        let tags = ["me", "swiftui", "swe", "me", "swiftui", "swe"]
        user.tagsData = try? encoder.encode(tags)
        let friends = [Friend(id: "2", name: "Paul Hudson"), Friend(id: "3", name: "Nathan Brewsler")]
        user.friendsData = try? encoder.encode(friends)
        return user
    }()
}
