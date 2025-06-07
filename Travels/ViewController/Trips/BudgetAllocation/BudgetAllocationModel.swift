//
//  BudgetAllocationModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import CoreData
protocol BudgetAllocationModelProtocol {
    var categories: [BudgetCategoryModel] { get set }
    var totalBudget: Double { get }
    func allocatedAmount() -> Double
//    func createTrip() -> Result<Trip, Error>
    func syncTrip(completion: @escaping (Bool) -> Void)
    func reset()
}


final class BudgetAllocationModel: BudgetAllocationModelProtocol {
    var categories: [BudgetCategoryModel]
    let totalBudget: Double
    private var tripCreationManager: TripCreationManagerProtocol
    
    init(
        tripCreationManager: TripCreationManagerProtocol = TripCreationManager.shared
    ) {
        self.tripCreationManager = tripCreationManager
        self.categories = tripCreationManager.categories
        self.totalBudget = tripCreationManager.totalBudget
    }
    
    func allocatedAmount() -> Double {
        return categories.reduce(0) { $0 + $1.allocatedAmount }
    }
    
//    func createTrip() -> Result<Trip, Error> {
//        tripCreationManager.categories = categories
//        
//        do {
////            let trip = tripCreationManager.createTrip(in: DataController.shared.context)
//            try DataController.shared.context.save()
////            return .success(trip)
//        } catch {
//            return .failure(error)
//        }
//    }
    
    func syncTrip(completion: @escaping (Bool) -> Void) {
        tripCreationManager.syncTrip(completion: completion)
    }
    
    func reset() {
        tripCreationManager.reset()
    }
}

// Протокол для TripCreationManager
protocol TripCreationManagerProtocol {
    var categories: [BudgetCategoryModel] { get set }
    var totalBudget: Double { get }
//    func createTrip(in context: NSManagedObjectContext) -> Trip
    func syncTrip(completion: @escaping (Bool) -> Void)
    func reset()
}

extension TripCreationManager: TripCreationManagerProtocol {
//    func createTrip(in context: NSManagedObjectContext) -> Trip {
//        
//    }
}
