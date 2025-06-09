//
//  AddExpenseModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//
import Foundation

protocol AddExpenseModelProtocol {
    func saveExpense(
        title: String,
        amount: Double,
        categoryId: Int,
        paidById: Int,
        beneficiaryIds: [Int],
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func fetchBudgetCategories(completion: @escaping (Result<[BudgetCategoryLookup], Error>) -> Void)

    func fetchParticipants(completion: @escaping (Result<[ParticipantResponse], Error>) -> Void)

}

final class AddExpenseModel: AddExpenseModelProtocol {
    private let tripId: Int
    private let networkManager: NetworkManagerProtocol

    init(tripId: Int, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.tripId = tripId
        self.networkManager = networkManager
    }

    func saveExpense(
        title: String,
        amount: Double,
        categoryId: Int,
        paidById: Int,
        beneficiaryIds: [Int],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let request = ExpenseRequest(
            description: title,
            amount: amount,
            paidBy: paidById,
            category: categoryId,
            beneficiaries: beneficiaryIds
        )

        networkManager.addExpense(tripId: tripId, request: request, completion: completion)
    }

    func fetchBudgetCategories(completion: @escaping (Result<[BudgetCategoryLookup], Error>) -> Void) {
        networkManager.getAllBudgetCategories(completion: completion)
    }

    func fetchParticipants(completion: @escaping (Result<[ParticipantResponse], Error>) -> Void) {
        networkManager.fetchParticipants(tripId: tripId, completion: completion)
    }
}
