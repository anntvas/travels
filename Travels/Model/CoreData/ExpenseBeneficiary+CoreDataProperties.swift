//
//  ExpenseBeneficiary+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension ExpenseBeneficiary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseBeneficiary> {
        return NSFetchRequest<ExpenseBeneficiary>(entityName: "ExpenseBeneficiary")
    }

    @NSManaged public var expense: Expense?
    @NSManaged public var participant: Participant?

}

extension ExpenseBeneficiary : Identifiable {

}
