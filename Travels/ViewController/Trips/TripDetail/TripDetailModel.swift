//
//  TripDetailModel.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//
import Foundation

protocol TripDetailModelProtocol {
    func fetchTrip(completion: @escaping (Result<TripResponse, Error>) -> Void)
    func fetchTripBudget(completion: @escaping (Result<Double, Error>) -> Void)
    func fetchBudgetCategories(completion: @escaping (Result<[(name: String, amount: Double)], Error>) -> Void)
    func fetchParticipants(completion: @escaping (Result<[ParticipantResponse], Error>) -> Void)
    func fetchExpenses(completion: @escaping (Result<[ExpenseResponse], Error>) -> Void)

}

final class TripDetailModel: TripDetailModelProtocol {
    private let tripId: Int
    private let networkManager: NetworkManagerProtocol

    init(tripId: Int, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.tripId = tripId
        self.networkManager = networkManager
    }

    func fetchTrip(completion: @escaping (Result<TripResponse, Error>) -> Void) {
        networkManager.getTripDetails(tripId: tripId, completion: completion)
    }

    func fetchTripBudget(completion: @escaping (Result<Double, Error>) -> Void) {
        networkManager.getBudget(tripId: tripId) { result in
            switch result {
            case .success(let budget):
                completion(.success(budget.totalBudget))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func fetchBudgetCategories(completion: @escaping (Result<[(name: String, amount: Double)], Error>) -> Void) {
        networkManager.getBudget(tripId: tripId) { result in
            switch result {
            case .success(let budgetResponse):
                let categories = budgetResponse.categories.map {
                    (name: $0.category, amount: $0.allocatedAmount)
                }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchParticipants(completion: @escaping (Result<[ParticipantResponse], Error>) -> Void) {
        networkManager.listParticipants(tripId: tripId, completion: completion)
    }

    func fetchExpenses(completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        networkManager.listExpenses(tripId: tripId, completion: completion) 
    }


}
