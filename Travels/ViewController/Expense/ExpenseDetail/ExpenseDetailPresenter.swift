//
//  ExpenseDetailPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol ExpenseDetailViewProtocol: AnyObject {
    func showExpenses(_ expenses: [ExpenseDetail])
}

protocol ExpenseDetailPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func addExpenseTapped()
}

final class ExpenseDetailPresenter: ExpenseDetailPresenterProtocol {
    private weak var view: ExpenseDetailViewProtocol?
    private let model: ExpenseDetailModelProtocol

    init(view: ExpenseDetailViewProtocol, model: ExpenseDetailModelProtocol) {
        self.view = view
        self.model = model
    }

    func onViewDidLoad() {
        let expenses = model.fetchExpenses()
        view?.showExpenses(expenses)
    }

    func addExpenseTapped() {
        // TODO: реализовать переход к экрану добавления расхода
        print("Переход на экран добавления расхода")
    }
}
