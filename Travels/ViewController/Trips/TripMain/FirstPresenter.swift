//
//  FirstPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol FirstPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didTapCreateTrip()
    func didSelectTrip(_ trip: Trip)
    func showTripSelection()
}

protocol FirstViewProtocol: AnyObject {
    func displayTrips(current: Trip?, all: [Trip])
    func showError(_ message: String)
}

final class FirstPresenter: FirstPresenterProtocol {
    weak var view: FirstViewProtocol?
    private let model: FirstModelProtocol
    private let router: FirstRouterProtocol

    private var allTrips: [Trip] = []
    private var currentTrip: Trip?

    init(model: FirstModelProtocol, router: FirstRouterProtocol) {
        self.model = model
        self.router = router
    }

    func viewDidLoad() {
        loadTrips()
    }

    func viewWillAppear() {
        loadTrips()
    }

    func didTapCreateTrip() {
        router.openCreateTrip()
    }

    func didSelectTrip(_ trip: Trip) {
        currentTrip = trip
        view?.displayTrips(current: currentTrip, all: allTrips)
    }

    func showTripSelection() {
        view?.displayTrips(current: currentTrip, all: allTrips)
    }

    private func loadTrips() {
        model.fetchTrips { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trips):
                    self?.allTrips = trips
                    self?.currentTrip = trips.first
                    self?.view?.displayTrips(current: self?.currentTrip, all: trips)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
