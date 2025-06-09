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
    private var categoryLookup: [BudgetCategoryLookup] = []

    init(view: AddExpenseViewProtocol, model: AddExpenseModelProtocol) {
        self.view = view
        self.model = model
    }

    func viewDidLoad() {
        model.fetchBudgetCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categoryLookup = categories
                let names = categories.map { $0.name }
                DispatchQueue.main.async {
                    self?.view?.setCategories(names)
                }
            case .failure(let error):
                print("Ошибка загрузки категорий: \(error.localizedDescription)")
            }
        }

        model.fetchParticipants { [weak self] result in
            switch result {
            case .success(let participants):
                DispatchQueue.main.async {
                    self?.view?.setParticipants(participants)
                }
            case .failure(let error):
                print("Ошибка загрузки участников: \(error.localizedDescription)")
            }
        }
    }

    func saveExpense(
        title: String?,
        amount: String?,
        categoryIndex: Int,
        paidBy: String?,
        forWhom: String?
    ) {
        guard let title = title, !title.isEmpty else {
            view?.showValidationError(message: "Введите название расхода")
            return
        }
        guard let amountStr = amount, let amount = Double(amountStr), amount > 0 else {
            view?.showValidationError(message: "Введите корректную сумму")
            return
        }
        guard categoryIndex >= 0 && categoryIndex < categoryLookup.count else {
            view?.showValidationError(message: "Выберите категорию")
            return
        }
        let categoryId = categoryLookup[categoryIndex].id

        guard let paidBy = paidBy, let paidById = Int(paidBy) else {
            view?.showValidationError(message: "Некорректный ID оплатившего")
            return
        }

        guard let forWhom = forWhom, !forWhom.isEmpty else {
            view?.showValidationError(message: "Введите ID бенефициаров через запятую")
            return
        }

        let beneficiaryIds = forWhom
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        model.saveExpense(
            title: title,
            amount: amount,
            categoryId: categoryId,
            paidById: paidById,
            beneficiaryIds: beneficiaryIds
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
}
