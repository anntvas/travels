//
//  TripDetailsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripDetailsModelProtocol {
    func createTrip(_ trip: TripRequest, completion: @escaping (Result<TripResponse, Error>) -> Void)
}

final class TripDetailsModel: TripDetailsModelProtocol {
    func createTrip(_ trip: TripRequest, completion: @escaping (Result<TripResponse, Error>) -> Void) {
        NetworkManager.shared.createTrip(trip: trip, completion: completion)
    }
}
