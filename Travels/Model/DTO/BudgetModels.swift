//
//  BudgetModels.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

struct BudgetCategoryRequest: Codable {
    let category: String
    let allocatedAmount: Double
}

struct BudgetRequest: Codable {
    let totalBudget: Double
    let categories: [BudgetCategoryRequest]
}

struct BudgetCategoryResponse: Codable {
    let category: String
    let allocatedAmount: Double
}

struct BudgetResponse: Codable {
    let totalBudget: Double
    let categories: [BudgetCategoryResponse]
}
