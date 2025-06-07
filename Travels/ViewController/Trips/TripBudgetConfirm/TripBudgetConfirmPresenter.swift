//
//  TripBudgetConfirmPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol TripBudgetConfirmViewProtocol: AnyObject {
    func displayBudget(_ budget: Double)
}
protocol TripBudgetConfirmPresenterProtocol {
    func viewDidLoad()
    func didTapConfirmButton()
}

final class TripBudgetConfirmPresenter: TripBudgetConfirmPresenterProtocol {
    weak var view: TripBudgetConfirmViewProtocol?
    private let model: TripBudgetConfirmModelProtocol
    private let router: TripBudgetConfirmRouterProtocol
    private let user: User
    
    init(
        view: TripBudgetConfirmViewProtocol,
        model: TripBudgetConfirmModelProtocol,
        router: TripBudgetConfirmRouterProtocol,
        user: User
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.user = user
    }
    
    func viewDidLoad() {
        view?.displayBudget(model.totalBudget)
    }
    
    func didTapConfirmButton() {
        router.navigateToBudgetCategories(with: user)
    }
}
