//
//  FirstPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol FirstViewProtocol: AnyObject {
    func displayTrips(current: Trip?, all: [Trip])
}

final class FirstPresenter {
    weak var view: FirstViewProtocol?
    private let model: FirstModelProtocol
    private let router: FirstRouterProtocol

    private var allTrips: [Trip] = []
    private var currentTrip: Trip?

    init(view: FirstViewProtocol, model: FirstModelProtocol, router: FirstRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }

    func viewDidLoad() {
        model.fetchUserAndTrips { [weak self] user, trips in
            self?.allTrips = trips
            self?.currentTrip = trips.first
            self?.view?.displayTrips(current: self?.currentTrip, all: trips)
        }
    }

    func didTapCreateTrip() {
        router.openCreateTrip()
    }

    func didSelectTrip(_ trip: Trip) {
        currentTrip = trip
        view?.displayTrips(current: currentTrip, all: allTrips)
    }

    func didTapParticipants(for trip: Trip?) {
        router.showParticipants(for: trip)
    }
}
