//
//  TripDetailModel.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol TripDetailModelProtocol {
    func loadTripData() -> Trip
}
final class TripDetailModel: TripDetailModelProtocol {
    private let trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    func loadTripData() -> Trip {
        return trip
    }
}
