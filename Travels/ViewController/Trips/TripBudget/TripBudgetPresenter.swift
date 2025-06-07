//
//  TripBudgetPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripBudgetViewProtocol: AnyObject {
    func showValidationError(message: String)
    func setInitialBudget(_ budget: Double?)
}
protocol TripBudgetPresenterProtocol {
    func viewDidLoad()
    func didTapNextButton(budgetText: String?)
}

final class TripBudgetPresenter: TripBudgetPresenterProtocol {
    weak var view: TripBudgetViewProtocol?
    private let model: TripBudgetModelProtocol
    private let router: TripBudgetRouterProtocol
    private let user: User
    
    init(
        view: TripBudgetViewProtocol,
        model: TripBudgetModelProtocol,
        router: TripBudgetRouterProtocol,
        user: User
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.user = user
    }
    
    func viewDidLoad() {
        if let currentBudget = model.getCurrentBudget() {
            view?.setInitialBudget(currentBudget)
        }
    }
    
    func didTapNextButton(budgetText: String?) {
        guard let budgetText = budgetText, !budgetText.isEmpty else {
            view?.showValidationError(message: "Введите бюджет")
            return
        }
        
        guard let budget = Double(budgetText), budget > 0 else {
            view?.showValidationError(message: "Введите корректный бюджет")
            return
        }
        
        model.saveBudget(budget)
        router.navigateToBudgetConfirm(with: user)
    }
}
