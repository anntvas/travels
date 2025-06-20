//
//  TripDetailsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripDetailsViewProtocol: AnyObject {
    func showValidationError(message: String)
    func showLoading()
    func hideLoading()
    func showTripCreationSuccess()
    func showTripCreationError(message: String)
}

protocol TripDetailsPresenterProtocol {
    func viewDidLoad()
    func nextButtonTapped(title: String?, fromCity: String?, toCity: String?, startDate: Date, endDate: Date)
}

final class TripDetailsPresenter: TripDetailsPresenterProtocol {
    private weak var view: TripDetailsViewProtocol?
    private let model: TripDetailsModelProtocol
    private let router: TripDetailsRouterProtocol
    private var tripId: Int?


    init(view: TripDetailsViewProtocol, model: TripDetailsModelProtocol, router: TripDetailsRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }

    func viewDidLoad() {}

    func nextButtonTapped(title: String?, fromCity: String?, toCity: String?, startDate: Date, endDate: Date) {
        guard let title = title, !title.isEmpty else {
            view?.showValidationError(message: "Введите название поездки")
            return
        }
        guard let fromCity = fromCity, !fromCity.isEmpty else {
            view?.showValidationError(message: "Введите город отправления")
            return
        }
        guard let toCity = toCity, !toCity.isEmpty else {
            view?.showValidationError(message: "Введите город назначения")
            return
        }
        guard startDate < endDate else {
            view?.showValidationError(message: "Дата начала должна быть раньше даты окончания")
            return
        }

        view?.showLoading()

        model.createTrip(
            title: title,
            fromCity: fromCity,
            toCity: toCity,
            startDate: startDate,
            endDate: endDate
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let trip):
                    self?.tripId = trip.id
                    print(trip.id)
                    self?.router.navigateToParticipants(tripId: trip.id)
                case .failure(let error):
                    self?.view?.showTripCreationError(message: error.localizedDescription)
                }
            }
        }
    }
}
