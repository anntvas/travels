//
//  ExpenseDetailModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol ExpenseDetailModelProtocol: AnyObject {
    func fetchExpenses() -> [ExpenseDetail]
}

final class ExpenseDetailModel: ExpenseDetailModelProtocol {
    func fetchExpenses() -> [ExpenseDetail] {
        return [
            ExpenseDetail(name: "Вы", amount: -52000, category: "Отель", time: "11:11", isCurrentUser: true, date: nil),
            ExpenseDetail(name: "Олег", amount: -2000, category: "Питание", time: "20:33", isCurrentUser: false, date: nil),
            ExpenseDetail(name: "Анастасия", amount: -2000, category: "Питание", time: "20:33", isCurrentUser: false, date: "31 марта")
        ]
    }
}
