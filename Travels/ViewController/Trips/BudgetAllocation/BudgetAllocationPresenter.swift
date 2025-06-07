//
//  BudgetAllocationPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
protocol BudgetAllocationViewProtocol: AnyObject {
    func updateTotalLabels(total: String, remaining: String, remainingColor: UIColor)
    func showValidationError(title: String, message: String)
    func showSyncSuccess()
    func showSyncError(message: String)
    func reloadTableView()
}

protocol BudgetAllocationPresenterProtocol {
    var totalBudget: Double { get }
    func viewDidLoad()
    func didTapNextButton()
    func numberOfCategories() -> Int
    func category(at index: Int) -> BudgetCategoryModel
    func didUpdateAmount(_ amount: Double, forCategoryAt index: Int)
    func reset() // Добавляем этот метод
}

final class BudgetAllocationPresenter: BudgetAllocationPresenterProtocol {
    weak var view: BudgetAllocationViewProtocol?
    private var model: BudgetAllocationModelProtocol
    private let router: BudgetAllocationRouterProtocol
    
    var totalBudget: Double {
        return model.totalBudget
    }
    
    init(
        view: BudgetAllocationViewProtocol,
        model: BudgetAllocationModelProtocol,
        router: BudgetAllocationRouterProtocol
    ) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        updateTotalLabels()
    }
    
    func didTapNextButton() {
        let allocated = model.allocatedAmount()
        
        guard allocated > 0 else {
            view?.showValidationError(
                title: "Ошибка",
                message: "Распределите бюджет по категориям"
            )
            return
        }
        
        guard abs(allocated - totalBudget) < 0.01 else {
            view?.showValidationError(
                title: "Ошибка",
                message: "Сумма по категориям (\(allocated.formattedWithSeparator) ₽) должна равняться общему бюджету (\(totalBudget.formattedWithSeparator) ₽)"
            )
            return
        }
        
//        createTrip()
    }
    
//    private func createTrip() {
//        switch model.createTrip() {
//        case .success:
//            model.syncTrip { [weak self] success in
//                DispatchQueue.main.async {
//                    if success {
//                        self?.view?.showSyncSuccess()
//                    } else {
//                        self?.view?.showSyncError(
//                            message: "Данные сохранены локально, но не синхронизированы с сервером"
//                        )
//                    }
//                }
//            }
//        case .failure(let error):
//            view?.showValidationError(
//                title: "Ошибка создания",
//                message: error.localizedDescription
//            )
//        }
//    }
    
    func numberOfCategories() -> Int {
        return model.categories.count
    }
    
    func category(at index: Int) -> BudgetCategoryModel {
        return model.categories[index]
    }
    
    func didUpdateAmount(_ amount: Double, forCategoryAt index: Int) {
        model.categories[index].allocatedAmount = amount
        updateTotalLabels()
    }
    
    private func updateTotalLabels() {
        let allocated = model.allocatedAmount()
        let remaining = totalBudget - allocated
        
        view?.updateTotalLabels(
            total: "Общий бюджет: \(totalBudget.formattedWithSeparator) ₽",
            remaining: "Остаток: \(remaining.formattedWithSeparator) ₽",
            remainingColor: remaining < 0 ? .systemRed : .systemGreen
        )
    }
    
    func reset() {
        model.reset()
    }
}
