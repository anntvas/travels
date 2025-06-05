//
//  TripDetailsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripDetailsPresenterProtocol {
    func didTapNext(title: String?, from: String?, to: String?, startDate: String, endDate: String)
    func attachView(_ view: TripDetailsViewProtocol)
}

protocol TripDetailsViewProtocol: AnyObject {
    func showError(message: String)
}

final class TripDetailsPresenter {
    private weak var view: TripDetailsViewProtocol?
    private let model: TripDetailsModelProtocol
    private let router: TripDetailsRouterProtocol
    private let user: User?

    init(model: TripDetailsModelProtocol, router: TripDetailsRouterProtocol, user: User?) {
        self.model = model
        self.router = router
        self.user = user
    }

    func attachView(_ view: TripDetailsViewProtocol) {
        self.view = view
    }

    func didTapNext(title: String?, from: String?, to: String?, startDate: String, endDate: String) {
        guard let title = title, !title.isEmpty,
              let from = from, !from.isEmpty,
              let to = to, !to.isEmpty else {
            view?.showError(message: "Пожалуйста, заполните все поля")
            return
        }

        let tripRequest = TripRequest(
            title: title,
            description: "Летний отпуск с поездкой на море",
            startDate: startDate,
            endDate: endDate,
            departureCity: from,
            destinationCity: to,
            createdBy: Int64(user?.id ?? 0)
        )

        model.createTrip(tripRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tripResponse):
                    print("Поездка создана: \(tripResponse)")
                    self?.router.navigateToParticipants(user: self?.user)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
