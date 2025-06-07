//
//  DebtsModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol DebtsModelProtocol {
    func fetchDebts() -> [String]
}

final class DebtsModel: DebtsModelProtocol {
    func fetchDebts() -> [String] {
        // Пока мок, но здесь может быть CoreData/сеть
        return [
            "Вы должны Ане 500 ₽",
            "Дима должен вам 800 ₽"
        ]
    }
}
