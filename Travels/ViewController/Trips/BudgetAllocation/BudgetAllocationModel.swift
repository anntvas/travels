//
//  BudgetAllocationModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol BudgetAllocationModelProtocol {
    var categories: [BudgetCategoryModel] { get set }
    var totalBudget: Double { get }

    func allocatedAmount() -> Double
    func postBudgetToServer(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func reset()
}

final class BudgetAllocationModel: BudgetAllocationModelProtocol {
    var categories: [BudgetCategoryModel]
    let totalBudget: Double

    init(budgetRequest: BudgetRequest) {
        self.categories = budgetRequest.categories.map {
            BudgetCategoryModel(category: $0.category, allocatedAmount: $0.allocatedAmount)
        }
        self.totalBudget = budgetRequest.totalBudget
    }

    func allocatedAmount() -> Double {
        return categories.reduce(0) { $0 + $1.allocatedAmount }
    }

    func postBudgetToServer(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = BudgetRequest(
            totalBudget: totalBudget,
            categories: categories.map {
                BudgetCategoryRequest(category: $0.category, allocatedAmount: $0.allocatedAmount)
            }
        )

        NetworkManager.shared.setBudget(tripId: tripId, request: request, completion: completion)
    }

    func reset() {
        categories.removeAll()
    }
}
