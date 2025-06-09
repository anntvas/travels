//
//  SecondPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import CoreData
import UIKit

protocol SecondViewProtocol: AnyObject {
    func displayTrips(_ trips: [Trip])
    func showError(message: String)
}

protocol SecondPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func addTripTapped()
    func didSelectTrip(_ trip: Trip)
    func confirmTrip(tripId: Int)
    func cancelTrip(tripId: Int)
}

final class SecondPresenter: SecondPresenterProtocol {
    weak var view: SecondViewProtocol?
    private let model: SecondModelProtocol
    private let router: SecondRouterProtocol
    
    private var currentUser: User?
    
    init(model: SecondModelProtocol, router: SecondRouterProtocol) {
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        model.loadCurrentUser { [weak self] user in
            self?.currentUser = user
        }
    }
    
    func viewWillAppear() {
        fetchTrips()
    }
    
    func addTripTapped() {
        router.openCreateTrip()
    }
    
    func didSelectTrip(_ trip: Trip) {
        router.showTripDetails(trip)
    }
    
    private func fetchTrips() {
        model.fetchTrips { [weak self] result in
            switch result {
            case .success(let (pendingResponses, confirmedResponses)):
                let pendingTrips = pendingResponses.map { self?.convertTripResponsePending($0) }.compactMap { $0 }
                let confirmedTrips = confirmedResponses.map { self?.convertTripResponseConfirmed($0) }.compactMap { $0 }
                let combinedTrips = pendingTrips + confirmedTrips
                self?.view?.displayTrips(combinedTrips)
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    private func convertTripResponsePending(_ response: TripResponse) -> Trip {
        let trip = Trip(context: DataController.shared.context)
        trip.id = Int64(response.id)
        trip.title = response.title
        trip.departureCity = response.departureCity
        trip.destinationCity = response.destinationCity
        trip.startDate = dateFromString(response.startDate)
        trip.endDate = dateFromString(response.endDate)
        trip.status = .pending
        return trip
    }
    
    private func convertTripResponseConfirmed(_ response: TripResponse) -> Trip {
        let trip = Trip(context: DataController.shared.context)
        trip.id = Int64(response.id)
        trip.title = response.title
        trip.departureCity = response.departureCity
        trip.destinationCity = response.destinationCity
        trip.startDate = dateFromString(response.startDate)
        trip.endDate = dateFromString(response.endDate)
        trip.status = .confirmed
        return trip
    }
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }

    func confirmTrip(tripId: Int) {
        model.confirmParticipation(tripId: tripId) { [weak self] result in
            switch result {
            case .success:
                // Optionally refresh trips or update UI
                self?.fetchTrips()
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func cancelTrip(tripId: Int) {
        model.cancelParticipation(tripId: tripId) { [weak self] result in
            switch result {
            case .success:
                self?.fetchTrips()
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
}
