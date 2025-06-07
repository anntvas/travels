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
    private let user: User
    
    init(
        view: BudgetCategoriesViewProtocol,
        model: BudgetCategoriesModelProtocol,
        router: BudgetCategoriesRouterProtocol,
        user: User
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.user = user
    }
    
    func viewDidLoad() {
        // Начальная настройка не требуется
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        model.toggleCategorySelection(at: indexPath.row)
        view?.updateSelection(at: indexPath)
    }
    
    func didTapNextButton() {
        guard !model.getSelectedCategories().isEmpty else {
            view?.showValidationError(message: "Выберите хотя бы одну категорию")
            return
        }
        router.navigateToBudgetAllocation(with: user)
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
