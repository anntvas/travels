//
//  User+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}

extension User {
    @NSManaged public var trips: Set<Trip>?
}

extension User {
    func addTrip(_ trip: Trip) {
        self.mutableSetValue(forKey: "trips").add(trip)
    }
}
