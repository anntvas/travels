//
//  SecondModel.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import CoreData

protocol SecondModelProtocol {
    func loadCurrentUser(completion: @escaping (User?) -> Void)
    func fetchTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
}

final class SecondModel: SecondModelProtocol {
    private let networkManager: NetworkManagerProtocol
    private let context: NSManagedObjectContext
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        context: NSManagedObjectContext = DataController.shared.context
    ) {
        self.networkManager = networkManager
        self.context = context
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
    
    func fetchTrips(completion: @escaping (Result<[Trip], Error>) -> Void) {
        // Сначала пытаемся загрузить из сети
        networkManager.getTrips { [weak self] result in
            switch result {
            case .success(let networkTrips):
                self?.processNetworkTrips(networkTrips: networkTrips) { localResult in
                    switch localResult {
                    case .success(let trips):
                        completion(.success(trips))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let networkError):
                // Если сеть не доступна, грузим из CoreData
                self?.loadLocalTrips(completion: completion)
            }
        }
    }
    
    private func processNetworkTrips(
        networkTrips: [TripResponse],
        completion: @escaping (Result<[Trip], Error>) -> Void
    ) {
        // Удаляем старые поездки
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Trip.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Ошибка удаления старых поездок: \(error)")
        }
        
        // Сохраняем новые поездки
        for tripResponse in networkTrips {
            let trip = Trip(context: context)
            trip.id = Int64(tripResponse.id)
            trip.title = tripResponse.title
            trip.departureCity = tripResponse.departureCity
            trip.destinationCity = tripResponse.destinationCity
            trip.startDate = dateFromString(tripResponse.startDate)
            trip.endDate = dateFromString(tripResponse.endDate)
        }
        
        do {
            try context.save()
            loadLocalTrips(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    private func loadLocalTrips(completion: @escaping (Result<[Trip], Error>) -> Void) {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let trips = try context.fetch(request)
            completion(.success(trips))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
}
