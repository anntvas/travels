//
//  TripDetailsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import CoreData

protocol TripDetailsModelProtocol {
    func createTrip(
        title: String,
        fromCity: String,
        toCity: String,
        startDate: Date,
        endDate: Date,
        createdBy: User,
        completion: @escaping (Result<TripResponse, Error>) -> Void
    )
    func loadCurrentUser(completion: @escaping (User?) -> Void)
}

final class TripDetailsModel: TripDetailsModelProtocol {
    private let networkManager: NetworkManagerProtocol
    private let context: NSManagedObjectContext
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
         context: NSManagedObjectContext = DataController.shared.context) {
        self.networkManager = networkManager
        self.context = context
    }

    func createTrip(
        title: String,
        fromCity: String,
        toCity: String,
        startDate: Date,
        endDate: Date,
        createdBy: User,
        completion: @escaping (Result<TripResponse, Error>) -> Void
    ) {
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let tripRequest = TripRequest(
            title: title,
            description: "Поездка из \(fromCity) в \(toCity)",
            startDate: startDateString,
            endDate: endDateString,
            departureCity: fromCity,
            destinationCity: toCity,
            createdBy: Int64(createdBy.id)
        )

        networkManager.createTrip(trip: tripRequest, completion: completion)
    }
    func loadCurrentUser(completion: @escaping (User?) -> Void) {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else {
            completion(nil)
            return
        }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userId))
        
        do {
            let user = try context.fetch(request).first
            completion(user)
        } catch {
            print("Ошибка загрузки пользователя: \(error)")
            completion(nil)
        }
    }
}
