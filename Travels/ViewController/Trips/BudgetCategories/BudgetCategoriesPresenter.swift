//
//  BudgetCategoriesPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol BudgetCategoriesViewProtocol: AnyObject {
    func reloadTableView()
    func showValidationError(message: String)
    func updateSelection(at indexPath: IndexPath)
}
protocol BudgetCategoriesPresenterProtocol {
    func viewDidLoad()
    func didSelectCategory(at indexPath: IndexPath)
    func didTapNextButton()
    func numberOfCategories() -> Int
    func categoryName(at index: Int) -> String
    func isCategorySelected(at index: Int) -> Bool
}
final class BudgetCategoriesPresenter: BudgetCategoriesPresenterProtocol {
    weak var view: BudgetCategoriesViewProtocol?
    private let model: BudgetCategoriesModelProtocol
    private let router: BudgetCategoriesRouterProtocol
    private let tripId: Int
    private var budgetRequest: BudgetRequest
    
    init(
        view: BudgetCategoriesViewProtocol,
        model: BudgetCategoriesModelProtocol,
        router: BudgetCategoriesRouterProtocol,
        tripId: Int,
        budgetRequest: BudgetRequest
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.tripId = tripId
        self.budgetRequest = budgetRequest
    }
    
    func viewDidLoad() {
        // Начальная настройка не требуется
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        model.toggleCategorySelection(at: indexPath.row)
        view?.updateSelection(at: indexPath)
    }
    
    func didTapNextButton() {
        let selectedModels = model.getSelectedCategories()

        // Преобразуем к типу BudgetCategoryRequest
        let categoryRequests: [BudgetCategoryRequest] = selectedModels.map {
            BudgetCategoryRequest(category: $0.category, allocatedAmount: 0)
        }

        // Создаём новый BudgetRequest
        let updatedRequest = BudgetRequest(
            totalBudget: budgetRequest.totalBudget,
            categories: categoryRequests
        )

        router.navigateToBudgetAllocation(tripId: tripId, budgetRequest: updatedRequest)

    }

    
    func numberOfCategories() -> Int {
        return model.availableCategories.count
    }
    
    func categoryName(at index: Int) -> String {
        return model.availableCategories[index]
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        return model.isCategorySelected(at: index)
    }
}
