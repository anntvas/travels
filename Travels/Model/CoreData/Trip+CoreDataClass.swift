//
//  Trip+CoreDataClass.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    var budgetEntity: BudgetEntity?
    var status: TripStatus?
        
}
