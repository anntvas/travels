//
//  Trip+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var createdBy: Int64
    @NSManaged public var departureCity: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var destinationCity: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var budget: Budget?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var participants: NSSet?


}

// MARK: Generated accessors for expenses
extension Trip {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for participants
extension Trip {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: Participant)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: Participant)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}

extension Trip : Identifiable {

}
