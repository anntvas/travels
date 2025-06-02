//
//  BudgetCategory+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData


extension BudgetCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCategory> {
        return NSFetchRequest<BudgetCategory>(entityName: "BudgetCategory")
    }

    @NSManaged public var allocatedAmount: Double
    @NSManaged public var category: String?
    @NSManaged public var budget: Budget?

}

extension BudgetCategory : Identifiable {

}
