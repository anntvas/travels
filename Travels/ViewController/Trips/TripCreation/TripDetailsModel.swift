//
//  TripDetailsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripDetailsModelProtocol {
    func createTrip(
        title: String,
        fromCity: String,
        toCity: String,
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<TripResponse, Error>) -> Void
    )
}

final class TripDetailsModel: TripDetailsModelProtocol {
    private let networkManager: NetworkManagerProtocol
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func createTrip(
        title: String,
        fromCity: String,
        toCity: String,
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<TripResponse, Error>) -> Void
    ) {
        networkManager.getCurrentUserId { [weak self] result in
            switch result {
            case .success(let userId):
                print("ну четт должно выйти \(userId)")
                let startDateString = self?.dateFormatter.string(from: startDate) ?? ""
                let endDateString = self?.dateFormatter.string(from: endDate) ?? ""

                let tripRequest = TripRequest(
                    title: title,
                    description: "Поездка из \(fromCity) в \(toCity)",
                    startDate: startDateString,
                    endDate: endDateString,
                    departureCity: fromCity,
                    destinationCity: toCity,
                    createdBy: Int64(userId)
                )

                self?.networkManager.createTrip(trip: tripRequest, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
