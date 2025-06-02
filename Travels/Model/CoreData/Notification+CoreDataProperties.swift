//
//  Notification+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension Notification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notification> {
        return NSFetchRequest<Notification>(entityName: "Notification")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var message: String?
    @NSManaged public var user: User?

}

extension Notification : Identifiable {

}
