//
//  TripDetailsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripDetailsViewProtocol: AnyObject {
    func showError(message: String)
    func goToParticipants(for user: User?)
}

final class TripDetailsPresenter {
    weak var view: TripDetailsViewProtocol?
    private let model: TripDetailsModelProtocol
    private let router: TripDetailsRouterProtocol
    private let user: User?

    init(view: TripDetailsViewProtocol, model: TripDetailsModelProtocol, router: TripDetailsRouterProtocol, user: User?) {
        self.view = view
        self.model = model
        self.router = router
        self.user = user
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
                    self?.view?.goToParticipants(for: self?.user)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
