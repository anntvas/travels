//
//  FirstPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol FirstPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didTapCreateTrip()
    func didSelectTrip(_ trip: Trip)
    func showTripSelection()
    func didTapCard(with tag: Int)
}

protocol FirstViewProtocol: AnyObject {
    func displayTrips(current: Trip?, all: [Trip])
    func displayTripSelection(trips: [Trip])
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
        // Fetch budget for the selected trip
        model.fetchTripBudget(tripId: Int(trip.id)) { [weak self] budgetResult in
            DispatchQueue.main.async {
                switch budgetResult {
                case .success(let totalBudget):
                    trip.budgetEntity = BudgetEntity(totalBudget: totalBudget)
                case .failure:
                    break
                }
                self?.view?.displayTrips(current: trip, all: self?.allTrips ?? [])
            }
        }
    }
    

    
    func showTripSelection() {
        view?.displayTripSelection(trips: allTrips)
    }
    

    private func loadTrips() {
        model.fetchTrips { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trips):
                    self?.allTrips = trips
                    guard let trip = trips.first else {
                        self?.view?.displayTrips(current: nil, all: [])
                        return
                    }

                    self?.currentTrip = trip

                    // 👉 загружаем budget отдельно
                    self?.model.fetchTripBudget(tripId: Int(trip.id)) { budgetResult in
                        DispatchQueue.main.async {
                            switch budgetResult {
                            case .success(let totalBudget):
                                trip.budgetEntity = BudgetEntity(totalBudget: totalBudget)
                            case .failure:
                                break // можно логировать, но не критично
                            }
                            self?.view?.displayTrips(current: trip, all: trips)
                        }
                    }

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapCard(with tag: Int) {
        switch tag {
        case 0:
            router.showOperations(for: currentTrip)
        case 1:
            router.showParticipants(for: currentTrip)
        case 2:
            router.showBudget(for: currentTrip)
        case 3:
            router.showMyExpenses(for: currentTrip)
        case 4:
            router.showMyDebts(for: currentTrip)
        case 5:
            router.showOwedToMe(for: currentTrip)
        default:
            break
        }
    }
}

struct BudgetEntity {
    let totalBudget: Double
}
