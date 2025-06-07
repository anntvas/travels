//
//  FirstViewModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import CoreData

protocol FirstModelProtocol {
    func fetchTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func fetchTripBudget(tripId: Int, completion: @escaping (Result<Double, Error>) -> Void)
}

final class FirstModel: FirstModelProtocol {
    private let networkManager: NetworkManagerProtocol
    private let context: NSManagedObjectContext

    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        context: NSManagedObjectContext = DataController.shared.context
    ) {
        self.networkManager = networkManager
        self.context = context
    }

    func fetchTrips(completion: @escaping (Result<[Trip], Error>) -> Void) {
        networkManager.getTrips { [weak self] result in
            switch result {
            case .success(let tripResponses):
                self?.saveTripsToCoreData(tripResponses, completion: completion)
            case .failure:
                self?.loadTripsFromCoreData(completion: completion)
            }
        }
    }
    func fetchTripBudget(tripId: Int, completion: @escaping (Result<Double, Error>) -> Void) {
        networkManager.getBudget(tripId: tripId) { result in
            switch result {
            case .success(let response):
                completion(.success(response.totalBudget))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



    private func saveTripsToCoreData(_ responses: [TripResponse], completion: @escaping (Result<[Trip], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Trip.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Ошибка очистки старых поездок: \(error)")
        }

        for response in responses {
            let trip = Trip(context: context)
            trip.id = Int64(response.id)
            trip.title = response.title
            trip.departureCity = response.departureCity
            trip.destinationCity = response.destinationCity
            trip.startDate = dateFromString(response.startDate)
            trip.endDate = dateFromString(response.endDate)
        }

        do {
            try context.save()
            loadTripsFromCoreData(completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func loadTripsFromCoreData(completion: @escaping (Result<[Trip], Error>) -> Void) {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]

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
