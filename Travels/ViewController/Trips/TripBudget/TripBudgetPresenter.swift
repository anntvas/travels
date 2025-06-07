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
    private var tripId: Int
    
    init(
        view: TripBudgetViewProtocol,
        model: TripBudgetModelProtocol,
        router: TripBudgetRouterProtocol,
        tripId: Int
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.tripId = tripId
    }
    
    func viewDidLoad() {
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
        
        let request = BudgetRequest(
            totalBudget: budget,
            categories: []
        )
        router.navigateToBudgetConfirm(tripId: tripId, budget: request)
    }
}
