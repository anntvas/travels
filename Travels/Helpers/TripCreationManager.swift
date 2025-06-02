//
//  TripCreationManager.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import Foundation
import CoreData

class TripCreationManager {
    static let shared = TripCreationManager()

    private init() {}

    // MARK: - Черновые данные
    var title: String?
    var fromCity: String?
    var toCity: String?
    var startDate: Date?
    var endDate: Date?
    var participants: [Participant] = []
    var totalBudget: Double = 0
    var categories: [BudgetCategoryModel] = []

    var currentUser: User?

    // MARK: - Очистить все
    func reset() {
        title = nil
        fromCity = nil
        toCity = nil
        startDate = nil
        endDate = nil
        participants.removeAll()
        totalBudget = 0
        categories.removeAll()
        currentUser = nil
    }

    // MARK: - Сохранение в CoreData
    func createTrip(in context: NSManagedObjectContext) -> Trip? {
        guard let title, let fromCity, let toCity, let startDate, let endDate, let user = currentUser else {
            print("Trip data is incomplete")
            return nil
        }

        let trip = Trip(context: context)
        trip.title = title
        trip.destinationCity = toCity
        trip.startDate = startDate
        trip.endDate = endDate
        trip.departureCity = fromCity
        trip.createdBy = user.id

        // Создаём и связываем бюджет
        let budget = Budget(context: context)
        budget.totalBudget = totalBudget
        budget.trip = trip

        for category in categories {
            let cat = BudgetCategory(context: context)
            cat.category = category.category
            cat.allocatedAmount = category.allocatedAmount
            budget.addToCategories(cat)
        }

        trip.budget = budget

        // Участники поездки
        for participant in participants {
            participant.trip = trip
        }

        // Сохраняем всё вместе
        do {
            try context.save()
            print("Trip and participants created successfully")
            return trip
        } catch {
            print("Failed to save trip: \(error)")
            return nil
        }
    }

}
extension TripCreationManager {
    func syncTrip(completion: @escaping (Bool) -> Void) {
//        let tripRequest = self.toNetworkModel()
        
//        NetworkManager.shared.createTrip(tripRequest) { result in
//            switch result {
//            case .success(let response):
//                print("Trip synced successfully. ID: \(response.id)")
//                completion(true)
//                
//            case .failure(let error):
//                print("Sync error: \(error.message)")
//                completion(false)
//            }
//        }
    }
}
