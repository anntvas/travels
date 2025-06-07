//
//  BudgetCategoriesModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol BudgetCategoriesModelProtocol {
    var availableCategories: [String] { get }
    func toggleCategorySelection(at index: Int)
    func getSelectedCategories() -> [BudgetCategoryModel]
    func isCategorySelected(at index: Int) -> Bool
}
final class BudgetCategoriesModel: BudgetCategoriesModelProtocol {
    let availableCategories = [
        "Билеты", "Отели", "Питание", "Развлечения",
        "Страховка", "Транспорт", "Подарки", "Другое"
    ]
    
    private var selectedCategories: [BudgetCategoryModel] = []
    
    func toggleCategorySelection(at index: Int) {
        let categoryName = availableCategories[index]
        
        if let existingIndex = selectedCategories.firstIndex(where: { $0.category == categoryName }) {
            selectedCategories.remove(at: existingIndex)
        } else {
            let newCategory = BudgetCategoryModel(category: categoryName, allocatedAmount: 0)
            selectedCategories.append(newCategory)
        }
    }
    
    func getSelectedCategories() -> [BudgetCategoryModel] {
        return selectedCategories
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        let categoryName = availableCategories[index]
        return selectedCategories.contains { $0.category == categoryName }
    }
}
