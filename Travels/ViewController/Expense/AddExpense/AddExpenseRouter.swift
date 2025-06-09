//
//  AddExpenseRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol AddExpenseViewProtocol: AnyObject {
    func showValidationError(message: String)
    func showSaveSuccess()
    func showSaveError(message: String)
    func setCategories(_ categories: [String])
    func setSelectedCategory(_ category: String)
    func setParticipants(_ participants: [ParticipantResponse])
}

protocol AddExpensePresenterProtocol {
    func viewDidLoad()
    func saveExpense(
        title: String?,
        amount: String?,
        categoryIndex: Int,
        paidBy: String?,
        forWhom: String?
    )
//    func categorySelected(at index: Int)
}
