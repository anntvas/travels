//
//  Expense+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var desciptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var beneficiaries: NSSet?
    @NSManaged public var paidBy: Participant?
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for beneficiaries
extension Expense {

    @objc(addBeneficiariesObject:)
    @NSManaged public func addToBeneficiaries(_ value: ExpenseBeneficiary)

    @objc(removeBeneficiariesObject:)
    @NSManaged public func removeFromBeneficiaries(_ value: ExpenseBeneficiary)

    @objc(addBeneficiaries:)
    @NSManaged public func addToBeneficiaries(_ values: NSSet)

    @objc(removeBeneficiaries:)
    @NSManaged public func removeFromBeneficiaries(_ values: NSSet)

}

extension Expense : Identifiable {

}
