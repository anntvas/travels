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
            case .success(let trips):
                self?.view?.displayTrips(trips)
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
