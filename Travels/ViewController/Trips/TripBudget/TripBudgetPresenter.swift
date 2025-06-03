//
//  TripBudgetPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripBudgetViewProtocol: AnyObject {
    func showError(message: String)
    func navigateToConfirmation()
}

final class TripBudgetPresenter {
    weak var view: TripBudgetViewProtocol?
    private let model: TripBudgetModelProtocol
    private let router: TripBudgetRouterProtocol
    var currentUser: User?

    init(view: TripBudgetViewProtocol, model: TripBudgetModelProtocol, router: TripBudgetRouterProtocol, currentUser: User?) {
        self.view = view
        self.model = model
        self.router = router
        self.currentUser = currentUser
    }

    func nextTapped(with budgetText: String?) {
        guard let text = budgetText, let budget = Double(text) else {
            view?.showError(message: "Введите корректный бюджет")
            return
        }

        model.saveBudget(budget)
        view?.navigateToConfirmation()
    }
}
