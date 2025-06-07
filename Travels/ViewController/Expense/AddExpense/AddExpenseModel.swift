//
//  AddExpenseModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol AddExpenseModelProtocol {
    var categories: [String] { get }
    func saveExpense(
        title: String,
        amount: Double,
        category: String,
        paidBy: String,
        forWhom: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class AddExpenseModel: AddExpenseModelProtocol {
    let categories = [
        "Билеты", "Отели", "Питание", "Развлечения",
        "Страховка", "Транспорт", "Подарки", "Другое"
    ]
    
    func saveExpense(
        title: String,
        amount: Double,
        category: String,
        paidBy: String,
        forWhom: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Здесь будет логика сохранения в CoreData или отправки на сервер
        // Заглушка для примера
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // В реальном приложении:
            // 1. Сохранение в CoreData
            // 2. Отправка на сервер (если нужно)
            // 3. Обработка ошибок
            
            // Для примера - всегда успешное сохранение
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
    }
}
