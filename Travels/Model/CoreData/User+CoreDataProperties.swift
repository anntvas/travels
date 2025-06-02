//
//  User+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarData: Data?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var username: String?
    @NSManaged public var notifications: NSSet?

}

// MARK: Generated accessors for notifications
extension User {

    @objc(addNotificationsObject:)
    @NSManaged public func addToNotifications(_ value: Notification)

    @objc(removeNotificationsObject:)
    @NSManaged public func removeFromNotifications(_ value: Notification)

    @objc(addNotifications:)
    @NSManaged public func addToNotifications(_ values: NSSet)

    @objc(removeNotifications:)
    @NSManaged public func removeFromNotifications(_ values: NSSet)

}

extension User : Identifiable {

}
