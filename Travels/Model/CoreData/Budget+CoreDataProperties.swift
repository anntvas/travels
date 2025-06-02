//
//  Budget+CoreDataProperties.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var totalBudget: Double
    @NSManaged public var categories: NSSet?
    @NSManaged public var trip: Trip?
    
    @objc(addCategoriesObject:)
       @NSManaged public func addToCategories(_ value: BudgetCategory)

       @objc(removeCategoriesObject:)
       @NSManaged public func removeFromCategories(_ value: BudgetCategory)

       @objc(addCategories:)
       @NSManaged public func addToCategories(_ values: NSSet)

       @objc(removeCategories:)
       @NSManaged public func removeFromCategories(_ values: NSSet)

}

extension Budget : Identifiable {

}
