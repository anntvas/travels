//
//  AddExpensePresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

final class AddExpensePresenter: AddExpensePresenterProtocol {
    weak var view: AddExpenseViewProtocol?
    private let model: AddExpenseModelProtocol
    
    var categories: [String] {
        return model.categories
    }
    
    init(view: AddExpenseViewProtocol, model: AddExpenseModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.setCategories(model.categories)
        if !model.categories.isEmpty {
            view?.setSelectedCategory(model.categories[0])
        }
    }
    
    func saveExpense(
        title: String?,
        amount: String?,
        categoryIndex: Int,
        paidBy: String?,
        forWhom: String?
    ) {
        // Валидация данных
        guard let title = title, !title.isEmpty else {
            view?.showValidationError(message: "Введите название расхода")
            return
        }
        
        guard let amountString = amount,
              let amount = Double(amountString),
              amount > 0 else {
            view?.showValidationError(message: "Введите корректную сумму")
            return
        }
        
        guard categoryIndex >= 0 && categoryIndex < model.categories.count else {
            view?.showValidationError(message: "Выберите категорию")
            return
        }
        
        let category = model.categories[categoryIndex]
        
        guard let paidBy = paidBy, !paidBy.isEmpty else {
            view?.showValidationError(message: "Укажите, кто оплатил")
            return
        }
        
        guard let forWhom = forWhom, !forWhom.isEmpty else {
            view?.showValidationError(message: "Укажите, за кого оплачено")
            return
        }
        
        // Сохранение данных
        model.saveExpense(
            title: title,
            amount: amount,
            category: category,
            paidBy: paidBy,
            forWhom: forWhom
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.showSaveSuccess()
                case .failure(let error):
                    self?.view?.showSaveError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func categorySelected(at index: Int) {
        guard index >= 0 && index < model.categories.count else { return }
        view?.setSelectedCategory(model.categories[index])
    }
}
