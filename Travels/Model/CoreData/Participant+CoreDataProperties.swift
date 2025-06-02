//
//  Participant+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var confirmed: Bool
    @NSManaged public var contact: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var userId: Int64
    @NSManaged public var expensesBeneficiary: NSSet?
    @NSManaged public var paidExpenses: NSSet?
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for expensesBeneficiary
extension Participant {

    @objc(addExpensesBeneficiaryObject:)
    @NSManaged public func addToExpensesBeneficiary(_ value: ExpenseBeneficiary)

    @objc(removeExpensesBeneficiaryObject:)
    @NSManaged public func removeFromExpensesBeneficiary(_ value: ExpenseBeneficiary)

    @objc(addExpensesBeneficiary:)
    @NSManaged public func addToExpensesBeneficiary(_ values: NSSet)

    @objc(removeExpensesBeneficiary:)
    @NSManaged public func removeFromExpensesBeneficiary(_ values: NSSet)

}

// MARK: Generated accessors for paidExpenses
extension Participant {

    @objc(addPaidExpensesObject:)
    @NSManaged public func addToPaidExpenses(_ value: Expense)

    @objc(removePaidExpensesObject:)
    @NSManaged public func removeFromPaidExpenses(_ value: Expense)

    @objc(addPaidExpenses:)
    @NSManaged public func addToPaidExpenses(_ values: NSSet)

    @objc(removePaidExpenses:)
    @NSManaged public func removeFromPaidExpenses(_ values: NSSet)

}

extension Participant : Identifiable {

}
