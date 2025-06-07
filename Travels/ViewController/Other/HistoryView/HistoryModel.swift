//
//  HistoryModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol HistoryModelProtocol: AnyObject {
    func fetchHistory() -> [String]
    func clearAll()
}

final class HistoryModel: HistoryModelProtocol {
    private var history: [String] = [
        "Вы добавили расход 1500 ₽",
        "Создана новая поездка в Казань"
    ]
    
    func fetchHistory() -> [String] {
        return history
    }
    
    func clearAll() {
        history.removeAll()
    }
}
