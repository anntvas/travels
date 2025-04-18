//
//  Trip+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var destination: String?
    @NSManaged public var user: User?

}

extension Trip : Identifiable {

}
